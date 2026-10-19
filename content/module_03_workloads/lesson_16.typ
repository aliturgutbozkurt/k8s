#import "/template.typ": *

#show: doc => setup_book(title: "Ders 16: StatefulSet: Veritabanları Neden Özel İlgi İster?", doc)

#lesson_header(
  16,
  "StatefulSet: Veritabanları Neden Özel İlgi İster?",
  "StatefulSets: Why Databases Demand Special Treatment",
  "K8s İş Yükleri & Dayanıklılık",
  "K8s Workloads & Self-Healing Resilience"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Koyun sürüsü (Deployment) vs Safkan yarış atları (StatefulSet). Koyunların adı yoktur; hepsi birbirinin aynıdır, biri kaybolsa yerine rastgele bir koyun koyarsınız. Ama yarış atlarının adı (`postgres-0`, `postgres-1`), sabit bir ahırı (özel kalıcı diski) ve hiyerarşisi (1. at liderdir, diğerleri takipçidir) vardır! Veritabanları koyun değil, yarış atıdır!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Cattle (Deployments) vs Thoroughbred Racehorses (StatefulSets). Cattle have no individual names; they are completely interchangeable. Racehorses have distinct names (`postgres-0`, `postgres-1`), assigned personal stables (dedicated permanent storage), and strict hierarchies (Leader vs Replica). Databases are pedigreed racehorses!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Deployment pod'ları rastgele isimler alır (`app-7d6f5-k9x2`) ve çöktüklerinde yeni bir rastgele isimle doğarlar. StatefulSet ise şunları garanti eder: 1) Öngörülebilir ve sabit isimler (`db-0`, `db-1`, `db-2`), 2) Sıralı başlatma ve kapatma (önce `db-0` hazır olur, sonra `db-1` başlar), 3) `volumeClaimTemplates` sayesinde her pod'a çöktüğünde bile peşinden gelen özel bir PersistentVolume tahsis edilir, 4) Headless Service ile her pod doğrudan kendi DNS adresiyle çağrılabilir.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[StatefulSets provide 4 crucial guarantees for stateful systems: 1) Deterministic, stable network identifiers (`stateful-0`, `stateful-1`), 2) Ordered, graceful deployment and scaling, 3) Dedicated persistent storage per replica via `volumeClaimTemplates`, 4) Headless Service integration providing stable per-pod DNS records for master-replica topology negotiation.]
    ]
  )
]

#spring_box[
```yaml
# statefulset-postgres.yaml (Özet)
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  serviceName: "postgres-headless"
  replicas: 2
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:16-alpine
  volumeClaimTemplates:
    - metadata:
        name: db-storage
      spec:
        accessModes: [ "ReadWriteOnce" ]
        resources:
          requests:
            storage: 10Gi
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Bir StatefulSet'i sildiğinizde (`kubectl delete statefulset`), K8s veri kaybını önlemek için bağlı olan kalıcı diskleri (PVC) OTOMATİK OLARAK SİLMEZ! Diskleri elle silmeniz gerekir.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Deleting a StatefulSet does NOT delete its associated PVC storage claims by design! Kubernetes protects database disks from accidental deletion.]
    ]
  )
]

#takeaways_box((
    ("StatefulSet pod'ları sabit isim (`pod-0`, `pod-1`) ve sabit DNS alır.", "StatefulSet replicas possess persistent network hostnames and dedicated DNS."),
    ("`volumeClaimTemplates` her pod kopyasına özel kalıcı disk bağlar.", "Each replica obtains its own dedicated PersistentVolume via templates."),
    ("Veritabanı, Kafka ve Elasticsearch gibi durum tutan servisler için zorunludur.", "Essential for stateful clustered systems like PostgreSQL, Kafka, and Redis."),
))
