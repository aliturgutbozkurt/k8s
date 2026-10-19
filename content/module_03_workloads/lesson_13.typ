#import "/template.typ": *

#show: doc => setup_book(title: "Ders 13: ReplicaSet ve Deployment: Ölümsüz Pod'lar", doc)

#lesson_header(
  13,
  "ReplicaSet ve Deployment: Ölümsüz Pod'lar",
  "ReplicaSet and Deployment: Self-Healing Pods",
  "K8s İş Yükleri & Dayanıklılık",
  "K8s Workloads & Self-Healing Resilience"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Tek başına bir Pod sokakta sahipsiz kalmış bir kedi yavrusu gibidir; arabaya çarparsa (çökerse) kimse arkasından ağlamaz! Deployment ise o kediye bakan 24 saat nöbetteki koruyucu melek ordusudur. 'Ben burada her zaman 3 adet sağlıklı Spring Boot kedisi istiyorum' dersiniz. Biri uyuyakalır veya ölürse, Deployment anında yenisini doğurur!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[A bare Pod is an unprotected orphan: if it crashes, nobody sheds a tear! A Deployment is its 24/7 guardian angel. You declare: 'I want exactly 3 healthy Spring Boot pods at all times.' If one pod gets killed or its server explodes, the Deployment controller instantly breathes life into an identical replacement!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Üretim ortamında neredeyse HİÇBİR ZAMAN çıplak Pod (bare pod) oluşturulmaz; her zaman Deployment kullanılır. Deployment hiyerarşisi şöyledir: Deployment -> ReplicaSet -> Pods. Deployment, yeni sürümler çıktığında yeni bir ReplicaSet açarak eski ReplicaSet'teki pod'ları kademeli olarak azaltır (Rolling Update). `spec.replicas` sayısı etcd'deki Desired State'tir. Pod çöktüğünde ReplicaSet controller bunu anında fark edip yeni bir Pod talebi oluşturur.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Bare pods are strictly anti-pattern in production; Deployments are mandatory. The architecture follows a strict hierarchy: Deployment -> ReplicaSet -> Pods. The Deployment controller manages declarative updates by spinning up a new ReplicaSet while scaling down the old one. If a container crashes, the Kubelet or ReplicaSet reconciles Pod counts back to the declared replica integer.]
    ]
  )
]

#spring_box[
```yaml
# spring-boot-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coffee-deployment
  labels:
    app: coffee-app
spec:
  replicas: 3 # 3 adet yedekli pod çalıştır
  selector:
    matchLabels:
      app: coffee-app
  template:
    metadata:
      labels:
        app: coffee-app
    spec:
      containers:
        - name: coffee-container
          image: ghcr.io/eli5-k8s/spring-boot-k8s-eli5:1.0.0
          ports:
            - containerPort: 8080
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Deployment'ın `matchLabels` ile Pod şablonundaki (`template.metadata.labels`) etiketler birebir AYNI olmalıdır! Uyuşmazsa Deployment oluşturduğu pod'ları tanıyamaz ve sonsuz döngüde pod basmaya başlar.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[The `spec.selector.matchLabels` MUST match `spec.template.metadata.labels` identically. A mismatch causes the controller to lose track of its pods and trigger endless creation loops.]
    ]
  )
]

#takeaways_box((
    ("Deployment, pod'ların çökmesi durumunda anında kendi kendini iyileştirir.", "Deployments guarantee self-healing: dead pods are instantly replaced."),
    ("Arka planda ReplicaSet nesneleri sürüm geçmişini ve kopya sayısını yönetir.", "ReplicaSets handle the low-level replica counting and historical revisions."),
    ("Tek bir komutla (`kubectl scale deployment ... --replicas=5`) anında ölçeklenir.", "Scale your fleet on demand with `kubectl scale deployment --replicas=N`."),
))
