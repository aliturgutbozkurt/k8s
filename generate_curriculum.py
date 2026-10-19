#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
generate_curriculum.py
Generates the complete 10-Module, 60-Lesson Bilingual (TR & EN) ELI5 Training Suite
for Kubernetes, OpenShift, k9s, Operators, Flux, Docker & GitHub Actions with Java Spring Boot.
"""

import os
import json
from pathlib import Path

BASE_DIR = Path("/Users/aliturgutbozkurt/Desktop/k8s")
CONTENT_DIR = BASE_DIR / "content"
OUTPUT_DIR = BASE_DIR / "output"
WEB_DIR = BASE_DIR / "web"

MODULES_DATA = [
    {
        "id": 1,
        "dir": "module_01_docker",
        "title_tr": "Konteyner Dünyası & Docker Temelleri",
        "title_en": "Container World & Docker Fundamentals",
        "desc_tr": "Yazılım dünyasının standart kargo konteynerleri: Sanal makinelerden Docker'a, multi-stage Spring Boot derlemelerine ve ağ yönetimine sıfırdan adım atış.",
        "desc_en": "The standard shipping containers of software: From VMs to Docker, multi-stage Spring Boot builds, volumes, and networks from scratch.",
        "lessons": [
            {
                "num": 1,
                "title_tr": "“Ama Benim Bilgisayarımda Çalışıyordu!” — Sanal Makineler vs Konteynerler",
                "title_en": "“It Worked on My Machine!” — Virtual Machines vs Containers",
                "eli5_tr": "Eskiden bir tüccar kumaş, diğeri zeytinyağı fıçısı, öbürü gevşek buğday çuvalı taşırdı. Gemiyi yüklemek günler sürer, çuvallar patlar, her şey birbirine karışırdı! 1956'da standart çelik kargo konteyneri icat edildi. Artık gemi vincinin içinde ne olduğunu bilmesine gerek yok; standart kutuyu alır, koyar! Docker da yazılım dünyasının standart çelik kutusudur. Sanal Makine (VM) koca bir evi temeliyle taşımak gibidir; Docker Konteyneri ise sadece eşyalarınızı bavula koyup taşımak gibidir!",
                "eli5_en": "Back in the 1950s, dockers loaded odd wooden barrels, loose bags of grain, and fragile crates by hand. Cargo took days to load and frequently broke. In 1956, the standardized steel shipping container changed human trade forever! Cranes didn't care what was inside—only that it fit the standard locks. Docker is that exact shipping container for software. A Virtual Machine (VM) is like transporting an entire house including foundations; a Container is packing just your suitcase with only the essentials!",
                "deep_tr": "Sanal Makineler (Hypervisor Type 1/2) her uygulama için ayrı bir misafir işletim sistemi (Guest OS), ayrı sanal donanım ve kendi çekirdeğini (Kernel) ayağa kaldırır. Bu da gigabaytlarca RAM ve dakikalar süren açılış süresi demektir. Docker konteynerleri ise doğrudan ana makinenin Linux çekirdeğini paylaşır. İzolasyon iki temel Linux çekirdek özelliğiyle sağlanır: 1) Namespaces (Konteynerin sadece kendi süreçlerini, ağını ve dosya sistemini görmesini sağlar; sanal göz bağıdır), 2) Cgroups (Control Groups: CPU ve RAM kotasını sınırlar).",
                "deep_en": "Virtual Machines (Type 1/2 Hypervisors) virtualize physical hardware. Every VM runs a complete Guest OS kernel, consuming gigabytes of memory and taking minutes to boot. Docker containers share the host Linux kernel. Isolation is achieved via two core Linux kernel primitives: 1) Namespaces (isolate PID, Mount, Net, IPC, UTS, User so processes think they own the machine), and 2) Cgroups (Control Groups, metering and limiting CPU, RAM, and IOPS).",
                "spring_code": """# Doğrudan sunucuda çalıştırmak (Kötü Yöntem):
# Java 17 mi kurulu, 21 mi? Hangi glibc sürümü var? Kimse bilmez!
java -jar target/spring-boot-k8s-eli5-1.0.0.jar

