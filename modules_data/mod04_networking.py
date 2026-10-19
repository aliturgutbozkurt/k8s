# -*- coding: utf-8 -*-
"""
Module 4: Ağ, Keşif & Dış Dünyaya Açılma (Lessons 19-24)
"""

MODULE = {
    "id": 4,
    "dir": "module_04_networking",
    "title_tr": "Ağ, Keşif & Dış Dünyaya Açılma",
    "title_en": "Networking, Discovery & Ingress Routing",
    "desc_tr": "Pod'lar arası dinamik IP kaosuna son: ClusterIP servisleri, NodePort, LoadBalancer, Ingress kontrolcüleri, CoreDNS ve ConfigMap/Secret yönetimi.",
    "desc_en": "Taming ephemeral IP chaos: ClusterIP services, NodePort, LoadBalancers, Ingress traffic cops, CoreDNS resolution, and externalizing configs via ConfigMaps & Secrets.",
    "lessons": [
        {
            "num": 19,
            "title_tr": "Uçucu IP Çilesine Son: Service (ClusterIP) ve Pod Keşfi",
            "title_en": "Solving Ephemeral IPs: Services (ClusterIP) & Internal Discovery",
            "eli5_tr": "Pod'lar kelebekler gibidir; ömürleri kısadır, sürekli ölür ve her yeniden doğduklarında farklı bir telefon numarası (IP adresi) alırlar. Müşterilerinize sürekli değişen cep numaraları veremezsiniz! 'Service' (ClusterIP), şirketin asla değişmeyen sabit santral numarasıdır (Örn: 444 0 444). Müşteri santrali arar, santral arkada o an hangi garson müsaitse telefonu ona aktarır!",
            "eli5_en": "Pods are butterflies: ephemeral and fragile. Every time a pod dies and resurrects, it receives a completely new IP address. You can't distribute changing phone numbers to customers! A Service (ClusterIP) is your company's immutable 1-800 hotline. Callers dial the single hotline number, and the switchboard automatically forwards calls to whoever is on duty!",
            "deep_tr": "ClusterIP, sadece küme içinden erişilebilen sanal bir IP (VIP) ve DNS adıdır. Fiziksel bir ağ arayüzü yoktur! Arka planda `kube-proxy`, Linux çekirdeğindeki iptables veya IPVS kurallarını güncelleyerek ClusterIP'ye gelen paketleri hedef pod'ların IP'lerine rastgele (Round-Robin) yönlendirir. Servis, pod'ları `selector.matchLabels` ile bulur ve bu pod'ların canlı IP'lerini 'EndpointSlice' nesnelerinde güncel tutar.",
            "deep_en": "A ClusterIP is a virtual IP (VIP) resolvable strictly within the cluster. It has no physical network card! Instead, `kube-proxy` configures iptables or IPVS packet filter rules in the Linux kernel to rewrite destination IPs to matching pod IPs via round-robin. The Service maintains an active inventory of backing Pod IPs through `EndpointSlice` controller watchers.",
            "spring_code": """# coffee-service.yaml
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
      targetPort: 8080 # Spring Boot konteynerinin portu""",
            "warning_tr": "ClusterIP servisine küme dışından (laptopunuzun tarayıcısından) doğrudan erişemezsiniz! Sadece küme içindeki diğer pod'lar veya `kubectl port-forward` ile erişilebilir.",
            "warning_en": "ClusterIP addresses are strictly internal! You cannot curl or open them in your desktop browser without port-forwarding or external ingress.",
            "takeaways": [
                ("Service, dinamik pod IP'lerinin önüne sabit bir sanal IP ve DNS koyar.", "Services establish an immutable virtual IP and DNS fronting dynamic pods."),
                ("Trafik arka planda sağlıklı pod'lar arasında otomatik dengelenir.", "Traffic load balances evenly across healthy pods matching label selectors."),
                ("EndpointSlice nesneleri hazır olan pod'ların IP listesini anlık tutar.", "EndpointSlices continuously track ready and healthy pod endpoints.")
            ]
        },
        {
            "num": 20,
            "title_tr": "Dış Dünyaya İlk Kapı: NodePort ve LoadBalancer",
            "title_en": "Exposing Apps Outside: NodePort and Cloud LoadBalancers",
            "eli5_tr": "ClusterIP ile evin içindesiniz. Peki sokaktaki müşteri içeri nasıl girecek? 1) NodePort: Binanın dış duvarına rastgele yüksek bir delik açıp kablo sarkıtmaktır (Port 30000-32767). 2) LoadBalancer: Binanın önüne profesyonel bir vale ve döner kapı koymaktır (AWS, Google Cloud veya Azure'dan gerçek bir genel IP kiralar)!",
            "eli5_en": "ClusterIP keeps you locked indoors. How does a customer on the street enter? 1) NodePort: Drilling a hole in the outside wall with a designated high-numbered port (30000-32767). 2) LoadBalancer: Hiring an elite cloud-native valet company to manage your driveway with a shiny public static IP (AWS NLB, GCP Load Balancer)!",
            "deep_tr": "1) `NodePort`: Kümedeki TÜM işçi düğümlerin belirtilen portunu (örn: 31234) dinlemeye alır. `http://<HERHANGİ_BİR_DÜĞÜM_IP>:31234` adresine gelen istek servise aktarılır. 2) `LoadBalancer`: NodePort'un bir üst katmanıdır. K8s bulut sağlayıcısının (AWS/GCP/Azure) API'sini çağırarak otomatik bir bulut yük dengeleyici tahsis eder ve trafiği küme düğümlerine dağıtır. Yerel ortamlarda (Minikube/Kind) MetalLB kullanılabilir.",
            "deep_en": "1) `NodePort` opens a dedicated static port (30000-32767) on EVERY worker node. Packets hitting `<NodeIP>:<NodePort>` route into the service. 2) `LoadBalancer` extends NodePort by dispatching cloud provider API drivers (AWS ELB, GCP CLB) to provision a public IP routing external Internet traffic into the node ports.",
            "spring_code": """# coffee-loadbalancer.yaml
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
# minikube tunnel""",
            "warning_tr": "Her mikroservis için ayrı bir `LoadBalancer` servisi açarsanız, bulut sağlayıcınız her biri için ayda onlarca dolar fatura keser! 20 mikroservis için 20 ayrı IP almak yerine tek bir `Ingress` kullanılmalıdır.",
            "warning_en": "Provisioning a cloud LoadBalancer for every single microservice explodes cloud bills! Use a single Ingress Controller to route 50 services through 1 public IP.",
            "takeaways": [
                ("NodePort geliştirme ve test ortamlarında hızlı dış erişim sağlar.", "NodePort is useful for quick debugging without cloud provider dependencies."),
                ("LoadBalancer gerçek dünya üretim ortamlarında genel IP sağlar.", "LoadBalancers automate cloud-native public IP allocation and routing."),
                ("Trafik önce LoadBalancer'a, oradan NodePort'a, oradan ClusterIP'ye akar.", "Traffic hierarchically flows: LoadBalancer -> NodePort -> ClusterIP -> Pod.")
            ]
        },
        {
            "num": 21,
            "title_tr": "Ingress & Ingress Controller: Akıllı Trafik Polisi",
            "title_en": "Ingress & Ingress Controllers: The Smart Traffic Cop",
            "eli5_tr": "50 katlı bir holding binasında her ofis için ayrı sokak kapısı yapamazsınız! Binanın tek bir ana döner kapısı ve lobisinde akıllı bir danışma görevlisi (Ingress Controller) olur. Gelen kişiye sorar: 'Kime geldiniz?' Kişi 'Kafeye (`/coffee`)' derse kafeye, 'Muhasebeye (`/billing`)' derse 5. kata yönlendirir. Üstelik kapıda kimlik kontrolü (SSL/TLS şifreleme) yapar!",
            "eli5_en": "You don't build 50 separate front doors for a 50-story skyscraper! You have 1 grand lobby entrance with a sharp receptionist (Ingress Controller). Guests state their destination: 'Going to the coffee shop (`/coffee`)?' Turn left. 'Accounting (`/billing`)?' Elevator 4. Plus, the receptionist checks IDs and encrypts passes (HTTPS / SSL termination)!",
            "deep_tr": "Ingress iki bileşenden oluşur: 1) Ingress Kaynağı (Kuralları belirten YAML dosyası), 2) Ingress Controller (Bu kuralları dinleyip uygulayan NGINX, Traefik, Envoy veya HAProxy pod'u). Ingress Controller, 7. katman (HTTP/HTTPS) yönlendirmesi yapar: Domain adına göre (`api.sirket.com` vs `web.sirket.com`) veya URL yoluna göre (`/api` vs `/auth`) trafiği ilgili ClusterIP servisine aktarır. SSL sertifikası tek merkezde sonlandırılır.",
            "deep_en": "Ingress splits into: 1) Ingress Resource (declarative routing rules in YAML), 2) Ingress Controller (reverse proxy daemon like Ingress-NGINX or Traefik reconciling those rules). Operating at Layer 7 (HTTP/HTTPS), it terminates TLS, rewrites paths, and directs traffic based on SNI hostnames and URL path prefixes to backend ClusterIPs.",
            "spring_code": """# coffee-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: coffee-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
    - host: coffee.local
      http:
        paths:
          - path: /api
            pathType: Prefix
            backend:
              service:
                name: coffee-service
                port:
                  number: 80""",
            "warning_tr": "Ingress YAML'ı yazmak tek başına HİÇBİR İŞE YARAMAZ! Kümenizde çalışan aktif bir Ingress Controller (örn: ingress-nginx) yoksa, yazdığınız Ingress kuralları sessizce havada asılı kalır.",
            "warning_en": "Applying an Ingress manifest without an active Ingress Controller running in your cluster does absolutely nothing; the resource remains dormant.",
            "takeaways": [
                ("Ingress tek bir genel IP arkasında yüzlerce servisi akıllıca paylaştırır.", "A single Ingress exposes hundreds of microservices behind 1 public IP."),
                ("Host-tabanlı ve Path-tabanlı 7. katman yönlendirmelerini destekler.", "Supports host-based (virtual hosting) and path-based Layer 7 routing."),
                ("SSL/TLS sertifikalarını tek merkezde yönetip güvenliği artırır.", "Centralizes TLS termination and SSL certificate lifecycle management.")
            ]
        },
        {
            "num": 22,
            "title_tr": "Servisler Arası İletişim & CoreDNS (Spring Boot Entegrasyonu)",
            "title_en": "Inter-Service Communication & CoreDNS Resolution",
            "eli5_tr": "K8s içindeki akıllı telefon rehberi: CoreDNS! Bir Spring Boot mikroservisi diğerine istek atarken IP adresini bilmek zorunda değildir. Rehbere 'Bana sipariş servisini bağla!' (`order-service`) der, CoreDNS anında doğru numarayı bağlar. Hatta başka bir departmandaysa tam adını söyler: `coffee-service.coffee-shop.svc.cluster.local`!",
            "eli5_en": "The internal yellow pages: CoreDNS! When your Spring Boot frontend calls your backend, it doesn't need to track IP addresses. It simply calls `http://coffee-service`! CoreDNS intercepts the DNS request and resolves the cluster IP instantly. Across namespaces, it uses the Fully Qualified Domain Name (FQDN): `service.namespace.svc.cluster.local`!",
            "deep_tr": "K8s kümesindeki her Pod'un `/etc/resolv.conf` dosyasına CoreDNS servisinin IP'si otomatik yazılır. Bir pod `http://coffee-service` çağırdığında: 1) Yerel libc, search domain listesini (`coffee-shop.svc.cluster.local`, `svc.cluster.local`, `cluster.local`) sırayla dener. 2) CoreDNS eşleşen Servis VIP'sini döner. 3) Kube-proxy paketi hedef pod'a iletir. Spring Boot'ta `RestTemplate` veya `WebClient` ile doğrudan servis adı çağrılır.",
            "deep_en": "Every Pod automatically inherits `/etc/resolv.conf` pointed at the cluster's CoreDNS service IP. Calling `http://coffee-service` triggers iterative DNS search domain appending (`<ns>.svc.cluster.local`). CoreDNS returns the Service VIP, and kube-proxy handles Layer 4 routing. In Spring Boot, configure your `WebClient` base URL directly with the service DNS name.",
            "spring_code": """// Spring Boot Java Servis Çağrısı Örneği:
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
}""",
            "warning_tr": "Aynı namespace içindeki servisleri sadece adıyla (`http://coffee-service`) çağırabilirsiniz. Ama FARKLI bir namespace'teki servisi çağırmak için mutlaka namespace adını da eklemelisiniz (`http://coffee-service.diger-namespace`)!",
            "warning_en": "Calling a service in another namespace requires appending the namespace: `http://service-name.target-namespace`. Omitting it causes DNS 404 lookup failures.",
            "takeaways": [
                ("CoreDNS tüm servisler için otomatik DNS A/SRV kayıtları oluşturur.", "CoreDNS auto-provisions and maintains internal DNS records for all services."),
                ("Tam alan adı: `<service-name>.<namespace>.svc.cluster.local` şeklindedir.", "The internal FQDN syntax is `<service>.<namespace>.svc.cluster.local`."),
                ("Spring Boot kodunda IP adresi yazmak KESİNLİKLE yasaktır; DNS kullanılmalıdır.", "Never hardcode IP addresses in microservice configs; always utilize DNS names.")
            ]
        },
        {
            "num": 23,
            "title_tr": "Network Policies: K8s İçi Güvenlik Duvarı (Firewall)",
            "title_en": "Network Policies: Kubernetes Internal Micro-Firewalls",
            "eli5_tr": "Varsayılan olarak bir K8s kümesindeki her pod, diğer tüm pod'larla özgürce konuşabilir! Bu durum, oteldeki her müşterinin elini kolunu sallayarak mutfağa ve para kasasına girmesine benzer (Büyük tehlike!). NetworkPolicy, kapılara kilit takmaktır: 'Sadece beyaz şapkalı aşçılar (Backend) kasaya (Veritabanı) girebilir; müşteriler (Frontend) doğrudan giremez!'",
            "eli5_en": "By default, Kubernetes has a flat network: ANY pod can talk to ANY other pod! That's like letting hotel guests wander into the bank vault and restaurant freezer unhindered. A NetworkPolicy installs biometric security checkpoints: 'Only authenticated backend chefs can talk to the database; front-end visitors are completely blocked!'",
            "deep_tr": "NetworkPolicy, pod'ların ingress (gelen) ve egress (giden) ağ trafiğini etiketlere (labels), IP bloklarına (CIDR) veya namespace'lere göre filtreleyen kurallardır. DİKKAT: NetworkPolicy'nin çalışabilmesi için kümenizde Calico, Cilium veya WeaveNet gibi bir CNI (Container Network Interface) eklentisi kurulu olmalıdır. Varsayılan Flannel NetworkPolicy desteklemez. Kural yazıldığı anda hedef pod için 'varsayılan engelleme' (default-deny) aktif olur.",
            "deep_en": "NetworkPolicies enforce micro-segmentation at Layer 3/4 via Ingress/Egress packet filtering based on podSelector and namespaceSelector. CRITICAL: NetworkPolicies require an enforcing CNI plugin like Calico or Cilium. Without an enforcing CNI, policies are silently ignored! Declaring a policy toggles the selected pods into default-deny isolation.",
            "spring_code": """# postgres-network-policy.yaml
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
          port: 5432""",
            "warning_tr": "Bir pod'a NetworkPolicy bağladığınız anda, açıkça izin vermediğiniz TÜM diğer gelen bağlantılar (diğer servisler, sağlık probları vb.) anında kesilir! Probeları veya DNS trafiğini (port 53) yanlışlıkla engellememeye dikkat edin.",
            "warning_en": "Applying a NetworkPolicy immediately locks down all unmentioned traffic! Forgetting to allow DNS egress (port 53 UDP/TCP) will break all network lookups.",
            "takeaways": [
                ("Zero-Trust güvenliği için pod'lar arası erişim kısıtlanmalıdır.", "Enforce Zero-Trust architecture by restricting lateral pod-to-pod movement."),
                ("Calico veya Cilium gibi destekleyen bir CNI eklentisi zorunludur.", "An enforcing CNI plugin (e.g. Calico, Cilium) is mandatory for enforcement."),
                ("Veritabanlarına sadece yetkili backend pod'larının erişmesi garanti edilir.", "Guarantees databases only accept connections from verified backend services.")
            ]
        },
        {
            "num": 24,
            "title_tr": "ConfigMap ve Secret: Konfigürasyonu Koddan Ayırma",
            "title_en": "Externalizing Config: ConfigMaps and Secrets with Spring Boot",
            "eli5_tr": "Telefon numaranız veya şifreniz değiştiğinde yeni bir telefon satın almazsınız! Aynı şekilde veritabanı şifresi değiştiğinde Spring Boot kodunu yeniden derleyip Docker imajı almamalısınız. ConfigMap: Herkesin görebileceği açık duyuru panosudur (API URL'leri, tema rengi). Secret: Kilitli çelik kasadır (Şifreler, kredi kartı API anahtarları)!",
            "eli5_en": "When you change your Netflix password, you don't throw your TV in the trash and buy a new one! Similarly, when a DB password rotates, you don't recompile your Java code into a new Docker image. ConfigMaps are public bulletin boards (log levels, URLs). Secrets are locked steel safes (passwords, JWT signing keys)!",
            "deep_tr": "Twelve-Factor App metodolojisinin 3. kuralı: 'Konfigürasyonu koddan ayır!' K8s iki nesne sunar: 1) ConfigMap: Düz metin anahtar-değer çiftleri, 2) Secret: Base64 kodlanmış hassas veriler. Bu veriler pod'a iki şekilde aktarılır: Ortam değişkeni (Environment Variable) olarak veya dosya olarak (Volume Mount). Spring Boot, `application.yml` içindeki `${DB_PASSWORD}` değişkenlerini bu sayede sıfır kod değişikliğiyle otomatik enjekte eder.",
            "deep_en": "Twelve-Factor App principle III: Strict separation of config from code. 1) ConfigMaps store non-confidential key-value pairs. 2) Secrets store sensitive credentials base64-encoded (or encrypted at rest via KMS). Injected into pods either as environment variables (`envFrom`) or mounted as files. Spring Boot seamlessly binds them into `@Value` and `@ConfigurationProperties`.",
            "spring_code": """# ConfigMap ve Secret'ı Pod'a Aktarma:
spec:
  containers:
    - name: coffee-app
      image: ghcr.io/eli5-k8s/spring-boot-k8s-eli5:1.0.0
      env:
        - name: APP_MESSAGE # ConfigMap'ten tek değişken oku
          valueFrom:
            configMapKeyRef:
              name: spring-boot-config
              key: APP_MESSAGE
        - name: DB_PASSWORD # Secret'tan şifre oku
          valueFrom:
            secretKeyRef:
              name: spring-boot-secret
              key: DB_PASSWORD""",
            "warning_tr": "K8s Secret'ları varsayılan olarak şifrelenmiş (encrypted) DEĞİLDİR; sadece Base64 ile encode edilmiştir! Yani `echo 'c2VjcmV0' | base64 -d` yazan herkes şifreyi görebilir. Gerçek güvenlik için etcd 'Encryption at Rest' veya HashiCorp Vault / AWS Secrets Manager kullanılmalıdır.",
            "warning_en": "Kubernetes Secrets are NOT encrypted by default; they are merely Base64-encoded! Anyone with read access can decode them. Enable KMS encryption-at-rest in etcd.",
            "takeaways": [
                ("Aynı Docker imajı dev, test ve prod ortamlarında sıfır değişiklikle çalışır.", "The same immutable container image runs across dev, stage, and prod via config injection."),
                ("Ortam değişkenleri veya dosya bağlama (volume mount) ile pod'a aktarılır.", "Configs can be mounted dynamically as filesystem directories or environment vars."),
                ("Secret'lar hassas verileri Git reposuna koyma felaketini önler.", "Keeps passwords and private keys out of public Git version control repositories.")
            ]
        }
    ]
}
