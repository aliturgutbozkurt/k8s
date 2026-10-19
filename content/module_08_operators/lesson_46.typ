#import "/template.typ": *

#show: doc => setup_book(title: "Ders 46: OperatorHub ve Operator Lifecycle Manager (OLM)", doc)

#lesson_header(
  46,
  "OperatorHub ve Operator Lifecycle Manager (OLM)",
  "OperatorHub & Operator Lifecycle Manager (OLM): The K8s App Store",
  "Kubernetes Operators — Kendi Akıllı Robotunu Kodla",
  "Kubernetes Operators — Build Your Own Robot SRE"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Akıllı telefonunuza nasıl App Store veya Google Play'den tek tıkla uygulama indiriyorsanız, Kubernetes kümenize de 'OperatorHub' üzerinden tek tıkla kurumsal operatörler yüklersiniz! OLM (Operator Lifecycle Manager) ise telefonunuzun arka plandaki otomatik güncelleme yöneticisidir: Operatörlerin yeni sürümleri çıktığında onları kesintisiz günceller!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Just like browsing the App Store or Google Play to install apps with a single tap, 'OperatorHub' is the official enterprise app marketplace for Kubernetes! OLM (Operator Lifecycle Manager) is the automated app manager running under the hood: when a database operator releases a security patch, OLM upgrades it smoothly without breaking a sweat!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      OLM mimarisi 4 temel kaynaktan oluşur: 1) `CatalogSource` (Mevcut operatörlerin ve sürümlerin listelendiği depo), 2) `Subscription` (Hangi operatöre abone olunduğunu ve güncelleme kanalını - channel: stable/fast - belirtir), 3) `InstallPlan` (Gerekli CRD'leri ve RBAC izinlerini hesaplayan yürütme planı), 4) `ClusterServiceVersion` (CSV: Operatörün tüm manifestolarını, konteyner imajlarını ve metaverilerini paketleyen ana nesne). OpenShift'te yerleşik gelir.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[OLM manages operator lifecycles via: 1) `CatalogSource` (registry of operators and metadata), 2) `Subscription` (tracks an operator release channel like `stable-v1`), 3) `InstallPlan` (dependency resolution engine generating RBAC and CRD installation steps), 4) `ClusterServiceVersion` (CSV, encapsulated metadata detailing container images and CRDs). OLM is natively built into OpenShift.]
    ]
  )
]

#spring_box[
```yaml
# subscription-cloudnative-pg.yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: cloudnative-pg-subscription
  namespace: operators
spec:
  channel: stable
  name: cloudnative-pg
  source: operatorhubio-catalog
  sourceNamespace: olm
  installPlanApproval: Automatic # Güvenlik yamalarını otomatik uygula!
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Eğer `installPlanApproval: Automatic` seçerseniz, operatör yeni bir ana sürüme (major version) geçtiğinde otomatik güncellenebilir ve bu durum geriye dönük uyumsuzluk yaratabilir. Üretim ortamında `Manual` onay tavsiye edilir.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Setting `installPlanApproval: Automatic` in production can inadvertently trigger breaking major version upgrades. Choose `Manual` approval for enterprise clusters.]
    ]
  )
]

#takeaways_box((
    ("OperatorHub binlerce onaylı ve sertifikalı operatörü tek çatı altında sunar.", "OperatorHub curates thousands of verified, certified community and enterprise operators."),
    ("OLM bağımlılıkları çözer, yükseltmeleri yönetir ve operatör sağlığını izler.", "OLM automates complex operator installations, dependency resolution, and upgrades."),
    ("OpenShift Web Konsolunda görsel bir pazar yeri olarak doğrudan entegredir.", "Exposes a seamless visual marketplace directly inside the OpenShift Web Console."),
))
