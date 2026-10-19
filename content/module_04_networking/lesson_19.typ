#import "/template.typ": *

#show: doc => setup_book(title: "Ders 19: Uçucu IP Çilesine Son: Service (ClusterIP) ve Pod Keşfi", doc)

#lesson_header(
  19,
  "Uçucu IP Çilesine Son: Service (ClusterIP) ve Pod Keşfi",
  "Solving Ephemeral IPs: Services (ClusterIP) & Internal Discovery",
  "Ağ, Keşif & Dış Dünyaya Açılma",
  "Networking, Discovery & Ingress Routing"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Pod'lar kelebekler gibidir; ömürleri kısadır, sürekli ölür ve her yeniden doğduklarında farklı bir telefon numarası (IP adresi) alırlar. Müşterilerinize sürekli değişen cep numaraları veremezsiniz! 'Service' (ClusterIP), şirketin asla değişmeyen sabit santral numarasıdır (Örn: 444 0 444). Müşteri santrali arar, santral arkada o an hangi garson müsaitse telefonu ona aktarır!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Pods are butterflies: ephemeral and fragile. Every time a pod dies and resurrects, it receives a completely new IP address. You can't distribute changing phone numbers to customers! A Service (ClusterIP) is your company's immutable 1-800 hotline. Callers dial the single hotline number, and the switchboard automatically forwards calls to whoever is on duty!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      ClusterIP, sadece küme içinden erişilebilen sanal bir IP (VIP) ve DNS adıdır. Fiziksel bir ağ arayüzü yoktur! Arka planda `kube-proxy`, Linux çekirdeğindeki iptables veya IPVS kurallarını güncelleyerek ClusterIP'ye gelen paketleri hedef pod'ların IP'lerine rastgele (Round-Robin) yönlendirir. Servis, pod'ları `selector.matchLabels` ile bulur ve bu pod'ların canlı IP'lerini 'EndpointSlice' nesnelerinde güncel tutar.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[A ClusterIP is a virtual IP (VIP) resolvable strictly within the cluster. It has no physical network card! Instead, `kube-proxy` configures iptables or IPVS packet filter rules in the Linux kernel to rewrite destination IPs to matching pod IPs via round-robin. The Service maintains an active inventory of backing Pod IPs through `EndpointSlice` controller watchers.]
    ]
  )
]

#spring_box[
```yaml
# coffee-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: coffee-service # Küme içi DNS adı bu olur!
spec:
  type: ClusterIP
  selector:
    app: coffee-app # Bu etikete sahip pod'lara yönlendir
  ports:
    - name: http
      port: 80         # Servisin dinlediği dış kapı
      targetPort: 8080 # Spring Boot konteynerinin portu
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      ClusterIP servisine küme dışından (laptopunuzun tarayıcısından) doğrudan erişemezsiniz! Sadece küme içindeki diğer pod'lar veya `kubectl port-forward` ile erişilebilir.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[ClusterIP addresses are strictly internal! You cannot curl or open them in your desktop browser without port-forwarding or external ingress.]
    ]
  )
]

#takeaways_box((
    ("Service, dinamik pod IP'lerinin önüne sabit bir sanal IP ve DNS koyar.", "Services establish an immutable virtual IP and DNS fronting dynamic pods."),
    ("Trafik arka planda sağlıklı pod'lar arasında otomatik dengelenir.", "Traffic load balances evenly across healthy pods matching label selectors."),
    ("EndpointSlice nesneleri hazır olan pod'ların IP listesini anlık tutar.", "EndpointSlices continuously track ready and healthy pod endpoints."),
))
