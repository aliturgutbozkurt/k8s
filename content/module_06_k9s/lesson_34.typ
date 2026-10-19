#import "/template.typ": *

#show: doc => setup_book(title: "Ders 34: Terminalden Port-Forwarding ve Pod Restart (`shift-f` ve `ctrl-d`)", doc)

#lesson_header(
  34,
  "Terminalden Port-Forwarding ve Pod Restart (`shift-f` ve `ctrl-d`)",
  "Port-Forwarding and Workload Restarts (`shift-f` and `ctrl-d`)",
  "k9s — Terminalin Matrix Arayüzü",
  "k9s — The Terminal Matrix Cockpit"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      K8s içindeki kapalı bir Spring Boot servisini laptopunuzun tarayıcısında test etmek istiyorsunuz. Normalde karmaşık komutlar gerekir. k9s'te pod'un üzerine gelip `shift-f` tuşuna basarsınız; '8080:8080 tüneli açılsın mı?' diye sorar, enter'a basarsınız ve tarayıcınızda `localhost:8080` anında çalışır! Pod saçmaladı mı? `ctrl-d` tuşuna basın, anında öldürün; Deployment yenisini doğursun!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[You want to test a strictly private internal Spring Boot pod on your laptop browser. Normally this takes annoying commands. In k9s, highlight the pod and press `shift-f`: it prompts 'Port 8080:8080?', press Enter, and your laptop is tunneled to the pod! Pod acting weird? Highlight it, press `ctrl-d` to kill it, and watch the Deployment instantly hatch a clean replacement!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      `shift-f` (Port-Forward): k9s yerel makinenizde bir TCP soketi açar ve K8s SPDY/HTTP2 port-forward API'si üzerinden hedef pod'un portuna tünel kurar. Aktif tünelleri görmek için `:pf` komutu yazılır. `ctrl-d` (Delete): Pod'u siler (`kubectl delete pod`). Eğer pod bir Deployment tarafından yönetiliyorsa, ReplicaSet saniyesinde yeni bir pod yaratır. Bir Deployment'ı kesintisiz yeniden başlatmak içinse Deployment ekranında `r` (Restart) tuşuna basılır.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Pressing `shift-f` invokes the SPDY/HTTP/2 port-forwarding subsystem, tunneling localhost sockets directly to internal pod ports without requiring NodePorts or Ingress. Type `:pf` to manage active forwards. Pressing `ctrl-d` deletes the highlighted resource. For Deployments, pressing `r` initiates a graceful `rollout restart`.]
    ]
  )
]

#spring_box[
```bash
# k9s Tünel ve Yeniden Başlatma Kısayolları:
shift-f   # Port-forward tüneli aç
:pf       # Tüm açık tünelleri listele ve yönet
r         # Deployment üzerinde: Rolling Restart başlat!
ctrl-d    # Seçili Pod'u öldür (Kill / Delete)
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Üretim ortamında (Production) yanlışlıkla bir Pod veya Deployment üzerindeyken `ctrl-d` tuşuna basmamak için k9s'in salt-okunur modunu (`k9s --readonly`) kullanabilirsiniz!
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Prevent accidental deletions in production clusters by launching k9s in read-only mode: `k9s --readonly`.]
    ]
  )
]

#takeaways_box((
    ("`shift-f` ile iç servisler saniyeler içinde localhost'a tünellenir.", "`shift-f` creates frictionless localhost port-forward tunnels in seconds."),
    ("`:pf` menüsü tüm açık tünelleri görsel olarak izlemeyi ve kapatmayı sağlar.", "`:pf` provides centralized monitoring and teardown of active tunnels."),
    ("Deployment üzerindeyken `r` tuşuna basmak kesintisiz rolling restart tetikler.", "Pressing `r` on a Deployment triggers an instant rolling restart."),
))
