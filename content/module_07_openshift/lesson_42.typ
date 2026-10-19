#import "/template.typ": *

#show: doc => setup_book(title: "Ders 42: Source-to-Image (S2I) ile Spring Boot Kodunu Otomatik Dağıtma", doc)

#lesson_header(
  42,
  "Source-to-Image (S2I) ile Spring Boot Kodunu Otomatik Dağıtma",
  "Deploying Spring Boot via Source-to-Image (S2I) & Binary Builds",
  "Red Hat OpenShift (OCP) — Kurumsal Kubernetes",
  "Red Hat OpenShift (OCP) — Enterprise Kubernetes"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Dockerfile yazmayı bile bilmeyen bir yazılımcı düşünün! OpenShift'e der ki: 'Al abi benim GitHub depomun linki burada, Java kodlarım içinde.' OpenShift sihirbaz gibi devreye girer: Kodu çeker, içine Maven ve JDK koyup derler, JAR'ı üretir, hafif bir runtime konteynerine koyar ve tek bir komutla canlıya alır! Buna S2I (Source-to-Image) denir!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Imagine a developer who has never written a Dockerfile in their life! They say to OpenShift: 'Here is my GitHub repository URL containing Java code.' OpenShift acts like a wizard: it clones the repo, provisions a Maven builder, compiles the JAR, bakes a lean container image, and deploys it in one breath! That is S2I (Source-to-Image)!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      S2I mimarisi üç nesne ile çalışır: 1) `BuildConfig` (Derleme stratejisini, Git kaynağını ve tetikleyicileri tanımlar), 2) `ImageStream` (İmaj sürümlerini sanal olarak etiketleyen ve yeni imaj geldiğinde otomatik dağıtım tetikleyen soyutlama), 3) Builder Image (Red Hat'in sağladığı optimize `ubi8/openjdk-21`). Ayrıca lokaldeki `.jar` dosyasını doğrudan göndermek için 'Binary Build' (`oc start-build --from-file=target/app.jar`) yöntemi de sıklıkla kullanılır.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[S2I automates image creation via: 1) `BuildConfig` (defines Git source, webhooks, and builder images), 2) `ImageStream` (tracks container image metadata and triggers automated rollout upon updates), 3) Curated Red Hat OpenJDK builder images. Alternatively, teams use Binary Builds to push locally compiled JAR binaries directly into OpenShift build pods.]
    ]
  )
]

#spring_box[
```bash
# 1. Java Git Deposundan Doğrudan Uygulama Üret (S2I):
oc new-app registry.access.redhat.com/ubi8/openjdk-21~https://github.com/my-org/spring-boot-k8s-eli5.git \
  --name=coffee-s2i-app

# 2. Derleme Loglarını Canlı Takip Et:
oc logs -f bc/coffee-s2i-app

# 3. Servisi Dış Dünyaya Aç:
oc expose svc/coffee-s2i-app
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Büyük kurumsal projelerde S2I küme üzerindeki CPU ve bellek kaynaklarını yoğun tüketebilir. Çok büyük ekiplerde derleme işlemini GitHub Actions gibi harici bir CI aracında yapıp OpenShift'e sadece hazır imajı iletmek daha verimlidir.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Compiling multi-gigabyte Maven builds inside the cluster via S2I consumes cluster compute. For large teams, offloading compilation to GitHub Actions is best practice.]
    ]
  )
]

#takeaways_box((
    ("S2I geliştiricilerin Dockerfile yazma zorunluluğunu ortadan kaldırır.", "S2I abstracts container packaging away from application developers entirely."),
    ("ImageStreams yeni bir imaj etiketi geldiğinde otomatik dağıtımı tetikler.", "ImageStreams automatically trigger rolling deployments when new tags appear."),
    ("Kurumsal Red Hat UBI (Universal Base Image) güvenli temel sağlar.", "Red Hat Universal Base Images (UBI) deliver enterprise-grade, certified runtimes."),
))
