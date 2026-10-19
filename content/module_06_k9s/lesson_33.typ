#import "/template.typ": *

#show: doc => setup_book(title: "Ders 33: Canlı Log İnceleme, Arama ve Pod İçine Giriş (`s` ve `l`)", doc)

#lesson_header(
  33,
  "Canlı Log İnceleme, Arama ve Pod İçine Giriş (`s` ve `l`)",
  "Live Log Tailing, Searching & One-Key Shelling (`s` and `l`)",
  "k9s — Terminalin Matrix Arayüzü",
  "k9s — The Terminal Matrix Cockpit"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Gece saat 02:00'de üretimde bir hata çıktı! Spring Boot pod'unuzun loglarına bakmak için uzun uzun komut yazmazsınız. Pod'un üzerine gelin ve `l` tuşuna basın: Renkli loglar anında şelale gibi akar! Hata mı arıyorsunuz? `/Exception` yazın, bulsun. Pod'un içine girip dosyaları kontrol etmek mi istiyorsunuz? `s` tuşuna basın; anında pod'un içindeki terminaldesiniz!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Midnight production outage! You don't fumble with lengthy CLI commands. Move the cursor over your Spring Boot pod and press `l`: colorized log streams cascade down your screen! Need to locate a bug? Press `/Exception` to jump straight to the stack trace. Need to verify environment configs? Press `s`: boom, you have an interactive shell inside the container!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      `l` (Logs) tuşu: K8s API'si üzerinden streaming log soketi açar. `0` tuşuyla logları baştan (head) sarabilir, `w` ile satır kaydırmayı (wrap) açıp kapatabilir, `t` ile zaman damgalarını (timestamps) ekleyebilirsiniz. `s` (Shell) tuşu: Pod içinde sırasıyla `bash`, `sh`, `/bin/sh` arar ve interaktif TTY oturumu başlatır (`kubectl exec -it`). Non-root çalışan konteynerlerde de sorunsuz çalışır.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Pressing `l` (Logs) opens a streaming WebSocket log channel with colorized ANSI output, log wrapping toggle (`w`), and timestamp prefixes (`t`). Pressing `s` (Shell) launches an interactive TTY execution session into the container (`kubectl exec -it`), iteratively attempting `/bin/bash`, `/bin/sh`, and `/bin/ash` under the container's configured user identity.]
    ]
  )
]

#spring_box[
```bash
# k9s Log ve Shell Kısayol Tuşları:
l         # Seçili pod'un canlı loglarını aç
p         # Önceki çöken pod'un loglarını gör (Previous Crashed Logs!)
s         # Pod içine terminal (Shell) aç
d         # Describe pod detaylarını aç (Event'leri görmek için!)
e         # Pod veya Deployment YAML'ını canlıda düzenle (Edit)
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Eğer pod çökmüş ve `CrashLoopBackOff` durumundaysa, `l` tuşuna bastığınızda boş ekran görebilirsiniz. Çöken pod'un son nefesindeki hatayı görmek için mutlaka `p` (Previous Logs) tuşuna basmalısınız!
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[If a pod is caught in `CrashLoopBackOff`, normal logs might be empty! Press `p` to view PREVIOUS logs and read the fatal exception that killed the container.]
    ]
  )
]

#takeaways_box((
    ("`l` tuşu pod loglarını anlık akış olarak ekrana getirir.", "`l` streams live application logs with zero configuration."),
    ("`p` tuşu az önce çöken konteynerin hata günlüğünü (previous log) yakalar.", "`p` inspects the historical logs of terminated, crashed container instances."),
    ("`s` tuşu tek dokunuşla pod'un içine SSH benzeri güvenli shell bağlantısı kurar.", "`s` instantly opens an interactive shell session into the running container."),
))