# Docker ile standart çelik konteynerde çalıştırmak (Modern Yöntem):
docker run -d -p 8080:8080 --name my-spring-coffee ghcr.io/eli5-k8s/spring-boot-k8s-eli5:1.0.0""",
                "warning_tr": "Konteynerler tam anlamıyla bir sanal makine değildir! Ana işletim sisteminin çekirdeğini (kernel) kullandıkları için, Linux tabanlı bir konteyner doğrudan saf Windows çekirdeğinde çalışmaz (arka planda WSL2 veya Hyper-V Linux VM gerekir).",
                "warning_en": "Containers are NOT lightweight virtual machines! Because they share the host kernel, Linux containers on Windows/macOS secretly run inside a thin Linux VM (WSL2 / Apple Hypervisor).",
                "takeaways": [
                    ("Konteynerler Guest OS yükünü ortadan kaldırarak saniyeler içinde ayağa kalkar.", "Containers eliminate Guest OS overhead, starting in milliseconds."),
                    ("Linux Namespaces görünürlüğü, Cgroups ise CPU/Bellek limitlerini kontrol eder.", "Namespaces provide visibility boundaries; Cgroups enforce resource limits."),
                    ("Java uygulaması her işletim sisteminde aynı JRE ve bağımlılıklarla garanti çalışır.", "Guarantees identical Java runtime behavior across laptops, staging, and production.")
                ]
            },
            {
                "num": 2,
                "title_tr": "Docker Mimarisi: İmaj (Image), Konteyner (Container) ve Registry",
                "title_en": "Docker Architecture: Images, Containers, and Registries",
                "eli5_tr": "Anneannenizin meşhur elmalı pasta tarifi defterde yazılıdır; buna 'İmaj' (Image) denir. Bu tariften fırında pişirdiğiniz, yiyebileceğiniz sıcacık pasta ise 'Konteyner'dir (Container). Tek bir tariften 100 tane özdeş pasta pişirebilirsiniz. Yemek tarifi siteleri (Docker Hub, GitHub Packages) ise 'Registry'dir!",
                "eli5_en": "Your grandma's apple pie recipe written in a cookbook is the 'Docker Image'. The actual warm, edible pie baked in the oven is the 'Container'. You can bake 100 identical pies from that single recipe. The online culinary recipe library is the 'Registry' (Docker Hub, Quay, GHCR)!",
                "deep_tr": "Docker Image, salt-okunur (read-only) katmanlardan (layers) oluşan bir OCI (Open Container Initiative) paketidir. Union File System (UnionFS/Overlay2) sayesinde her katman bir öncekinin üzerine bindirilir. Bir konteyner başlattığınızda, bu salt-okunur katmanların en tepesine incecik bir 'Yazılabilir Katman' (Writable Container Layer) eklenir. Dosya silindiğinde veya değiştirildiğinde 'Copy-on-Write' (CoW) mekanizması devreye girer.",
                "deep_en": "A Docker Image is an OCI-compliant package consisting of stacked read-only layers. Using an Overlay2 Union File System, each instruction in a Dockerfile generates an immutable layer. When a container runs, Docker attaches a thin writable layer on top. Any file modification uses the Copy-on-Write (CoW) strategy without mutating the underlying image.",
                "spring_code": """# 1. Uzak depodan (Registry) imaj çek
docker pull eclipse-temurin:21-jre-alpine

# 2. İmajları listele
docker images

# 3. İmajdan çalışan bir konteyner üret (Tariften pasta pişir!)
docker run -d --name coffee-service -p 8080:8080 ghcr.io/eli5-k8s/spring-boot-k8s-eli5:1.0.0

# 4. Çalışan konteynerleri denetle
docker ps""",
                "warning_tr": "Konteyneri durdurup sildiğinizde (docker rm), o en üstteki yazılabilir katmandaki tüm veriler (loglar, geçici dosyalar) anında yok olur! Kalıcı veri için mutlaka 'Volume' kullanılmalıdır.",
                "warning_en": "When you destroy a container (`docker rm`), its writable top layer is destroyed forever! Never store production databases or uploads inside the container's ephemeral writable layer.",
                "takeaways": [
                    ("İmaj değişmez (immutable) bir şablondur; Konteyner onun canlı örneğidir.", "An Image is an immutable template; a Container is its running process instance."),
                    ("Overlay2 dosya sistemi katmanları paylaşarak disk ve indirme tasarrufu sağlar.", "Overlay2 shares identical layers across images to save bandwidth and disk."),
                    ("Registry'ler imajların güvenli dağıtıldığı global kütüphanelerdir.", "Registries are centralized libraries for sharing versioned container images.")
                ]
            },
            {
                "num": 3,
                "title_tr": "Java Spring Boot Uygulamasını Paketleme: Multi-Stage Build & Layered JAR",
                "title_en": "Packaging Java Spring Boot: Multi-Stage Builds & Layered JARs",
                "eli5_tr": "Kocaman un çuvallarını, mikseri ve kirli tencereleri salondaki yemek masasına koymazsınız! Mutfakta yemeği pişirir (Maven ile derleme), salona garsonla sadece şık porselen tabaktaki yemeği yollarsınız (JRE). Multi-stage build tam olarak budur: Derleme araçlarını çöpe at, sadece çalışan Java kodunu son imaja koy!",
                "eli5_en": "You don't serve your dinner guests by wheeling 50kg sacks of flour and dirty mixing bowls into the dining room! You cook in the kitchen (Maven build) and carry only the clean porcelain plate to the table (JRE). Multi-stage builds discard the 800MB compiler tools and package only the lean 50MB runtime!",
                "deep_tr": "Spring Boot 2.3+ ile gelen 'Layered JAR' mimarisi, geleneksel tek parça (fat/uber) JAR'ları 4 mantıksal katmana böler: 1) dependencies (nadiren değişir), 2) spring-boot-loader, 3) snapshot-dependencies, 4) application (sizin kodunuz; her commit'te değişir). Dockerfile'da `java -Djarmode=layertools -jar app.jar extract` çalıştırarak bu katmanları ayırırız. Böylece 1 satır Java kodu değiştirdiğinizde Docker sadece 1MB'lık application katmanını yeniden derler; 150MB'lık kütüphaneleri baştan indirmez!",
                "deep_en": "Spring Boot layered JARs separate fat JARs into 4 distinct layers: 1) dependencies, 2) spring-boot-loader, 3) snapshot-dependencies, 4) application code. By running `java -Djarmode=layertools -jar app.jar extract`, Docker caches the 150MB third-party libraries indefinitely. When you change one Java class, Docker only invalidates and pushes the 2MB application layer!",
                "spring_code": """# Dockerfile'da Katmanları Çıkarma ve Kopyalama:
FROM eclipse-temurin:21-jre-alpine AS extractor
WORKDIR /build
COPY target/spring-boot-k8s-eli5-1.0.0.jar app.jar
RUN java -Djarmode=layertools -jar app.jar extract

