#import "/template.typ": *

#show: doc => setup_book(title: "Ders 14: Sıfır Kesintiyle Güncelleme (Rolling Updates & Rollbacks)", doc)

#lesson_header(
  14,
  "Sıfır Kesintiyle Güncelleme (Rolling Updates & Rollbacks)",
  "Zero-Downtime Deployments: Rolling Updates & Rollbacks",
  "K8s İş Yükleri & Dayanıklılık",
  "K8s Workloads & Self-Healing Resilience"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      200 km hızla giden bir yolcu treninde yolcuların çayı dökülmeden vagonları tek tek yenisiyle değiştirdiğinizi hayal edin! Rolling Update budur: 1 yeni vagon ekle, yolcuları oraya al, 1 eski vagonu emekli et. Yeni vagon bozuk çıkarsa tek bir düğmeye (`undo`) basarsınız ve saniyesinde eski vagonlara geri dönülür!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Imagine replacing train cars on a locomotive speeding at 200 km/h without spilling a single passenger's hot tea! That is a Rolling Update: add 1 new modern carriage, move passengers, retire 1 old carriage. And if the new carriage has broken AC, press one panic button (`rollout undo`), and K8s reverts back instantly!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Deployment varsayılan strateji olarak `RollingUpdate` kullanır. İki kritik parametre vardır: 1) `maxSurge` (Güncelleme esnasında istenen kopya sayısının üzerine kaç ekstra pod açılabileceği; örn: %25 veya 1), 2) `maxUnavailable` (Güncelleme sırasında kaç pod'un geçici olarak devre dışı kalabileceği; 0 yapılırsa HİÇBİR ZAMAN servis kesintisi yaşanmaz). Hata durumunda `kubectl rollout undo deployment/coffee-deployment` ile anında önceki stabil ReplicaSet'e geri dönülür.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[RollingUpdate configuration governs zero downtime via two levers: 1) `maxSurge` (maximum pods created beyond desired replica target), 2) `maxUnavailable` (maximum pods that can be taken down during the roll). Setting `maxUnavailable: 0` ensures 100% capacity during deployments. Instant recovery is guaranteed via `kubectl rollout undo`.]
    ]
  )
]

#spring_box[
```bash
# Sıfır Kesinti Stratejisi Tanımı:
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0

# Sürüm Güncelleme:
kubectl set image deployment/coffee-deployment coffee-container=ghcr.io/eli5-k8s/spring-boot-k8s-eli5:2.0.0

# Durumu Canlı Takip Et:
kubectl rollout status deployment/coffee-deployment

# Hata Anında Tek Tuşla Geri Al (Rollback):
kubectl rollout undo deployment/coffee-deployment
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Eğer yeni sürümdeki Spring Boot uygulamanız veritabanında geriye dönük uyumsuz (breaking change) bir tablo şeması değişikliği yaparsa, K8s seviyesinde rollback yapsanız bile veritabanınız çökmüş kalır! Veritabanı şemaları her zaman geriye dönük uyumlu (expand and contract) olmalıdır.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Kubernetes rollbacks cannot un-break a destructive database migration! Database schema changes must always maintain backward compatibility across rolling versions.]
    ]
  )
]

#takeaways_box((
    ("`maxUnavailable: 0` ile sıfır kesintili (zero-downtime) sürümler garanti edilir.", "`maxUnavailable: 0` ensures capacity never dips below the replica threshold."),
    ("Tüm dağıtım adımları `kubectl rollout status` ile canlı izlenebilir.", "Monitor rollout health live using `kubectl rollout status`."),
    ("Tek bir komutla (`rollout undo`) saniyeler içinde eski sürüme dönülebilir.", "Instant rollbacks undo broken releases in seconds without redeploying code."),
))
