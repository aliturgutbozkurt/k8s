#import "/template.typ": *

#show: doc => setup_book(title: "Ders 7: Neden Sadece Docker Yetmez? Kubernetes Neyi Çözer?", doc)

#lesson_header(
  7,
  "Neden Sadece Docker Yetmez? Kubernetes Neyi Çözer?",
  "Why Docker Alone Isn't Enough: What Kubernetes Actually Solves",
  "Kubernetes ile Tanışma — Orkestra Şefi",
  "Introduction to Kubernetes — The Conductor"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Elinizde tek bir usta ve 1 fırın varken Docker harikadır. Ama ya restoranınız bir anda 10.000 şubeli bir dünya zincirine dönüşürse? Gece saat 03:00'te bir sunucunun fişi çekildiğinde, içindeki 50 konteyneri kim diğer sunuculara taşıyacak? Trafik 10 katına çıktığında kim anında 40 yeni konteyner açacak? İşte Kubernetes, 1.000 gemiyi ve 100.000 konteyneri tek bir parmak şıklatmasıyla yöneten baş amiraldir!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Docker is great when managing a single coffee stall. But what happens when you run a global chain of 10,000 shops? If a server catches fire at 3 AM, who wakes up to resurrect the 50 crashed containers on another server? Who adds 40 extra containers when traffic surges 1000%? Kubernetes is the supreme admiral orchestrating a fleet of thousands of ships automatically!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Docker tek bir host (tekil sunucu) üzerinde konteyner çalıştırır. Kubernetes (K8s) ise onlarca hatta binlerce fiziksel sunucuyu tek bir devasa soyut süper-bilgisayar gibi birleştirir. Temel yetenekleri: 1) Automated Scheduling (Konteyneri en uygun kaynaklı sunucuya yerleştirme), 2) Self-Healing (Çöken konteynerleri yeniden başlatma, yanıt vermeyen düğümleri tahliye etme), 3) Horizontal Auto-Scaling (CPU/Trafiğe göre otomatik çoğalma), 4) Service Discovery & Load Balancing (Trafiği sağlıklı konteynerlere eşit dağıtma).
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Docker manages containers on a single host. Kubernetes abstracts an entire fleet of physical/virtual machines into a single unified elastic compute fabric. Its core primitives deliver: 1) Automated scheduling & bin packing, 2) Self-healing & node drain automation, 3) Horizontal Pod Autoscaling (HPA), and 4) Automated discovery and Layer 4/7 load balancing.]
    ]
  )
]

#spring_box[
```bash
# Docker ile manuel çile (Sunucu çökerse bittiniz!):
ssh server-01 "docker run -d -p 8080:8080 my-coffee-app:1.0"

# Kubernetes ile bildirici güç (Sunucu patlasa da K8s başka sunucuda anında açar):
kubectl apply -f deployment.yaml
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Kubernetes bir sihirli değnek değildir! Kötü yazılmış, bellek sızdıran veya 'graceful shutdown' desteklemeyen bir Spring Boot uygulamasını K8s'e koyarsanız sadece hatalarınızı daha hızlı çoğaltmış olursunuz.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Kubernetes does not fix broken code. If your Spring Boot app leaks memory or crashes on SIGTERM, K8s will just reboot and crash it faster.]
    ]
  )
]

#takeaways_box((
    ("Docker konteynerleri çalıştırır; Kubernetes binlerce konteyneri orkestre eder.", "Docker runs containers; Kubernetes orchestrates thousands across clusters."),
    ("Kendi kendini iyileştirme (Self-Healing) sayesinde gece mühendis uykusundan uyanmaz.", "Self-healing keeps systems alive without manual midnight engineering interventions."),
    ("Yüzlerce sunucu tek bir dev işlemci ve bellek havuzuna dönüştürülür.", "Aggregates disparate physical nodes into a singular logical compute pool."),
))