FROM eclipse-temurin:21-jre-alpine AS runner
WORKDIR /app
COPY --from=extractor /build/dependencies/ ./
COPY --from=extractor /build/spring-boot-loader/ ./
COPY --from=extractor /build/snapshot-dependencies/ ./
COPY --from=extractor /build/application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]""",
                "warning_tr": "Multi-stage kullanmazsanız, JDK derleyicisi ve Maven yerel deposu (~/.m2) imajın içinde kalır; imaj boyutunuz 250MB yerine 1.2GB olur ve güvenlik açıkları tavan yapar!",
                "warning_en": "Without multi-stage builds, your JDK compiler, git, and ~/.m2 cache leak into production, inflating your image from 200MB to 1.5GB with huge security risks.",
                "takeaways": [
                    ("Multi-stage build ile derleme ortamı ve çalışma ortamı tamamen ayrılır.", "Multi-stage builds decouple build tools from the minimal runtime image."),
                    ("Spring Boot Layered JAR ile Docker derleme süreleri %90 hızlanır.", "Layered JAR caching reduces image build and push times by up to 90%."),
                    ("Konteyner imajı küçüldükçe ağ transferi hızlanır, güvenlik açıkları azalır.", "Smaller images transfer faster and significantly reduce attack surface.")
                ]
            },
            {
                "num": 4,
                "title_tr": "Docker Veri Saklama ve Ağ: Volumes ve Bridge Networks",
                "title_en": "Docker Storage & Networking: Volumes and Bridge Networks",
                "eli5_tr": "Konteyner bir otel odası gibidir. Sabah check-out yaptığınızda temizlik görevlisi gelir ve odadaki her şeyi çöpe atar! Kalıcı eşyalarınızı otelin kiralık çelik kasasında (Volume) saklamalısınız. Odalar arası telefon hattı ise Docker Network'tür; oda numarasını (konteyner adını) çevirip doğrudan konuşursunuz.",
                "eli5_en": "Containers are like luxury hotel rooms. When you check out, the maid throws everything in the room into the incinerator! To keep your laptop and passport safe, you store them in the hotel's secure basement locker (Docker Volume). The intercom phone between rooms is the Docker Network; just dial the room name to talk.",
                "deep_tr": "Docker'da üç temel veri saklama yöntemi vardır: 1) Named Volumes (Docker tarafından `/var/lib/docker/volumes` altında yönetilir; en yüksek performans ve taşınabilirlik), 2) Bind Mounts (Host makinedeki doğrudan bir klasörü `/Users/.../data` konteyner içine bağlar; geliştirme anında kod senkronizasyonu için idealdir), 3) tmpfs (Sadece RAM'de saklanır). Ağ tarafında ise varsayılan `bridge` ağı, konteynerler arasında yerleşik DNS çözünürlüğü sunar. Konteynerler birbirine IP ile değil isimleriyle (`postgres-db:5432`) erişir.",
                "deep_en": "Storage strategies: 1) Named Volumes (managed under `/var/lib/docker/volumes`, isolated from host OS quirks, best performance), 2) Bind Mounts (mounts arbitrary host paths, ideal for local dev live-reload), 3) tmpfs (stored strictly in host memory). On the networking side, user-defined bridge networks provide automatic embedded DNS resolution between containers by container name.",
                "spring_code": """# 1. Özel bir bridge ağı oluştur
docker network create coffee-net

# 2. Kalıcı bir veri diski (Volume) oluştur
docker volume create postgres-data

# 3. PostgreSQL'i ağa ve diske bağlayarak başlat
docker run -d --name postgres-db --network coffee-net \\
  -v postgres-data:/var/lib/postgresql/data \\
  -e POSTGRES_PASSWORD=secret -e POSTGRES_DB=coffeedb postgres:16-alpine

