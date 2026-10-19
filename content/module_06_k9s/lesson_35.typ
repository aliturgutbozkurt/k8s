#import "/template.typ": *

#show: doc => setup_book(title: "Ders 35: Kaynak İzleme: Renkli CPU ve Bellek Göstergeleriyle Darboğaz Avı", doc)

#lesson_header(
  35,
  "Kaynak İzleme: Renkli CPU ve Bellek Göstergeleriyle Darboğaz Avı",
  "Resource Monitoring: Visual CPU & Memory Bottleneck Hunting",
  "k9s — Terminalin Matrix Arayüzü",
  "k9s — The Terminal Matrix Cockpit"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Sisteminiz neden yavaşladı? Hangi Spring Boot pod'u sunucunun tüm enerjisini emiyor? k9s pod listesinde CPU ve Bellek sütunlarını yeşil, sarı ve kırmızı renkli barlarla gösterir. Bir pod %95 belleğe yaklaştığında bar kıpkırmızı parlar: 'Beni kurtarın, birazdan OOMKilled olacağım!' diye bağırır. Dedektif gibi darboğazı yakalarsınız!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Why is the API suddenly sluggish? Which rogue Spring Boot pod is devouring server energy? k9s displays intuitive percentage bars next to CPU and Memory columns. When a pod reaches 95% RAM utilization, its gauge turns violently red, screaming: 'Help, I'm about to get OOMKilled!' You catch performance leaks like a master detective!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      k9s, Metrics Server API (`metrics.k8s.io`) ile entegre çalışır. Kaynak kullanımını iki farklı referansa göre gösterir: 1) `%REQUEST` (Pod'un rezerve ettiği taban kaynak kullanım yüzdesi), 2) `%LIMIT` (Pod'un tavan sınırına olan uzaklığı). Eğer bir Java pod'unun bellek barı sürekli artıyor ve hiç azalmıyorsa bu bir JVM Memory Leak (bellek sızıntısı) işaretidir. Node ekranında (`:nodes`) sunucu bazlı darboğazlar da anında izlenir.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[k9s parses metrics directly from `metrics.k8s.io`. It dynamically evaluates utilization against both `%REQUEST` (guaranteed reservation) and `%LIMIT` (hard ceiling). If a Java pod's memory gauge climbs monotonically without garbage collection dips, you are observing a live JVM memory leak before OOMKilled evictions occur.]
    ]
  )
]

#spring_box[
```bash
# k9s Ekranında CPU ve Bellek Göstergeleri:
# NAME             READY  STATUS   RESTARTS  CPU%  MEM%  CPU/REQ  MEM/REQ
# coffee-app-7b8c  1/1    Running  0          12%   84%   120m     430Mi
# (MEM% barı sarıya/kırmızıya dönüyorsa dikkat!)
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Eğer CPU ve MEM sütunlarında `n/a` veya boşluk görüyorsanız, kümenizde `metrics-server` kurulu değildir! Minikube'da `minikube addons enable metrics-server` komutuyla aktif edebilirsiniz.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[If CPU and MEM columns display `n/a`, your cluster lacks `metrics-server`! Enable it locally via `minikube addons enable metrics-server`.]
    ]
  )
]

#takeaways_box((
    ("Renkli göstergeler sayesinde bellek darboğazları kriz çıkmadan fark edilir.", "Color-coded utilization bars spot resource exhaustion before crashes occur."),
    ("JVM bellek sızıntıları (memory leaks) canlıda grafiksel olarak yakalanır.", "JVM heap leaks are easily identified by observing continuous memory increases."),
    ("`:nodes` komutuyla sunucuların genel doluluk oranları denetlenir.", "The `:nodes` view shows host capacity and identifies overloaded hardware."),
))
