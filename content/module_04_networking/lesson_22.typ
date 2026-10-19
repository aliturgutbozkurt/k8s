#import "/template.typ": *

#show: doc => setup_book(title: "Ders 22: Servisler Arası İletişim & CoreDNS (Spring Boot Entegrasyonu)", doc)

#lesson_header(
  22,
  "Servisler Arası İletişim & CoreDNS (Spring Boot Entegrasyonu)",
  "Inter-Service Communication & CoreDNS Resolution",
  "Ağ, Keşif & Dış Dünyaya Açılma",
  "Networking, Discovery & Ingress Routing"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      K8s içindeki akıllı telefon rehberi: CoreDNS! Bir Spring Boot mikroservisi diğerine istek atarken IP adresini bilmek zorunda değildir. Rehbere 'Bana sipariş servisini bağla!' (`order-service`) der, CoreDNS anında doğru numarayı bağlar. Hatta başka bir departmandaysa tam adını söyler: `coffee-service.coffee-shop.svc.cluster.local`!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[The internal yellow pages: CoreDNS! When your Spring Boot frontend calls your backend, it doesn't need to track IP addresses. It simply calls `http://coffee-service`! CoreDNS intercepts the DNS request and resolves the cluster IP instantly. Across namespaces, it uses the Fully Qualified Domain Name (FQDN): `service.namespace.svc.cluster.local`!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      K8s kümesindeki her Pod'un `/etc/resolv.conf` dosyasına CoreDNS servisinin IP'si otomatik yazılır. Bir pod `http://coffee-service` çağırdığında: 1) Yerel libc, search domain listesini (`coffee-shop.svc.cluster.local`, `svc.cluster.local`, `cluster.local`) sırayla dener. 2) CoreDNS eşleşen Servis VIP'sini döner. 3) Kube-proxy paketi hedef pod'a iletir. Spring Boot'ta `RestTemplate` veya `WebClient` ile doğrudan servis adı çağrılır.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Every Pod automatically inherits `/etc/resolv.conf` pointed at the cluster's CoreDNS service IP. Calling `http://coffee-service` triggers iterative DNS search domain appending (`<ns>.svc.cluster.local`). CoreDNS returns the Service VIP, and kube-proxy handles Layer 4 routing. In Spring Boot, configure your `WebClient` base URL directly with the service DNS name.]
    ]
  )
]

#spring_box[
```java
// Spring Boot Java Servis Çağrısı Örneği:
@Service
public class OrderService {
    private final RestClient restClient;

    public OrderService(RestClient.Builder builder) {
        // CoreDNS adı doğrudan URL olarak kullanılır!
        this.restClient = builder
            .baseUrl("http://coffee-service.coffee-shop.svc.cluster.local")
            .build();
    }

    public CoffeeResponse fetchCoffee() {
        return restClient.get()
            .uri("/api/coffee")
            .retrieve()
            .body(CoffeeResponse.class);
    }
}
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Aynı namespace içindeki servisleri sadece adıyla (`http://coffee-service`) çağırabilirsiniz. Ama FARKLI bir namespace'teki servisi çağırmak için mutlaka namespace adını da eklemelisiniz (`http://coffee-service.diger-namespace`)!
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Calling a service in another namespace requires appending the namespace: `http://service-name.target-namespace`. Omitting it causes DNS 404 lookup failures.]
    ]
  )
]

#takeaways_box((
    ("CoreDNS tüm servisler için otomatik DNS A/SRV kayıtları oluşturur.", "CoreDNS auto-provisions and maintains internal DNS records for all services."),
    ("Tam alan adı: `<service-name>.<namespace>.svc.cluster.local` şeklindedir.", "The internal FQDN syntax is `<service>.<namespace>.svc.cluster.local`."),
    ("Spring Boot kodunda IP adresi yazmak KESİNLİKLE yasaktır; DNS kullanılmalıdır.", "Never hardcode IP addresses in microservice configs; always utilize DNS names."),
))