# 4. Spring Boot'u aynı ağa bağla (IP yerine doğrudan 'postgres-db' adını kullanır!)
docker run -d --name coffee-api --network coffee-net -p 8080:8080 \\
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://postgres-db:5432/coffeedb \\
  ghcr.io/eli5-k8s/spring-boot-k8s-eli5:1.0.0""",
                "warning_tr": "Varsayılan (default) bridge ağında konteyner isimleriyle otomatik DNS çözümlemesi çalışmaz! İsimle haberleşme için mutlaka `docker network create` ile kendi özel ağınızı oluşturmalısınız.",
                "warning_en": "The default legacy docker0 bridge does NOT provide automatic DNS resolution by container name! Always create a user-defined bridge network.",
                "takeaways": [
                    ("Named Volumes konteyner silinse bile veritabanı verilerini korur.", "Named volumes persist state even when containers are stopped and destroyed."),
                    ("Docker yerel DNS'i sayesinde konteynerler IP değişse bile birbirini bulur.", "Docker embedded DNS resolves container names dynamically without static IPs."),
                    ("Veritabanı ve Spring Boot uygulamalarını aynı özel ağa bağlamak şarttır.", "Co-locating apps and databases on dedicated networks isolates traffic securely.")
                ]
            },
            {
                "num": 5,
                "title_tr": "Docker Compose ile Çoklu Servis: Spring Boot + PostgreSQL Çiftliği",
                "title_en": "Multi-Service Stacks with Docker Compose: Spring Boot + PostgreSQL",
                "eli5_tr": "Restoranda tek başına yemek yapmak kolaydır. Ama aynı anda ekmek fırınını, et ızgarasını ve tatlı reyonunu senkronize başlatmak için bir şefe ve nota kağıdına ihtiyacınız vardır. Docker Compose o nota kağıdıdır (`docker-compose.yml`). Tek bir tuşla (`docker compose up`) tüm orkestra kusursuz sırada sahneye çıkar!",
                "eli5_en": "Playing a solo flute is easy. Conducting a 20-piece symphony requires sheet music! Docker Compose is the master sheet music (`docker-compose.yml`). With a single command (`docker compose up`), your database, Redis cache, and Spring Boot backend spawn in perfect harmony!",
                "deep_tr": "Docker Compose bildirici (declarative) bir YAML dosyasıyla servisleri, ağları ve diskleri tek bir çatı altında tanımlar. `depends_on` mekanizması başlatma sırasını belirler; `healthcheck` bloğu ile birleştirildiğinde Spring Boot servisinin PostgreSQL tamamen 'ready' olana kadar beklemesi sağlanabilir. Ortam değişkenleri (`environment`), port haritalamaları (`ports`) ve secret dosyaları tek merkezden yönetilir.",
                "deep_en": "Docker Compose declaratively defines multi-container applications. Using `depends_on` with `condition: service_healthy`, Compose ensures your Spring Boot service pauses booting until PostgreSQL is genuinely accepting TCP connections, eliminating startup connection crashes.",
                "spring_code": """# docker-compose.yml
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
  postgres-data:""",
                "warning_tr": "`depends_on` tek başına sadece veritabanı konteynerinin başladığını doğrular; veritabanı motorunun bağlantı kabul etmeye hazır olduğunu garanti etmez. Mutlaka `condition: service_healthy` ile birlikte kullanılmalıdır!",
                "warning_en": "A bare `depends_on` only waits for the container process to spawn, NOT for PostgreSQL to be ready! Always pair it with healthcheck conditions.",
                "takeaways": [
                    ("Tek bir komut (`docker compose up -d`) ile tüm mikroservis yığını ayağa kalkar.", "Spawn entire multi-tier architectures with a single `docker compose up -d` command."),
                    ("Healthcheck blokları servisler arası yarış durumlarını (race condition) önler.", "Healthchecks eliminate startup race conditions between apps and databases."),
                    ("Yerel geliştirme ortamını üretim ortamına en yakın hale getirir.", "Mirrors production topology on local developer machines seamlessly.")
                ]
            },
            {
                "num": 6,
                "title_tr": "Container Güvenliği & İmaj Optimizasyonu: Distroless, Alpine & Non-Root",
                "title_en": "Container Security & Image Optimization: Distroless, Alpine & Non-Root",
                "eli5_tr": "Uçağa binerken yanınıza 150 kiloluk gardırop almazsınız; hem fazla para ödersiniz hem de hırsızlara davetiye çıkarırsınız! Standart Ubuntu imajında hacker'ların kullanabileceği 500 tane gereksiz araç (curl, apt, bash) vardır. Zırhlı mini imajda (Alpine veya Distroless) ise sadece Java çalışır. Üstüne bir de kapıya 'ROOT GİREMEZ' tabelası asarız!",
                "eli5_en": "You don't travel with a 150kg solid oak wardrobe on an airplane! Bloated images carry 500 unused utilities (bash, curl, package managers) that attackers love to exploit. Hardened minimal images (Alpine, Distroless) contain ONLY your Java binary. And we lock out the superuser by hanging a strict 'NO ROOT ALLOWED' sign!",
                "deep_tr": "Varsayılan olarak Docker konteynerleri `root` (UID 0) kullanıcısıyla çalışır. Konteynerden kaçış (container breakout) açığı oluşursa, saldırgan ana sunucuda da tam yetkili root olur! Bu yüzden: 1) Dockerfile içinde özel bir `appuser` (UID 10001) tanımlanmalıdır. 2) Paket yöneticisi ve kabuk (shell) bile içermeyen Google Distroless veya hafif Alpine imajları tercih edilmelidir. 3) Trivy veya Grype ile imajdaki CVE güvenlik açıkları CI pipeline'ında taranmalıdır.",
                "deep_en": "By default, containers execute as `root` (UID 0). In the event of a Linux kernel or container breakout vulnerability, an attacker gains root on the physical host. Mitigation requires: 1) Enforcing non-root users (`USER 10001`), 2) Using shell-less Distroless bases, 3) Automated scanning for known CVEs via Trivy.",
                "spring_code": """# Güvenli Dockerfile Snippet:
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# 1. Root olmayan grup ve kullanıcı yarat
RUN addgroup -S appgroup -g 10001 && \\
    adduser -S appuser -u 10001 -G appgroup

# 2. Sahipliği ver ve kullanıcıya geç
COPY --chown=appuser:appgroup target/app.jar app.jar
USER 10001:10001

