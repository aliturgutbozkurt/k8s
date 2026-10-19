#import "/template.typ": *

#show: doc => setup_book(title: "Ders 43: Operator Deseni Nedir? (Bir SRE Mühendisinin Beynini Koda Dökmek)", doc)

#lesson_header(
  43,
  "Operator Deseni Nedir? (Bir SRE Mühendisinin Beynini Koda Dökmek)",
  "The Operator Pattern: Automating the Human SRE",
  "Kubernetes Operators — Kendi Akıllı Robotunu Kodla",
  "Kubernetes Operators — Build Your Own Robot SRE"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Şirketinizde çalışan kıdemli bir veritabanı uzmanını düşünün: Gece saat 03:00'te ana veritabanı çöktüğünde uyanır, yedek sunucuyu lider yapar, verileri eşitler, eski sunucuyu tamir edip havuza sokar. İnsan yorulur, uyur, hata yapar. Bir 'Operator' ise bu kıdemli mühendisin beynindeki tüm kuralları ve tecrübeyi 7/24 uykusuz çalışan bir yazılım robotuna dönüştürmektir!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Picture a veteran database administrator in your company: When the primary database crashes at 3 AM, they wake up, promote the replica to master, synchronize data, and heal the cluster. Humans get sleepy and make typos. An 'Operator' is encapsulating that human engineer's operational wisdom into software code running 24/7 without ever taking a coffee break!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Kubernetes standart olarak Deployment ve Service gibi temel durumsuz (stateless) iş yüklerini mükemmel yönetir. Ancak PostgreSQL, Kafka veya Redis gibi durum tutan (stateful) sistemler; sürüm yükseltme, otomatik yedekleme (backup), felaketten kurtarma (failover) ve şema göçü gibi alana özgü (domain-specific) karmaşık mantıklar gerektirir. Operator Pattern = Özel Kaynak Tanımı (CRD) + Özel Kontrolcü (Custom Controller).
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Kubernetes manages stateless workloads natively via Deployments. Stateful distributed systems (Postgres, Kafka, RabbitMQ) require domain-specific operational knowledge for backups, failover, and cluster topology negotiations. The Operator Pattern bridges this gap by combining: Custom Resource Definitions (CRD) to store desired state, and a Custom Controller executing reconciliation loops.]
    ]
  )
]

#spring_box[
```yaml
# Operatörsüz manuel çile (50 adımda Postgres kümesi yönetimi):
# 1. SSH yap, 2. pg_dump al, 3. failover komutu ver...

# Operatör ile tek satırda otomatik küme ve yedekleme:
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: coffee-db-cluster
spec:
  instances: 3 # 3 düğümlü otomatik failover özellikli PostgreSQL!
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Her şey için operatör yazmaya kalkmayın! Eğer uygulamanız standart bir REST API veya durumsuz mikroservis ise, standart bir K8s Deployment fazlasıyla yeterlidir. Operatörler karmaşık durum yönetimi (stateful) için tasarlanmıştır.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Do not write operators for simple stateless apps! Standard Deployments are sufficient for 95% of microservices. Reserve operators for complex stateful automation.]
    ]
  )
]

#takeaways_box((
    ("Operator Deseni insan uzmanlığını yazılım otomasyonuna dönüştürür.", "The Operator pattern translates human operational expertise into automated software."),
    ("Veritabanı yedeği, failover ve küme senkronizasyonunu otonom yönetir.", "Automates complex stateful operations like failover, resizing, and backups."),
    ("CNCF ekosistemindeki en güçlü ve gelişmiş K8s genişletme mimarisidir.", "The premier architectural pattern for extending the native Kubernetes control plane."),
))
