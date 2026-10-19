#import "/template.typ": *

#show: doc => setup_book(title: "Ders 21: Ingress & Ingress Controller: Akıllı Trafik Polisi", doc)

#lesson_header(
  21,
  "Ingress & Ingress Controller: Akıllı Trafik Polisi",
  "Ingress & Ingress Controllers: The Smart Traffic Cop",
  "Ağ, Keşif & Dış Dünyaya Açılma",
  "Networking, Discovery & Ingress Routing"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      50 katlı bir holding binasında her ofis için ayrı sokak kapısı yapamazsınız! Binanın tek bir ana döner kapısı ve lobisinde akıllı bir danışma görevlisi (Ingress Controller) olur. Gelen kişiye sorar: 'Kime geldiniz?' Kişi 'Kafeye (`/coffee`)' derse kafeye, 'Muhasebeye (`/billing`)' derse 5. kata yönlendirir. Üstelik kapıda kimlik kontrolü (SSL/TLS şifreleme) yapar!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[You don't build 50 separate front doors for a 50-story skyscraper! You have 1 grand lobby entrance with a sharp receptionist (Ingress Controller). Guests state their destination: 'Going to the coffee shop (`/coffee`)?' Turn left. 'Accounting (`/billing`)?' Elevator 4. Plus, the receptionist checks IDs and encrypts passes (HTTPS / SSL termination)!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Ingress iki bileşenden oluşur: 1) Ingress Kaynağı (Kuralları belirten YAML dosyası), 2) Ingress Controller (Bu kuralları dinleyip uygulayan NGINX, Traefik, Envoy veya HAProxy pod'u). Ingress Controller, 7. katman (HTTP/HTTPS) yönlendirmesi yapar: Domain adına göre (`api.sirket.com` vs `web.sirket.com`) veya URL yoluna göre (`/api` vs `/auth`) trafiği ilgili ClusterIP servisine aktarır. SSL sertifikası tek merkezde sonlandırılır.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Ingress splits into: 1) Ingress Resource (declarative routing rules in YAML), 2) Ingress Controller (reverse proxy daemon like Ingress-NGINX or Traefik reconciling those rules). Operating at Layer 7 (HTTP/HTTPS), it terminates TLS, rewrites paths, and directs traffic based on SNI hostnames and URL path prefixes to backend ClusterIPs.]
    ]
  )
]

#spring_box[
```yaml
# coffee-ingress.yaml
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
                  number: 80
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Ingress YAML'ı yazmak tek başına HİÇBİR İŞE YARAMAZ! Kümenizde çalışan aktif bir Ingress Controller (örn: ingress-nginx) yoksa, yazdığınız Ingress kuralları sessizce havada asılı kalır.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Applying an Ingress manifest without an active Ingress Controller running in your cluster does absolutely nothing; the resource remains dormant.]
    ]
  )
]

#takeaways_box((
    ("Ingress tek bir genel IP arkasında yüzlerce servisi akıllıca paylaştırır.", "A single Ingress exposes hundreds of microservices behind 1 public IP."),
    ("Host-tabanlı ve Path-tabanlı 7. katman yönlendirmelerini destekler.", "Supports host-based (virtual hosting) and path-based Layer 7 routing."),
    ("SSL/TLS sertifikalarını tek merkezde yönetip güvenliği artırır.", "Centralizes TLS termination and SSL certificate lifecycle management."),
))