# 3. Bellek sınırını JVM'e bildir (K8s pod çökmesini engeller)
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:+UseG1GC"
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]""",
                "warning_tr": "Konteyneri root olmayan kullanıcıyla çalıştırırken port numarasını 1024'ün altında (örneğin port 80) seçmeyin; Linux geleneksel olarak 1024 altındaki portları sadece root'a tahsis eder. Her zaman 8080 gibi yüksek portlar seçin!",
                "warning_en": "Non-root users cannot bind to privileged ports below 1024 (e.g. port 80). Always configure Spring Boot on high ports like 8080.",
                "takeaways": [
                    ("Üretim ortamında ASLA konteynerleri root kullanıcısıyla çalıştırmayın.", "NEVER execute containers as root in enterprise environments."),
                    ("Distroless ve Alpine taban imajları saldırı yüzeyini ve dosya boyutunu küçültür.", "Distroless and Alpine minimize the attack surface and download size."),
                    ("JVM `-XX:MaxRAMPercentage` ayarı bellek taşmalarını (OOMKilled) önler.", "JVM container flags align Java heap limits with container cgroup limits.")
                ]
            }
        ]
    },
    {
        "id": 2,
        "dir": "module_02_k8s_basics",
        "title_tr": "Kubernetes ile Tanışma — Orkestra Şefi",
        "title_en": "Introduction to Kubernetes — The Conductor",
        "desc_tr": "Neden sadece Docker yetmez? K8s mimarisi, Control Plane, Worker Node'lar, Pod kavramı ve ilk Spring Boot manifestomuzu çalıştırma rehberi.",
        "desc_en": "Why Docker alone falls short: K8s architecture, Control Plane, Worker Nodes, Pods, declarative models, and running your first Spring Boot manifest.",
        "lessons": [
            {
                "num": 7,
                "title_tr": "Neden Sadece Docker Yetmez? Kubernetes Neyi Çözer?",
                "title_en": "Why Docker Alone Isn't Enough: What Kubernetes Actually Solves",
                "eli5_tr": "Elinizde tek bir usta ve 1 fırın varken Docker harikadır. Ama ya restoranınız bir anda 10.000 şubeli bir dünya zincirine dönüşürse? Gece saat 03:00'te bir sunucunun fişi çekildiğinde, içindeki 50 konteyneri kim diğer sunuculara taşıyacak? Trafik 10 katına çıktığında kim anında 40 yeni konteyner açacak? İşte Kubernetes, 1.000 gemiyi ve 100.000 konteyneri tek bir parmak şıklatmasıyla yöneten baş amiraldir!",
                "eli5_en": "Docker is great when managing a single coffee stall. But what happens when you run a global chain of 10,000 shops? If a server catches fire at 3 AM, who wakes up to resurrect the 50 crashed containers on another server? Who adds 40 extra containers when traffic surges 1000%? Kubernetes is the supreme admiral orchestrating a fleet of thousands of ships automatically!",
                "deep_tr": "Docker tek bir host (tekil sunucu) üzerinde konteyner çalıştırır. Kubernetes (K8s) ise onlarca hatta binlerce fiziksel sunucuyu tek bir devasa soyut süper-bilgisayar gibi birleştirir. Temel yetenekleri: 1) Automated Scheduling (Konteyneri en uygun kaynaklı sunucuya yerleştirme), 2) Self-Healing (Çöken konteynerleri yeniden başlatma, yanıt vermeyen düğümleri tahliye etme), 3) Horizontal Auto-Scaling (CPU/Trafiğe göre otomatik çoğalma), 4) Service Discovery & Load Balancing (Trafiği sağlıklı konteynerlere eşit dağıtma).",
                "deep_en": "Docker manages containers on a single host. Kubernetes abstracts an entire fleet of physical/virtual machines into a single unified elastic compute fabric. Its core primitives deliver: 1) Automated scheduling & bin packing, 2) Self-healing & node drain automation, 3) Horizontal Pod Autoscaling (HPA), and 4) Automated discovery and Layer 4/7 load balancing.",
                "spring_code": """# Docker ile manuel çile (Sunucu çökerse bittiniz!):
ssh server-01 "docker run -d -p 8080:8080 my-coffee-app:1.0"

# Kubernetes ile bildirici güç (Sunucu patlasa da K8s başka sunucuda anında açar):
kubectl apply -f deployment.yaml""",
                "warning_tr": "Kubernetes bir sihirli değnek değildir! Kötü yazılmış, bellek sızdıran veya 'graceful shutdown' desteklemeyen bir Spring Boot uygulamasını K8s'e koyarsanız sadece hatalarınızı daha hızlı çoğaltmış olursunuz.",
                "warning_en": "Kubernetes does not fix broken code. If your Spring Boot app leaks memory or crashes on SIGTERM, K8s will just reboot and crash it faster.",
                "takeaways": [
                    ("Docker konteynerleri çalıştırır; Kubernetes binlerce konteyneri orkestre eder.", "Docker runs containers; Kubernetes orchestrates thousands across clusters."),
                    ("Kendi kendini iyileştirme (Self-Healing) sayesinde gece mühendis uykusundan uyanmaz.", "Self-healing keeps systems alive without manual midnight engineering interventions."),
                    ("Yüzlerce sunucu tek bir dev işlemci ve bellek havuzuna dönüştürülür.", "Aggregates disparate physical nodes into a singular logical compute pool.")
                ]
            },
            {
                "num": 8,
                "title_tr": "K8s Mimarisi: Control Plane (Beyin) vs Worker Nodes (Kas Gücü)",
                "title_en": "K8s Architecture: Control Plane (Brain) vs Worker Nodes (Muscle)",
                "eli5_tr": "Dev bir inşaat şirketi düşünün. Şirketin lüks genel merkezinde (Control Plane) oturan yöneticiler vardır: 1) Resepsiyonist (API Server): Tüm emirleri kabul eder. 2) Noter (etcd): Yapılan her sözleşmeyi kasaya kilitler. 3) Teşrifatçı (Scheduler): Hangi işçinin hangi şantiyeye gideceğini seçer. 4) Denetmen (Controller Manager): Eksik işçi var mı diye kontrol eder. Şantiyede (Worker Node) ise baretini takıp harç karan işçiler (Kubelet ve Kube-Proxy) bulunur!",
                "eli5_en": "Picture a massive global construction firm. The air-conditioned headquarters is the Control Plane: 1) Receptionist (API Server): The only entry door for orders. 2) Master Vault (etcd): Immutable ledger storing all facts. 3) Dispatcher (Scheduler): Decides which worker goes to which site. 4) Inspector (Controller Manager): Constantly counts headcount. The actual construction sites are Worker Nodes with Kubelet (Site Foreman) and Kube-Proxy (Traffic Controller)!",
                "deep_tr": "Control Plane bileşenleri: 1) kube-apiserver (REST API sunar; tüm bileşenler sadece onunla konuşur), 2) etcd (Raft konsensüs algoritması kullanan dağıtık anahtar-değer veritabanı; kümenin tek gerçek kaynağı), 3) kube-scheduler (Kaynak ihtiyaçlarına göre Pod'u en uygun Node'a atar), 4) kube-controller-manager (Deployment, Node, Endpoints kontrol döngülerini çalıştırır). Worker Node bileşenleri: 1) kubelet (Düğümdeki K8s ajanı; konteynerleri başlatır ve denetler), 2) kube-proxy (Ağ kurallarını ve iptables/IPVS yönlendirmelerini yönetir), 3) Container Runtime (containerd/CRI-O).",
                "deep_en": "Control Plane internals: 1) kube-apiserver (central REST gateway; all cluster state passes here), 2) etcd (high-availability Raft-backed key-value store), 3) kube-scheduler (assigns unscheduled pods to optimal nodes), 4) kube-controller-manager (executes reconciliation loops). Worker Node components: 1) kubelet (node agent interacting with CRI to manage containers), 2) kube-proxy (maintains network packet filtering rules via iptables/IPVS), 3) Container Runtime (CRI-O / containerd).",
                "spring_code": """# Control plane ve worker node'ların durumunu sorgula:
