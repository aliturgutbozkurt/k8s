#import "/template.typ": *

#show: doc => setup_book(title: "Ders 2: Docker Mimarisi: İmaj (Image), Konteyner (Container) ve Registry", doc)

#lesson_header(
  2,
  "Docker Mimarisi: İmaj (Image), Konteyner (Container) ve Registry",
  "Docker Architecture: Images, Containers, and Registries",
  "Konteyner Dünyası & Docker Temelleri",
  "Container World & Docker Fundamentals"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Anneannenizin meşhur elmalı pasta tarifi defterde yazılıdır; buna 'İmaj' (Image) denir. Bu tariften fırında pişirdiğiniz, yiyebileceğiniz sıcacık pasta ise 'Konteyner'dir (Container). Tek bir tariften 100 tane özdeş pasta pişirebilirsiniz. Yemek tarifi siteleri (Docker Hub, GitHub Packages) ise 'Registry'dir!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Your grandma's apple pie recipe written in a cookbook is the 'Docker Image'. The actual warm, edible pie baked in the oven is the 'Container'. You can bake 100 identical pies from that single recipe. The online culinary recipe library is the 'Registry' (Docker Hub, Quay, GHCR)!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Docker Image, salt-okunur (read-only) katmanlardan (layers) oluşan bir OCI (Open Container Initiative) paketidir. Union File System (UnionFS/Overlay2) sayesinde her katman bir öncekinin üzerine bindirilir. Bir konteyner başlattığınızda, bu salt-okunur katmanların en tepesine incecik bir 'Yazılabilir Katman' (Writable Container Layer) eklenir. Dosya silindiğinde veya değiştirildiğinde 'Copy-on-Write' (CoW) mekanizması devreye girer.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[A Docker Image is an OCI-compliant package consisting of stacked read-only layers. Using an Overlay2 Union File System, each instruction in a Dockerfile generates an immutable layer. When a container runs, Docker attaches a thin writable layer on top. Any file modification uses the Copy-on-Write (CoW) strategy without mutating the underlying image.]
    ]
  )
]

#spring_box[
```bash
# 1. Uzak depodan (Registry) imaj çek
docker pull eclipse-temurin:21-jre-alpine

# 2. İmajları listele
docker images

# 3. İmajdan çalışan bir konteyner üret (Tariften pasta pişir!)
docker run -d --name coffee-service -p 8080:8080 ghcr.io/eli5-k8s/spring-boot-k8s-eli5:1.0.0

# 4. Çalışan konteynerleri denetle
docker ps
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Konteyneri durdurup sildiğinizde (docker rm), o en üstteki yazılabilir katmandaki tüm veriler (loglar, geçici dosyalar) anında yok olur! Kalıcı veri için mutlaka 'Volume' kullanılmalıdır.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[When you destroy a container (`docker rm`), its writable top layer is destroyed forever! Never store production databases or uploads inside the container's ephemeral writable layer.]
    ]
  )
]

#takeaways_box((
    ("İmaj değişmez (immutable) bir şablondur; Konteyner onun canlı örneğidir.", "An Image is an immutable template; a Container is its running process instance."),
    ("Overlay2 dosya sistemi katmanları paylaşarak disk ve indirme tasarrufu sağlar.", "Overlay2 shares identical layers across images to save bandwidth and disk."),
    ("Registry'ler imajların güvenli dağıtıldığı global kütüphanelerdir.", "Registries are centralized libraries for sharing versioned container images."),
))
