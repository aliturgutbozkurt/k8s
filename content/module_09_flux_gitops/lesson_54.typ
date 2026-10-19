#import "/template.typ": *

#show: doc => setup_book(title: "Ders 54: Helm Controller: Helm Paketlerini GitOps ile Yönetme", doc)

#lesson_header(
  54,
  "Helm Controller: Helm Paketlerini GitOps ile Yönetme",
  "Declarative Helm Management with Flux HelmReleases",
  "FluxCD ile Modern GitOps — Tek Gerçek Kaynak Git!",
  "Modern GitOps with FluxCD — Git as the Single Source of Truth"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Helm, Kubernetes dünyasının App Store paket yöneticisidir (npm veya pip gibi). Normalde terminalden `helm install postgresql ...` yazarsınız ama bu GitOps kuralını bozar! Flux'ın `HelmRelease` nesnesiyle deriz ki: 'Bitnami PostgreSQL paketini al, şu şifreleri ver, kur ve güncel tut!' Böylece devasa hazır yazılımları tek bir temiz YAML ile GitOps'a dahil ederiz!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Helm is the package manager for Kubernetes (like npm or pip). Normally developers run imperative `helm install postgresql ...` commands, violating GitOps! With Flux's `HelmRelease` resource, we declare: 'Fetch the Bitnami PostgreSQL chart, inject these custom passwords, and keep it healthy!' Sprawling third-party software stacks are tamed cleanly via GitOps!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Helm Controller iki kaynakla yönetilir: 1) `HelmRepository`: Helm chart'larının barındırıldığı depoyu (örn: `https://charts.bitnami.com/bitnami`) tanımlar. 2) `HelmRelease`: Belirli bir chart sürümünü (`version: '15.x'`), değerlerini (`values`) ve yükseltme stratejilerini tanımlar. Flux Helm Controller, chart'ın yükseltmesi başarısız olduğunda otomatik geri alma (`rollback`) yeteneğine sahiptir.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Flux manages Helm declaratively via: 1) `HelmRepository` points to Helm chart repositories or OCI registries. 2) `HelmRelease` declares chart versions, target namespaces, and customizable `values` overrides. The Helm Controller triggers native Helm library actions in-cluster, supporting automated rollbacks upon install/upgrade healthcheck failures.]
    ]
  )
]

#spring_box[
```yaml
# postgres-helm-release.yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmRepository
metadata:
  name: bitnami
  namespace: flux-system
spec:
  interval: 1h
  url: https://charts.bitnami.com/bitnami
---
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: coffee-postgres
  namespace: coffee-shop
spec:
  interval: 15m
  chart:
    spec:
      chart: postgresql
      version: "15.5.x"
      sourceRef:
        kind: HelmRepository
        name: bitnami
        namespace: flux-system
  values:
    auth:
      database: coffeedb
      username: coffeeuser
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Helm paketlerinin `values` kısmında hassas veritabanı şifrelerini açık metin olarak yazmayın! Şifreler için `valuesFrom` ile bir Secret veya Mozilla SOPS ile şifrelenmiş değerler referans verilmelidir.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Never hardcode cleartext passwords inside `HelmRelease.spec.values`! Reference external Kubernetes secrets using `valuesFrom` or Mozilla SOPS.]
    ]
  )
]

#takeaways_box((
    ("HelmRelease Helm paketlerini tamamen bildirici ve GitOps uyumlu hale getirir.", "HelmRelease makes Helm chart lifecycles 100% declarative and GitOps-native."),
    ("Yükseltme hatalarında otomatik rollback yaparak kesintiyi engeller.", "Automated rollbacks recover from failed chart upgrades safely."),
    ("Tüm dış bağımlılıklar (Redis, Kafka, PostgreSQL) Git üzerinden versiyonlanır.", "Third-party dependencies are cleanly audited and versioned inside your fleet repo."),
))