kubectl get nodes -o wide

# Cluster bileşenlerinin sağlık durumunu kontrol et:
kubectl get componentstatuses 2>/dev/null || kubectl get --raw='/readyz'""",
                "warning_tr": "etcd veritabanı çökerse tüm küme kör olur! Üretim ortamında etcd her zaman tek sayılı (3 veya 5 düğüm) quorum mimarisiyle ve yüksek hızlı SSD disklerle çalıştırılmalıdır.",
                "warning_en": "If etcd loses quorum, your entire cluster enters read-only paralysis! Always run 3 or 5 odd-numbered etcd nodes on dedicated NVMe storage.",
                "takeaways": [
                    ("API Server kümenin tek giriş kapısıdır; kimse doğrudan etcd ile konuşamaz.", "The API Server is the sole gateway; components never talk directly to etcd."),
                    ("Kubelet, API Server'dan aldığı talimatları yerel konteyner motoruna iletir.", "Kubelet ensures containers described in PodSpecs are running and healthy."),
                    ("Düğümler arızalansa bile Control Plane pod'ları başka düğümlere taşır.", "When a worker node dies, the Control Plane reschedules pods seamlessly.")
                ]
            },
            {
                "num": 9,
                "title_tr": "En Temel Atom: Pod Nedir? Neden Doğrudan Konteyner Değil?",
                "title_en": "The Atomic Unit: What is a Pod and Why Not Bare Containers?",
                "eli5_tr": "K8s dünyasında tek başına konteyner kiralayamazsınız; en küçük kiralık daire 'Pod'dur! Pod bir bezelye kabuğu, konteynerler ise içindeki bezelyelerdir. Çoğunlukla bir pod'da 1 bezelye (örneğin Spring Boot) yaşar. Ama bazen ana uygulamanın yanına ona yardımcı olan bir oda arkadaşı (Sidecar Konteyneri: örneğin log toplayıcı veya güvenlik ajanı) koyarsınız. Aynı pod'daki konteynerler aynı banyoyu (IP adresi) ve aynı buzdolabını (ortak disk) paylaşır!",
                "eli5_en": "In Kubernetes, you cannot rent a bare container; the smallest rentable apartment is a 'Pod'! A Pod is a pea pod, and containers are the peas inside. Usually, a pod hosts 1 main pea (your Spring Boot microservice). But sometimes, you pair it with a helpful roommate (Sidecar container: log shipper, envoy proxy). All containers in the same Pod share the exact same apartment IP and localhost loopback!",
                "deep_tr": "Pod, bir veya daha fazla konteynerin aynı Linux Network Namespace'ini, IPC namespace'ini ve depolama birimlerini paylaştığı soyut bir yapıdır. Bir pod ayağa kalktığında K8s önce 'pause' adında minik bir altyapı konteyneri başlatır. Bu pause konteyneri IP adresini ve ağ arayüzünü alır. Ardından gelen Spring Boot konteyneri ve sidecar konteynerleri bu ağ alanına katılır (`--net=container:pause`). Bu yüzden aynı pod içindeki iki farklı konteyner birbiriyle `localhost:port` üzerinden sıfır ağ gecikmesiyle konuşabilir.",
                "deep_en": "A Pod encapsulates one or more co-located containers sharing Linux IPC, UTS, and Network namespaces via a lightweight 'pause' container. When a Pod initializes, the pause container claims the Pod IP. Subsequent app and sidecar containers attach to this namespace, allowing them to communicate over `localhost` with zero network serialization overhead and shared volumes.",
                "spring_code": """# Tek Pod içinde 2 konteyner örneği (Spring Boot + Log Tailer Sidecar):
apiVersion: v1
kind: Pod
metadata:
  name: coffee-with-sidecar
