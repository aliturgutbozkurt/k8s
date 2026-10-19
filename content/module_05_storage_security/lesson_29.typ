#import "/template.typ": *

#show: doc => setup_book(title: "Ders 29: Namespaces: Kümeyi Ortamlara Bölme (Dev, Staging, Prod)", doc)

#lesson_header(
  29,
  "Namespaces: Kümeyi Ortamlara Bölme (Dev, Staging, Prod)",
  "Namespaces: Multi-Tenancy & Environment Isolation",
  "Depolama, Güvenlik & Otomatik Ölçekleme",
  "Storage, Security & Horizontal Autoscaling"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Dev bir alışveriş merkezini farklı mağazalara bölmek! Her mağaza (Namespace) kendi vitrinini düzenler. Bir stajyer 'Geliştirme' (Dev) mağazasındaki bir mankeni yanlışlıkla kırarsa, yan dükkandaki 'Üretim' (Production) kasasındaki paralar veya müşteriler bundan zerre kadar etkilenmez!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Partitioning a mega shopping mall into individual storefronts! Each store (Namespace) operates independently. If an intern accidentally knocks over a rack in the 'Dev' clothing shop, the real high-paying customers in the 'Production' jewelry store next door remain completely untouched and oblivious!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Namespace, fiziksel bir K8s kümesini mantıksal sanal kümelere böler. İsim çakışmalarını önler (farklı namespace'lerde aynı isimde `coffee-service` olabilir). İki kritik araçla desteklenir: 1) `ResourceQuota` (Namespace'in toplam CPU, RAM veya Pod sayısını sınırlar; örn: Dev namespace'i toplam en fazla 10 çekirdek CPU tüketebilir), 2) `LimitRange` (Pod başına varsayılan min/max kaynak sınırlarını zorunlu kılar).
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Namespaces provide logical virtual partitioning within a single cluster. They prevent naming collisions and enforce governance via: 1) `ResourceQuota` (capping aggregate CPU, RAM, and object counts across the namespace), 2) `LimitRange` (enforcing default and min/max boundaries per container). Cluster-level resources (Nodes, StorageClasses, PVs) remain unnamespaced.]
    ]
  )
]

#spring_box[
```yaml
# dev-quota.yaml (Geliştirme Ortamı Kaynak Kotası)
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-compute-quota
  namespace: coffee-dev
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
    pods: "10" # En fazla 10 pod açabilirler!

# Namespace oluştur ve aktif bağlamı değiştir:
# kubectl create namespace coffee-dev
# kubectl config set-context --current --namespace=coffee-dev
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Namespace'ler varsayılan olarak ağ düzeyinde yalıtım SAĞLAMAZ! Yani `coffee-dev` içindeki bir pod varsayılan ayarlarla `coffee-prod` içindeki bir pod'a ping atabilir. Tam izolasyon için mutlaka 23. Dersteki 'NetworkPolicy' kurallarını eklemelisiniz!
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Namespaces do NOT enforce network boundaries by default! Pods in `dev` can still ping pods in `prod` unless segmented with NetworkPolicies.]
    ]
  )
]

#takeaways_box((
    ("Namespaces çok kiracılı (multi-tenant) ortamlarda düzen ve mantıksal sınır sağlar.", "Namespaces enable multi-tenant governance, organization, and name scoping."),
    ("ResourceQuota ekiplerin kümedeki tüm kaynakları sömürmesini engeller.", "ResourceQuotas prevent rogue development teams from exhausting cluster capacity."),
    ("`kubectl config set-context --current --namespace=...` ile varsayılan alan seçilir.", "Switch active context namespaces to avoid repetitive `-n <namespace>` flags."),
))
