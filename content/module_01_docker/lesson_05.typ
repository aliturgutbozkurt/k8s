#import "/template.typ": *

#show: doc => setup_book(title: "Ders 5: Docker Compose ile Çoklu Servis: Spring Boot + PostgreSQL Çiftliği", doc)

#lesson_header(
  5,
  "Docker Compose ile Çoklu Servis: Spring Boot + PostgreSQL Çiftliği",
  "Multi-Service Stacks with Docker Compose: Spring Boot + PostgreSQL",
  "Konteyner Dünyası & Docker Temelleri",
  "Container World & Docker Fundamentals"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Restoranda tek başına yemek yapmak kolaydır. Ama aynı anda ekmek fırınını, et ızgarasını ve tatlı reyonunu senkronize başlatmak için bir şefe ve nota kağıdına ihtiyacınız vardır. Docker Compose o nota kağıdıdır (`docker-compose.yml`). Tek bir tuşla (`docker compose up`) tüm orkestra kusursuz sırada sahneye çıkar!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Playing a solo flute is easy. Conducting a 20-piece symphony requires sheet music! Docker Compose is the master sheet music (`docker-compose.yml`). With a single command (`docker compose up`), your database, Redis cache, and Spring Boot backend spawn in perfect harmony!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Docker Compose bildirici (declarative) bir YAML dosyasıyla servisleri, ağları ve diskleri tek bir çatı altında tanımlar. `depends_on` mekanizması başlatma sırasını belirler; `healthcheck` bloğu ile birleştirildiğinde Spring Boot servisinin PostgreSQL tamamen 'ready' olana kadar beklemesi sağlanabilir. Ortam değişkenleri (`environment`), port haritalamaları (`ports`) ve secret dosyaları tek merkezden yönetilir.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Docker Compose declaratively defines multi-container applications. Using `depends_on` with `condition: service_healthy`, Compose ensures your Spring Boot service pauses booting until PostgreSQL is genuinely accepting TCP connections, eliminating startup connection crashes.]
    ]
  )
]

#spring_box[
```yaml
# docker-compose.yml
services:
  postgres-db:
    image: postgres:16-alpine
    container_name: postgres-db
    environment:
      POSTGRES_DB: coffeedb
      POSTGRES_USER: coffeeuser
      POSTGRES_PASSWORD: secretpassword
    volumes:
      - postgres-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U coffeeuser -d coffeedb"]
      interval: 5s
      timeout: 5s
      retries: 5

  coffee-app:
    build: .
    container_name: coffee-app
    ports:
      - "8080:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres-db:5432/coffeedb
      SPRING_DATASOURCE_USERNAME: coffeeuser
      SPRING_DATASOURCE_PASSWORD: secretpassword
    depends_on:
      postgres-db:
        condition: service_healthy

volumes:
  postgres-data:
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      `depends_on` tek başına sadece veritabanı konteynerinin başladığını doğrular; veritabanı motorunun bağlantı kabul etmeye hazır olduğunu garanti etmez. Mutlaka `condition: service_healthy` ile birlikte kullanılmalıdır!
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[A bare `depends_on` only waits for the container process to spawn, NOT for PostgreSQL to be ready! Always pair it with healthcheck conditions.]
    ]
  )
]

#takeaways_box((
    ("Tek bir komut (`docker compose up -d`) ile tüm mikroservis yığını ayağa kalkar.", "Spawn entire multi-tier architectures with a single `docker compose up -d` command."),
    ("Healthcheck blokları servisler arası yarış durumlarını (race condition) önler.", "Healthchecks eliminate startup race conditions between apps and databases."),
    ("Yerel geliştirme ortamını üretim ortamına en yakın hale getirir.", "Mirrors production topology on local developer machines seamlessly."),
))