spec:
  containers:
    - name: spring-app
      image: ghcr.io/eli5-k8s/spring-boot-k8s-eli5:1.0.0
      ports:
        - containerPort: 8080
    - name: log-shipper-sidecar
      image: alpine:latest
      command: ["sh", "-c", "while true; do echo 'Sidecar logging...'; sleep 10; done"]""",
                "warning_tr": "İki bağımsız iş yapan mikroservisi asla aynı pod'un içine koymayın! Pod'lar birlikte ölür ve birlikte ölçeklenir. Sadece birbirinden ayrılamaz derecede kenetlenmiş yardımcı araçlar (proxy, log forwarder) sidecar yapılmalıdır.",
                "warning_en": "Never combine two independent microservices inside the same Pod! Containers in a pod scale together. Use sidecars strictly for tightly coupled helpers.",
                "takeaways": [
                    ("Pod, Kubernetes'in zamanladığı ve yönettiği en küçük konuşlandırma birimidir.", "A Pod is the smallest atomic unit of scheduling in Kubernetes."),
                    ("Aynı Pod içindeki konteynerler localhost üzerinden haberleşir ve IP paylaşır.", "Containers inside the same Pod share an IP address and reach each other on localhost."),
                    ("Çoğu senaryoda 1 Pod = 1 Uygulama Konteyneri kuralı geçerlidir.", "The standard pattern is 1 App Container per Pod, unless utilizing a Sidecar.")
                ]
            },
            {
                "num": 10,
                "title_tr": "Bildirici (Declarative) Model vs Emirsel (Imperative) Model",
                "title_en": "Declarative Model vs Imperative Model: Desired State Philosophy",
                "eli5_tr": "Emirsel Model (Imperative): Garsona 'Mutfaktan bardağı al, 3 adım yürü, musluğu aç, suyu doldur, bana getir' demek gibidir. Bir adım aksarsa her şey kilitlenir. Bildirici Model (Declarative) ise şudur: 'Masanın üzerinde HER ZAMAN 3 bardak su istiyorum!' Biri bardağı kırarsa, garson hiç sormadan anında yeni bir bardak su koyar. K8s bildirici modelle çalışır: İstenen Durum (Desired State) = Gerçek Durum (Actual State)!",
                "eli5_en": "Imperative Model: Shouting micromanaged commands: 'Walk 5 steps, grab glass, fill water, bring it'. If step 3 fails, the system crashes. Declarative Model: 'I want 3 glasses of water on this table AT ALL TIMES.' If an earthquake shatters a glass, the waiter immediately replaces it without being asked. That is Kubernetes: Desired State equals Actual State!",
                "deep_tr": "Kubernetes'in kalbinde 'Reconciliation Loop' (Mutabakat Döngüsü) yatar. Siz bir YAML manifestosu verdiğinizde bu 'Desired State' (İstenen Durum) olarak etcd'ye yazılır. İlgili kontrolcü (örneğin DeploymentController) durmaksızın şu döngüyü çalıştırır: 1) Observe (Mevcut durumu oku: kaç pod çalışıyor?), 2) Diff (İstenen ile mevcut arasındaki farkı bul: 3 istenmiş, 2 var!), 3) Act (Farkı kapat: 1 yeni pod oluştur). Bu sayede dışarıdan bir pod manuel silinse bile K8s saniyeler içinde farkı onarır.",
                "deep_en": "Kubernetes operates via an infinite 'Reconciliation Loop'. You declare the Desired State in YAML, stored in etcd. Controllers execute a continuous 3-step loop: 1) Observe actual cluster state, 2) Diff actual against desired state, 3) Actuate corrective API calls to converge actual state back to desired state. Self-healing is an inherent byproduct of this architecture.",
                "spring_code": """# Emirsel Komut (Tavsiye Edilmez - İz bırakmaz):
kubectl run my-coffee-pod --image=ghcr.io/eli5-k8s/spring-boot-k8s-eli5:1.0.0

# Bildirici Manifest (Kurumsal Standart - Git'e konabilir):
# coffee-deployment.yaml dosyasını uygula:
kubectl apply -f coffee-deployment.yaml

