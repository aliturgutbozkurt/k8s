#import "/template.typ": *

#show: doc => setup_book(title: "Ders 32: k9s Kısayolları ve Filtreleme: Işınlanma Sanatı", doc)

#lesson_header(
  32,
  "k9s Kısayolları ve Filtreleme: Işınlanma Sanatı",
  "k9s Navigation & Filtering: The Art of Instant Teleportation",
  "k9s — Terminalin Matrix Arayüzü",
  "k9s — The Terminal Matrix Cockpit"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      k9s'te gezinmek bir büyü gibidir! `:` tuşuna basıp `po` yazarsanız pod'lar listelenir, `deploy` yazarsanız deployment'lar açılır, `ns` yazarsanız tüm ortamlar önünüze dökülür. Arama yapmak için sadece `/` tuşuna basıp `coffee` yazmanız yeterlidir; aradığınız pod saniyesinde karşınızda!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Navigating k9s feels like instant teleportation! Press `:` and type `po` for pods, `deploy` for deployments, `svc` for services, `ns` for namespaces. To search, press `/`, type `coffee`, and press enter. You've filtered down 5,000 pods to your exact Spring Boot microservice in 0.5 seconds!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      k9s Vim benzeri tuş kombinasyonlarıyla (Keybindings) çalışır. Temel komutlar: `:` (Komut moduna geçer; K8s kısayol adlarını destekler: `:po`, `:svc`, `:ing`, `:cm`, `:sec`, `:cr`), `/` (Filtreleme modu; regex aramayı destekler), `ctrl-a` (Tüm namespace'leri tek ekranda gösterir), `0` (Sadece varsayılan namespace), `esc` (Bir önceki ekrana veya filtreyi temizlemeye yarar). Ok tuşları veya `j`/`k` ile listelerde gezinilir.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[k9s embraces Vim navigation paradigms. Primary bindings: `:` activates command mode (accepting shortnames like `:po`, `:svc`, `:deploy`, `:ing`, `:cm`), `/` activates regex-capable text filtering, `ctrl-a` aggregates all namespaces, `esc` cancels filters or navigates backward. Standard `j`/`k` or arrow keys move row cursors effortlessly.]
    ]
  )
]

#spring_box[
```bash
# En Çok Kullanılan k9s Komut Modu Kısayolları:
:po        # Pod listesi
:deploy    # Deployment listesi
:svc       # Service listesi
:ing       # Ingress listesi
:ns        # Namespace seçici
:nodes     # Küme düğümleri ve kaynak durumları
:context   # K8s kümeleri arasında geçiş yap!
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Bazen filtreleme yapıp (`/coffee`) aramayı açık unuttuğunuzda ekrandaki diğer pod'lar kaybolmuş gibi gelebilir. Panik yapmayın, `esc` tuşuna basarak filtreyi sıfırlayın!
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[If resources seem to have vanished, check if a filter is active! Press `esc` twice to clear the `/` search filter and reveal all workloads.]
    ]
  )
]

#takeaways_box((
    ("`:` tuşu ile herhangi bir K8s kaynağına 1 saniyede ulaşılır.", "The `:` key provides instant access to any standard or custom K8s resource type."),
    ("`/` tuşu ile canlı filtreleme yapılarak hedef pod saniyeler içinde bulunur.", "The `/` key enables blazing fast real-time search across massive pod fleets."),
    ("`ctrl-a` tüm namespace'leri tek pencerede toplayarak genel bakış sunar.", "`ctrl-a` expands your viewport across all namespaces simultaneously."),
))
