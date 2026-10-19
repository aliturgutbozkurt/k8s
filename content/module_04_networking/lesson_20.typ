#import "/template.typ": *

#show: doc => setup_book(title: "Ders 20: Dış Dünyaya İlk Kapı: NodePort ve LoadBalancer", doc)

#lesson_header(
  20,
  "Dış Dünyaya İlk Kapı: NodePort ve LoadBalancer",
  "Exposing Apps Outside: NodePort and Cloud LoadBalancers",
  "Ağ, Keşif & Dış Dünyaya Açılma",
  "Networking, Discovery & Ingress Routing"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      ClusterIP ile evin içindesiniz. Peki sokaktaki müşteri içeri nasıl girecek? 1) NodePort: Binanın dış duvarına rastgele yüksek bir delik açıp kablo sarkıtmaktır (Port 30000-32767). 2) LoadBalancer: Binanın önüne profesyonel bir vale ve döner kapı koymaktır (AWS, Google Cloud veya Azure'dan gerçek bir genel IP kiralar)!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[ClusterIP keeps you locked indoors. How does a customer on the street enter? 1) NodePort: Drilling a hole in the outside wall with a designated high-numbered port (30000-32767). 2) LoadBalancer: Hiring an elite cloud-native valet company to manage your driveway with a shiny public static IP (AWS NLB, GCP Load Balancer)!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      1) `NodePort`: Kümedeki TÜM işçi düğümlerin belirtilen portunu (örn: 31234) dinlemeye alır. `http://<HERHANGİ_BİR_DÜĞÜM_IP>:31234` adresine gelen istek servise aktarılır. 2) `LoadBalancer`: NodePort'un bir üst katmanıdır. K8s bulut sağlayıcısının (AWS/GCP/Azure) API'sini çağırarak otomatik bir bulut yük dengeleyici tahsis eder ve trafiği küme düğümlerine dağıtır. Yerel ortamlarda (Minikube/Kind) MetalLB kullanılabilir.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[1) `NodePort` opens a dedicated static port (30000-32767) on EVERY worker node. Packets hitting `<NodeIP>:<NodePort>` route into the service. 2) `LoadBalancer` extends NodePort by dispatching cloud provider API drivers (AWS ELB, GCP CLB) to provision a public IP routing external Internet traffic into the node ports.]
    ]
  )
]

#spring_box[
```yaml
# coffee-loadbalancer.yaml
apiVersion: v1
kind: Service
metadata:
  name: coffee-public-service
spec:
  type: LoadBalancer # Buluttan genel IP talep et!
  selector:
    app: coffee-app
  ports:
    - port: 80
      targetPort: 8080

# Minikube'da test etmek için tünel açma:
# minikube tunnel
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Her mikroservis için ayrı bir `LoadBalancer` servisi açarsanız, bulut sağlayıcınız her biri için ayda onlarca dolar fatura keser! 20 mikroservis için 20 ayrı IP almak yerine tek bir `Ingress` kullanılmalıdır.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Provisioning a cloud LoadBalancer for every single microservice explodes cloud bills! Use a single Ingress Controller to route 50 services through 1 public IP.]
    ]
  )
]

#takeaways_box((
    ("NodePort geliştirme ve test ortamlarında hızlı dış erişim sağlar.", "NodePort is useful for quick debugging without cloud provider dependencies."),
    ("LoadBalancer gerçek dünya üretim ortamlarında genel IP sağlar.", "LoadBalancers automate cloud-native public IP allocation and routing."),
    ("Trafik önce LoadBalancer'a, oradan NodePort'a, oradan ClusterIP'ye akar.", "Traffic hierarchically flows: LoadBalancer -> NodePort -> ClusterIP -> Pod."),
))
