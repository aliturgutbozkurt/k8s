#import "/template.typ": *

#show: doc => setup_book(title: "Ders 17: DaemonSet ve Job / CronJob: Nöbetçiler ve Gece Vardiyaları", doc)

#lesson_header(
  17,
  "DaemonSet ve Job / CronJob: Nöbetçiler ve Gece Vardiyaları",
  "DaemonSets, Jobs, and CronJobs: Watchmen and Night Shifts",
  "K8s İş Yükleri & Dayanıklılık",
  "K8s Workloads & Self-Healing Resilience"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Üç farklı çalışan tipi: 1) DaemonSet: Her apartman bloğunun giriş kapısındaki sabit güvenlik görevlisidir (Her sunucuda istisnasız 1 adet çalışır; log ve virüs bekçisi). 2) Job: 'Git şu odayı boya ve işin bitince evine git' dediğiniz boyacıdır (Tek seferlik çalışır ve kapanır). 3) CronJob: Her gece saat 03:00'te gelip çöpleri toplayan gece temizlikçisidir.
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Three specialized workers: 1) DaemonSet: The building security guard posted at every single entrance without exception (Runs exactly 1 pod per node for monitoring/logging). 2) Job: The painter hired to paint a wall and leave once finished (Run-to-completion batch). 3) CronJob: The night cleaner who arrives automatically every night at 3:00 AM to sweep the floors.]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      1) DaemonSet: Kümeye yeni bir Worker Node eklendiğinde K8s otomatik olarak o düğümde de 1 adet pod başlatır (FluentBit, Datadog ajanı, Calico node). 2) Job: Spring Boot veritabanı şema göçü (Flyway/Liquibase) gibi bir kez çalışıp başarıyla (exit code 0) tamamlanması gereken işleri yönetir. Başarısız olursa `backoffLimit` kadar tekrar dener. 3) CronJob: Linux crontab sözdizimiyle (`0 3 * * *`) periyodik Job'lar üretir.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[1) DaemonSet guarantees that every eligible node runs a copy of a pod, auto-scaling as nodes join or leave (ideal for log collectors and CNI agents). 2) Job creates pods that run until a specified number of successful completions, managing retry backoffs for DB schema migrations. 3) CronJob schedules recurring batch jobs using standard 5-part crontab syntax.]
    ]
  )
]

#spring_box[
```yaml
# flyway-migration-job.yaml (Spring Boot DB Göçü)
apiVersion: batch/v1
kind: Job
metadata:
  name: coffee-db-migration
spec:
  backoffLimit: 3 # En fazla 3 kez tekrar dene
  template:
    spec:
      restartPolicy: OnFailure
      containers:
        - name: db-migrator
          image: ghcr.io/eli5-k8s/spring-boot-k8s-eli5:1.0.0
          command: ["java", "-jar", "app.jar", "--spring.flyway.migrate=true"]
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Job şablonunda `restartPolicy` varsayılan olarak 'Always' OLAMAZ! Bir Job ya 'OnFailure' ya da 'Never' olmalıdır, aksi takdirde biten iş sonsuza dek yeniden başlar.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Job specs cannot use `restartPolicy: Always`! It must be `OnFailure` or `Never`, otherwise completed tasks loop infinitely.]
    ]
  )
]

#takeaways_box((
    ("DaemonSet her sunucuda istisnasız 1 kopya çalıştırarak altyapıyı izler.", "DaemonSets ensure uniform node coverage for infrastructure monitoring and logs."),
    ("Job'lar tek seferlik veritabanı göçleri ve veri işleme için idealdir.", "Jobs run tasks to completion with built-in retry policies."),
    ("CronJob zamanlanmış periyodik rapor ve temizlik görevlerini otomatikleştirir.", "CronJobs reliably automate scheduled periodic batch workloads."),
))
