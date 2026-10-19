#import "/template.typ": *

#show: doc => setup_book(title: "Ders 23: Network Policies: K8s İçi Güvenlik Duvarı (Firewall)", doc)

#lesson_header(
  23,
  "Network Policies: K8s İçi Güvenlik Duvarı (Firewall)",
  "Network Policies: Kubernetes Internal Micro-Firewalls",
  "Ağ, Keşif & Dış Dünyaya Açılma",
  "Networking, Discovery & Ingress Routing"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Varsayılan olarak bir K8s kümesindeki her pod, diğer tüm pod'larla özgürce konuşabilir! Bu durum, oteldeki her müşterinin elini kolunu sallayarak mutfağa ve para kasasına girmesine benzer (Büyük tehlike!). NetworkPolicy, kapılara kilit takmaktır: 'Sadece beyaz şapkalı aşçılar (Backend) kasaya (Veritabanı) girebilir; müşteriler (Frontend) doğrudan giremez!'
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[By default, Kubernetes has a flat network: ANY pod can talk to ANY other pod! That's like letting hotel guests wander into the bank vault and restaurant freezer unhindered. A NetworkPolicy installs biometric security checkpoints: 'Only authenticated backend chefs can talk to the database; front-end visitors are completely blocked!']
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      NetworkPolicy, pod'ların ingress (gelen) ve egress (giden) ağ trafiğini etiketlere (labels), IP bloklarına (CIDR) veya namespace'lere göre filtreleyen kurallardır. DİKKAT: NetworkPolicy'nin çalışabilmesi için kümenizde Calico, Cilium veya WeaveNet gibi bir CNI (Container Network Interface) eklentisi kurulu olmalıdır. Varsayılan Flannel NetworkPolicy desteklemez. Kural yazıldığı anda hedef pod için 'varsayılan engelleme' (default-deny) aktif olur.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[NetworkPolicies enforce micro-segmentation at Layer 3/4 via Ingress/Egress packet filtering based on podSelector and namespaceSelector. CRITICAL: NetworkPolicies require an enforcing CNI plugin like Calico or Cilium. Without an enforcing CNI, policies are silently ignored! Declaring a policy toggles the selected pods into default-deny isolation.]
    ]
  )
]

#spring_box[
```yaml
# postgres-network-policy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-only-backend-to-db
  namespace: coffee-shop
spec:
  podSelector:
    matchLabels:
      app: postgres-db # Bu kural veritabanı pod'larını korur
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: coffee-app # SADECE coffee-app pod'ları gelebilir!
      ports:
        - protocol: TCP
          port: 5432
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Bir pod'a NetworkPolicy bağladığınız anda, açıkça izin vermediğiniz TÜM diğer gelen bağlantılar (diğer servisler, sağlık probları vb.) anında kesilir! Probeları veya DNS trafiğini (port 53) yanlışlıkla engellememeye dikkat edin.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Applying a NetworkPolicy immediately locks down all unmentioned traffic! Forgetting to allow DNS egress (port 53 UDP/TCP) will break all network lookups.]
    ]
  )
]

#takeaways_box((
    ("Zero-Trust güvenliği için pod'lar arası erişim kısıtlanmalıdır.", "Enforce Zero-Trust architecture by restricting lateral pod-to-pod movement."),
    ("Calico veya Cilium gibi destekleyen bir CNI eklentisi zorunludur.", "An enforcing CNI plugin (e.g. Calico, Cilium) is mandatory for enforcement."),
    ("Veritabanlarına sadece yetkili backend pod'larının erişmesi garanti edilir.", "Guarantees databases only accept connections from verified backend services."),
))
