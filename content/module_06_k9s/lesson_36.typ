#import "/template.typ": *

#show: doc => setup_book(title: "Ders 36: k9s Eklentileri ve Özel Kısayollar (Custom Plugins)", doc)

#lesson_header(
  36,
  "k9s Eklentileri ve Özel Kısayollar (Custom Plugins)",
  "k9s Custom Plugins & Supercharged Productivity Hotkeys",
  "k9s — Terminalin Matrix Arayüzü",
  "k9s — The Terminal Matrix Cockpit"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Uçağınızın kokpitine kendi özel kırmızı butonlarınızı eklemek! Örneğin tek bir tuşa (`ctrl-j`) basarak Spring Boot pod'unun içinden anında 'Java Thread Dump' almak veya log seviyesini tek tuşla `DEBUG` moduna geçirmek istiyorsunuz. k9s Plugins mekanizmasıyla istediğiniz özel komutu bir tuşa bağlayabilirsiniz!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Adding custom red fire-buttons to your fighter jet cockpit! What if you could press `ctrl-j` on any pod to immediately dump JVM thread traces, or press `ctrl-b` to toggle Spring Boot log levels to `DEBUG`? k9s Plugins allow you to bind any custom shell or kubectl command to custom hotkeys!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      k9s eklentileri `~/.config/k9s/plugins.yaml` dosyasında tanımlanır. Bir eklenti şunları içerir: 1) `shortCut` (Tetikleyici tuş; örn: `shift-t`), 2) `scopes` (Hangi kaynakta geçerli; örn: `po`, `deploy`), 3) `command` ve `args` (Çalıştırılacak script). k9s çalışma anında `$NAMESPACE`, `$NAME`, `$POD`, `$CONTAINER` gibi ortam değişkenlerini komuta otomatik aktarır.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[k9s plugins are defined declaratively in `~/.config/k9s/plugins.yaml`. Each plugin specifies a `shortCut`, target `scopes` (e.g. `pods`), and an executable `command` with arguments. k9s dynamically interpolates contextual variables like `$NAMESPACE`, `$NAME`, and `$CONTAINER` at runtime.]
    ]
  )
]

#spring_box[
```bash
# ~/.config/k9s/plugins.yaml Örneği:
plugin:
  # Spring Boot Pod'undan Tek Tuşla Java Thread Dump Al!
  jvm-thread-dump:
    shortCut: Shift-T
    description: JVM Thread Dump
    scopes:
      - pods
    command: kubectl
    background: false
    confirm: false
    args:
      - exec
      - -it
      - -n
      - $NAMESPACE
      - $NAME
      - --
      - jcmd
      - "1"
      - Thread.print
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Eklentiler yerel bilgisayarınızdaki araçları (jcmd, curl, jq) çağırır. Eklentinin çalışabilmesi için ilgili aracın bilgisayarınızda veya konteyner içinde yüklü olması gerekir.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Custom plugins invoke local or in-pod CLI binaries. Ensure required binaries (like `jcmd` or `jq`) exist before triggering custom hotkeys.]
    ]
  )
]

#takeaways_box((
    ("k9s eklentileri günlük rutin bakım görevlerini tek tuşa indirir.", "Custom plugins compress repetitive operational routines into single keypresses."),
    ("Çalışma anı değişkenleri ($NAMESPACE, $NAME) dinamik komut yönetimini sağlar.", "Runtime context variables enable dynamic, context-aware command executions."),
    ("Takım standartları için ortak `plugins.yaml` dosyaları paylaşılabilir.", "Teams can standardize and share unified `plugins.yaml` across engineering orgs."),
))
