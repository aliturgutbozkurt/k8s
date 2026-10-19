#import "/template.typ": *

#show: doc => setup_book(title: "Ders 27: K8s Güvenliği & RBAC: ServiceAccount, Role ve RoleBinding", doc)

#lesson_header(
  27,
  "K8s Güvenliği & RBAC: ServiceAccount, Role ve RoleBinding",
  "Kubernetes Security: RBAC (Roles, Bindings & ServiceAccounts)",
  "Depolama, Güvenlik & Otomatik Ölçekleme",
  "Storage, Security & Horizontal Autoscaling"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Holding binası güvenlik protokolü: 1) Personel Kimlik Kartı (ServiceAccount): Uygulamanızın yakasına taktığı kimlik kartıdır. 2) Yetki Kılavuzu (Role): 'Sadece 2. kattaki çay ocağına girebilir, kasaya dokunamaz' kuralları. 3) Yetki Ataması (RoleBinding): O kimlik kartını o kurallara zimmetleyen resmi tutanaktır. Bu üçlü olmadan hiç kimse API Server'a adım atamaz!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Skyscraper Security Protocol: 1) Badge (ServiceAccount): The digital ID card worn by your Spring Boot application. 2) Rulebook (Role): 'Allowed to visit the cafeteria on Floor 2, strictly prohibited from opening the executive vault'. 3) Assignment (RoleBinding): The signed HR form linking the Badge to the Rulebook. Without RBAC, nobody touches the API Server!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Kubernetes RBAC (Role-Based Access Control) API Server'a gelen istekleri denetler. Bileşenler: 1) `Subject` (Kullanıcı veya ServiceAccount), 2) `API Groups` (``, `apps`, `batch`), 3) `Resources` (`pods`, `services`, `configmaps`), 4) `Verbs` (`get`, `list`, `watch`, `create`, `delete`). `Role` sadece belirli bir namespace içinde geçerlidir; `ClusterRole` ise küme genelinde (örn: Node'ları veya tüm namespace'leri okumak için) geçerlidir.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Kubernetes RBAC authenticates and authorizes API requests. Every rule consists of: API Groups, Resources, and HTTP-like Verbs (`get`, `list`, `watch`, `create`, `delete`). A `Role` binds permissions strictly inside a namespace; a `ClusterRole` spans the entire cluster (e.g. cluster-wide node monitoring). ServiceAccount tokens are mounted into pods at `/var/run/secrets/kubernetes.io/serviceaccount`.]
    ]
  )
]

#spring_box[
```yaml
# Spring Cloud Kubernetes için Salt-Okunur İzin:
apiVersion: v1
kind: ServiceAccount
metadata:
  name: spring-cloud-sa
  namespace: coffee-shop
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: configmap-reader
  namespace: coffee-shop
rules:
  - apiGroups: [""]
    resources: ["configmaps", "pods"]
    verbs: ["get", "list", "watch"] # Sadece okuma izni ver!
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: bind-spring-reader
  namespace: coffee-shop
subjects:
  - kind: ServiceAccount
    name: spring-cloud-sa
roleRef:
  kind: Role
  name: configmap-reader
  apiGroup: rbac.authorization.k8s.io
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Uygulama pod'larına ASLA gereksiz yere `cluster-admin` yetkisi vermeyin! Spring Boot uygulamanızda bir güvenlik açığı (örn: Log4Shell) oluşursa, saldırgan tüm Kubernetes kümenizi ele geçirir (Least Privilege kuralı).
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[NEVER grant `cluster-admin` to application pods! If an exploit strikes your Java code, the attacker inherits full administrative root over the entire cluster.]
    ]
  )
]

#takeaways_box((
    ("En Az Ayrıcalık (Least Privilege) prensibiyle sadece gereken izinler verilmelidir.", "Always follow the Principle of Least Privilege: grant only essential verbs."),
    ("ServiceAccount uygulamaların K8s API'si ile güvenli konuşmasını sağlar.", "ServiceAccounts provide secure identities for in-cluster API communication."),
    ("ClusterRole küme çapında, Role ise sadece tek bir namespace içinde geçerlidir.", "ClusterRoles grant cluster-wide authority; Roles enforce namespace isolation."),
))
