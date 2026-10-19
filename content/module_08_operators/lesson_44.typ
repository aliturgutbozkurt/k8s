#import "/template.typ": *

#show: doc => setup_book(title: "Ders 44: CRD (Custom Resource Definition) ve Reconciliation Döngüsü", doc)

#lesson_header(
  44,
  "CRD (Custom Resource Definition) ve Reconciliation Döngüsü",
  "CRDs and the Infinite Reconciliation Loop",
  "Kubernetes Operators — Kendi Akıllı Robotunu Kodla",
  "Kubernetes Operators — Build Your Own Robot SRE"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Kubernetes doğduğunda sadece 'Pod', 'Service' gibi birkaç kelime bilirdi. CRD (Custom Resource Definition), Kubernetes'e yepyeni kelimeler öğretmektir! 'Artık sen `SpringBootApp` veya `CoffeeMachine` kelimesini de bileceksin' deriz. Reconciliation (Mutabakat) Döngüsü ise robotun 'İstenen kahve hazırlandı mı? Eksik var mı?' diye etrafı sonsuz bir merakla kontrol etmesidir.
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[When Kubernetes was born, it only understood basic words like 'Pod' and 'Service'. A CRD (Custom Resource Definition) teaches Kubernetes brand-new nouns! You say: 'From now on, you understand what a `SpringBootApp` is.' The Reconciliation Loop is the robot's infinite inner monologue: 'I see 1 desired `SpringBootApp`; do 3 matching pods exist? If not, make it so!']
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      1) CRD: K8s API Server'a OpenAPI v3 şemasıyla yeni bir REST uç noktası (`/apis/apps.eli5.io/v1alpha1/...`) ekler. 2) Custom Resource (CR): Bu şablon kullanılarak oluşturulan gerçek nesnedir. 3) Reconciliation Loop: Controller sürekli olarak K8s API'sindeki Watch kuyruğunu dinler. `Reconcile(Request)` fonksiyonu çağrıldığında: Mevcut kaynakları sorgular, aradaki farkı hesaplar ve K8s API çağrılarıyla sistemi olması gereken duruma eşitler.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[1) CRDs register custom REST endpoints into the API Server with OpenAPI v3 schema validation. 2) Custom Resources (CR) are instances conforming to that schema. 3) The Reconciliation Loop triggers on Watch event queues. The `Reconcile(Request)` method retrieves the observed state, calculates the delta against desired state, and issues idempotent API calls to eliminate drift.]
    ]
  )
]

#spring_box[
```yaml
# springbootapp-crd.yaml (Yeni Nesne Tanımı)
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: springbootapps.apps.eli5.io
spec:
  group: apps.eli5.io
  versions:
    - name: v1alpha1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                image: { type: string }
                replicas: { type: integer, minimum: 1, maximum: 10 }
                port: { type: integer, default: 8080 }
  scope: Namespaced
  names:
    plural: springbootapps
    singular: springbootapp
    kind: SpringBootApp
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Reconciliation döngüsündeki kodunuz MUTLAKA 'Idempotent' (Tekrarlanabilir) olmalıdır! Döngü 1 kez de çalışsa, peş peşe 100 kez de çalışsa aynı sonucu üretmeli, her seferinde sıfırdan yeni kaynak yaratmamalıdır.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Reconciliation logic MUST be strictly idempotent! Whether executed once or a thousand times, it must evaluate current state and produce the exact same outcome.]
    ]
  )
]

#takeaways_box((
    ("CRD'ler Kubernetes API'sini kendi alan adınıza özel nesnelerle genişletir.", "CRDs extend the core Kubernetes API with domain-tailored schema endpoints."),
    ("Reconciliation döngüsü 'İstenen Durum' ile 'Mevcut Durum'u daima eşitler.", "The reconciliation loop relentlessly drives actual state toward desired state."),
    ("OpenAPI v3 doğrulaması hatalı YAML girişlerini anında reddeder.", "Built-in OpenAPI v3 validation rejects malformed YAML payloads at the API door."),
))
