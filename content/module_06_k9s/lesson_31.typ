#import "/template.typ": *

#show: doc => setup_book(title: "Ders 31: k9s Nedir? Neden kubectl'den 10 Kat Daha Hızlıdır?", doc)

#lesson_header(
  31,
  "k9s Nedir? Neden kubectl'den 10 Kat Daha Hızlıdır?",
  "Introducing k9s: Why It's 10x Faster Than Raw kubectl",
  "k9s — Terminalin Matrix Arayüzü",
  "k9s — The Terminal Matrix Cockpit"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Sürekli `kubectl get pods -n coffee-shop`, `kubectl describe pod ...`, `kubectl logs ...` yazmak, her kelime için daktiloda harf aramak gibidir. `k9s` ise terminalinizde açılan gerçek zamanlı, renkli bir Matrix kokpitidir! Tek bir tuşa basarak kümeyi izler, hatalı pod'ları kırmızı renkle anında yakalarsınız. Fareye gerek yok, parmaklarınız klavyede dans eder!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Typing `kubectl get pods -n my-ns`, `kubectl describe pod`, and `kubectl logs` 50 times an hour feels like writing code on an antique typewriter. `k9s` is a real-time, terminal-native supersonic fighter jet HUD! Red bars instantly scream at crashed pods; green glows mean peace. Zero mouse required—your fingers fly purely on muscle memory!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      k9s, Go diliyle yazılmış Terminal User Interface (TUI) tabanlı bir Kubernetes yönetim aracıdır. API Server ile kalıcı Watch Stream (gRPC/HTTP2) bağlantısı kurar. Her komutta API'ye yeni baştan sorgu atan `kubectl`'in aksine, k9s kümedeki olayları (events) anlık olarak yerel bellek önbelleğinde günceller. Bu da sorgu gecikmesini sıfıra indirir. `~/.kube/config` dosyanızı otomatik olarak okur.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[k9s is a high-performance terminal UI (TUI) written in Go. Rather than issuing stateless polling queries like `kubectl`, k9s establishes long-lived HTTP/2 Watch streams with the API Server, dynamically synchronizing state directly into its internal cache. It leverages your standard `~/.kube/config`, inheriting existing RBAC tokens and multi-cluster contexts seamlessly.]
    ]
  )
]

#spring_box[
```bash
# macOS Homebrew ile k9s kurulumu:
brew install derailed/k9s/k9s

# k9s'i başlatmak (Tek kelime yeterli!):
k9s

# Belirli bir namespace ile başlatmak:
k9s -n coffee-shop --context eli5-cluster
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      k9s arka planda API Server ile sürekli canlı bağlantı (watch) kurduğu için, binlerce pod'un olduğu devasa kurumsal kümelerde çalıştırırken API Server üzerindeki CPU yükünü artırabilir. Çok büyük kümelerde `--all-namespaces` yerine spesifik namespace ile açmak önerilir.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[In colossal enterprise clusters with tens of thousands of pods, watching all namespaces simultaneously can put strain on the API Server. Open k9s directly in a target namespace (`k9s -n target-ns`).]
    ]
  )
]

#takeaways_box((
    ("k9s, CLI verimliliğini görsel bir arayüz hızında birleştiren terminal aracıdır.", "Combines the speed of the command line with the clarity of a visual dashboard."),
    ("Gerçek zamanlı watch stream sayesinde değişiklikler anında ekranda parlar.", "Displays real-time cluster state transitions instantly without polling."),
    ("Mevcut kubeconfig ve RBAC yetkilerini aynen miras alır.", "Inherits your active kubeconfig credentials, contexts, and RBAC restrictions automatically."),
))