# K8s istenen durum ile mevcut durum arasındaki farkı anında kapatır!""",
                "warning_tr": "Canlı kümede doğrudan `kubectl edit` veya emirsel komutlarla değişiklik yaparsanız, bir sonraki GitOps veya `kubectl apply` çalışmasında bu manuel değişiklikler ezilir ve kaybolur!",
                "warning_en": "Making ad-hoc imperative edits directly in production leads to configuration drift; the next automated pipeline run will overwrite your changes.",
                "takeaways": [
                    ("Bildirici modelde 'nasıl yapılacağını' değil, 'neyin olması gerektiğini' söyleriz.", "In declarative systems, you describe WHAT the state should be, not HOW to get there."),
                    ("Reconciliation döngüsü 7/24 istenen durum ile gerçek durumu eşitler.", "The reconciliation loop runs 24/7, continuously eliminating drift."),
                    ("Tüm altyapı YAML dosyaları olarak Git'te versiyonlanabilir (Altyapı Kod Olarak - IaC).", "Declarative YAML manifests enable version-controlled Infrastructure as Code (IaC).")
                ]
            },
            {
                "num": 11,
                "title_tr": "Yerel K8s Laboratuvarı: Minikube / Kind ve kubectl Temelleri",
                "title_en": "Local K8s Lab: Minikube / Kind and kubectl Command Mastery",
                "eli5_tr": "Koca bir Boeing 747 uçağını uçurmayı öğrenmek için hemen gerçek yolcu uçağına binmezsiniz; uçuş simülatöründe antrenman yaparsınız! Minikube veya Kind (Kubernetes IN Docker), laptopunuzun içinde güvenle çarpıp parçalayabileceğiniz minyatür bir Kubernetes kümesidir. `kubectl` ise bu uçağın direksiyonu ve vites koludur.",
                "eli5_en": "You don't learn to pilot a Boeing 747 on a live passenger flight; you practice in a flight simulator! Minikube and Kind (Kubernetes IN Docker) are zero-cost local simulators running right on your laptop where you can crash clusters safely. `kubectl` is the flight stick and control dashboard!",
                "deep_tr": "Kind (Kubernetes-in-Docker), her bir K8s düğümünü (Node) ayrı bir Docker konteyneri olarak ayağa kaldırır. Çok düğümlü (multi-node) yerel kümeleri saniyeler içinde başlatmak için idealdir. `kubectl`, `~/.kube/config` dosyasındaki kimlik doğrulama sertifikalarını ve küme uç noktalarını kullanarak doğrudan `kube-apiserver` ile HTTPS üzerinden REST haberleşmesi yapar. Temel bağlamlar (Context) arasında hızlı geçiş sağlar.",
                "deep_en": "Kind runs containerized Kubernetes nodes using Docker containers as mock hardware nodes, making multi-node cluster provisioning instantaneous. `kubectl` parses `~/.kube/config` to authenticate and route encrypted HTTPS REST requests directly to the cluster's `kube-apiserver` endpoint.",
                "spring_code": """# 1. Kind ile yerel bir K8s kümesi oluştur
kind create cluster --name eli5-cluster

# 2. Küme durumunu ve düğümleri listele
kubectl cluster-info
kubectl get nodes

# 3. Kubeconfig bağlamını kontrol et
kubectl config current-context

# 4. Tüm isim alanlarındaki pod'ları listele
kubectl get pods -A""",
                "warning_tr": "Çok fazla yerel küme açıp kapatırsanız Docker diskiniz ve belleğiniz şişebilir. Kullanmadığınız Kind kümelerini `kind delete cluster --name eli5-cluster` ile silmeyi unutmayın.",
                "warning_en": "Running multiple local Kind clusters consumes heavy RAM. Always delete unused clusters via `kind delete cluster` when done.",
                "takeaways": [
                    ("Kind ve Minikube sıfır maliyetle profesyonel K8s geliştirme ortamı sağlar.", "Kind and Minikube provide rapid, zero-cost local sandbox environments."),
                    ("`kubectl` komut satırı aracı API Server ile konuşan anahtardır.", "`kubectl` translates CLI commands into structured JSON REST requests to API Server."),
                    ("`~/.kube/config` birden fazla kümenin erişim anahtarlarını barındırır.", "The kubeconfig file manages tokens and contexts across multiple clusters.")
                ]
            },
            {
                "num": 12,
                "title_tr": "İlk Spring Boot Pod Manifestomuzu Yazma (YAML Anatomisi)",
                "title_en": "Writing Your First Spring Boot Pod Manifest (YAML Anatomy)",
                "eli5_tr": "Kubernetes'e bir dilekçe yazıyoruz! Bu resmi dilekçenin 4 kutsal bölümü vardır: 1) Hangi kanun maddesi? (`apiVersion`), 2) Ne istiyorsun? (`kind: Pod`), 3) Bu şeyin adı ne olsun? (`metadata: name`), 4) Özellikleri neler olsun? (`spec: containers`). İşte bu 4 parçayı doğru yazarsanız K8s dilekçenizi saniyeler içinde işleme koyar!",
                "eli5_en": "Writing a Kubernetes YAML is filing an official petition to the cluster government! Every petition requires 4 sacred fields: 1) What law version? (`apiVersion`), 2) What resource type? (`kind: Pod`), 3) What is its name and tag? (`metadata`), 4) What are the exact specifications? (`spec`). Get those four right, and K8s grants your wish instantly!",
                "deep_tr": "Bir K8s manifestosunun yapısı: `apiVersion` (kaynağın API sürümü; örn: Pod için `v1`, Deployment için `apps/v1`), `kind` (oluşturulacak nesne tipi), `metadata` (name, namespace, labels, annotations gibi tanımlayıcı veriler), `spec` (kaynağın istenen teknik durumu; örn: imaj adı, portlar, ortam değişkenleri). `kubectl apply -f manifest.yaml` komutu verildiğinde API Server manifestoyu doğrular, etcd'ye kaydeder ve Kubelet konteyneri çeker.",
                "deep_en": "The anatomy of every K8s resource: 1) `apiVersion` specifies the API endpoint group, 2) `kind` declares the schema type, 3) `metadata` houses names, namespaces, and queryable labels, 4) `spec` defines desired characteristics. Submitting via `kubectl apply -f` triggers schema validation in the API Server before etcd persistence.",
                "spring_code": """# spring-boot-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: spring-coffee-pod
  labels:
    app: coffee-service
    env: dev
spec:
  containers:
    - name: coffee-container
      image: ghcr.io/eli5-k8s/spring-boot-k8s-eli5:1.0.0
      ports:
        - containerPort: 8080
          name: http
      resources:
        requests:
          memory: "256Mi"
          cpu: "100m"

# Pod'u çalıştır ve loglarını izle:
# kubectl apply -f spring-boot-pod.yaml
# kubectl logs -f spring-coffee-pod""",
                "warning_tr": "YAML dosyalarında TAB tuşu KESİNLİKLE yasaktır! Hizalama için sadece boşluk (space - genelde 2 boşluk) kullanılmalıdır, aksi takdirde YAML ayrıştırma hatası alırsınız.",
                "warning_en": "YAML syntax forbids TAB characters! Use strictly 2 spaces for indentation, or the API Server parser will reject the manifest with syntax errors.",
                "takeaways": [
                    ("Her K8s kaynağı apiVersion, kind, metadata ve spec alanlarını içerir.", "Every K8s object schema shares apiVersion, kind, metadata, and spec."),
                    ("Labels (etiketler) nesneleri gruplamak ve filtrelemek için hayati önem taşır.", "Labels are key-value pairs enabling dynamic grouping, querying, and routing."),
                    ("Pod logları `kubectl logs -f <pod-name>` ile anlık olarak takip edilir.", "Inspect application stdout/stderr streams directly using `kubectl logs`.")
                ]
            }
        ]
    }
]

print("Module data blueprint initialized successfully.")
