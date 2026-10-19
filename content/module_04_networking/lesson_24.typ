#import "/template.typ": *

#show: doc => setup_book(title: "Ders 24: ConfigMap ve Secret: Konfigürasyonu Koddan Ayırma", doc)

#lesson_header(
  24,
  "ConfigMap ve Secret: Konfigürasyonu Koddan Ayırma",
  "Externalizing Config: ConfigMaps and Secrets with Spring Boot",
  "Ağ, Keşif & Dış Dünyaya Açılma",
  "Networking, Discovery & Ingress Routing"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Telefon numaranız veya şifreniz değiştiğinde yeni bir telefon satın almazsınız! Aynı şekilde veritabanı şifresi değiştiğinde Spring Boot kodunu yeniden derleyip Docker imajı almamalısınız. ConfigMap: Herkesin görebileceği açık duyuru panosudur (API URL'leri, tema rengi). Secret: Kilitli çelik kasadır (Şifreler, kredi kartı API anahtarları)!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[When you change your Netflix password, you don't throw your TV in the trash and buy a new one! Similarly, when a DB password rotates, you don't recompile your Java code into a new Docker image. ConfigMaps are public bulletin boards (log levels, URLs). Secrets are locked steel safes (passwords, JWT signing keys)!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Twelve-Factor App metodolojisinin 3. kuralı: 'Konfigürasyonu koddan ayır!' K8s iki nesne sunar: 1) ConfigMap: Düz metin anahtar-değer çiftleri, 2) Secret: Base64 kodlanmış hassas veriler. Bu veriler pod'a iki şekilde aktarılır: Ortam değişkeni (Environment Variable) olarak veya dosya olarak (Volume Mount). Spring Boot, `application.yml` içindeki `${DB_PASSWORD}` değişkenlerini bu sayede sıfır kod değişikliğiyle otomatik enjekte eder.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Twelve-Factor App principle III: Strict separation of config from code. 1) ConfigMaps store non-confidential key-value pairs. 2) Secrets store sensitive credentials base64-encoded (or encrypted at rest via KMS). Injected into pods either as environment variables (`envFrom`) or mounted as files. Spring Boot seamlessly binds them into `@Value` and `@ConfigurationProperties`.]
    ]
  )
]

#spring_box[
```bash
# ConfigMap ve Secret'ı Pod'a Aktarma:
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
              key: DB_PASSWORD
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      K8s Secret'ları varsayılan olarak şifrelenmiş (encrypted) DEĞİLDİR; sadece Base64 ile encode edilmiştir! Yani `echo 'c2VjcmV0' | base64 -d` yazan herkes şifreyi görebilir. Gerçek güvenlik için etcd 'Encryption at Rest' veya HashiCorp Vault / AWS Secrets Manager kullanılmalıdır.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Kubernetes Secrets are NOT encrypted by default; they are merely Base64-encoded! Anyone with read access can decode them. Enable KMS encryption-at-rest in etcd.]
    ]
  )
]

#takeaways_box((
    ("Aynı Docker imajı dev, test ve prod ortamlarında sıfır değişiklikle çalışır.", "The same immutable container image runs across dev, stage, and prod via config injection."),
    ("Ortam değişkenleri veya dosya bağlama (volume mount) ile pod'a aktarılır.", "Configs can be mounted dynamically as filesystem directories or environment vars."),
    ("Secret'lar hassas verileri Git reposuna koyma felaketini önler.", "Keeps passwords and private keys out of public Git version control repositories."),
))
