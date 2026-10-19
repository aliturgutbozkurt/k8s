#import "/template.typ": *

#show: doc => setup_book(title: "Ders 45: Dünyayı Yöneten Hazır Operatörler: Prometheus, Postgres, Strimzi", doc)

#lesson_header(
  45,
  "Dünyayı Yöneten Hazır Operatörler: Prometheus, Postgres, Strimzi",
  "Battle-Tested Operators: Prometheus, CloudNativePG, and Strimzi",
  "Kubernetes Operators — Kendi Akıllı Robotunu Kodla",
  "Kubernetes Operators — Build Your Own Robot SRE"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Tekerleği baştan icat etmeyin! Dünyanın en iyi mühendisleri zaten en zor işler için mükemmel robotlar yazdı: 1) Prometheus Operator: Kümedeki tüm pod'ları otomatik keşfedip grafiklerini çizer. 2) CloudNativePG: PostgreSQL veritabanını tek satırla kurar, saniyede bir yedek alır, ana sunucu çökerse 3 saniyede yedeği devreye sokar. 3) Strimzi: Gezegenin en karmaşık sistemi olan Apache Kafka'yı çocuk oyuncağına çevirir!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Don't reinvent the wheel! The world's top infrastructure architects have already coded elite robots for the hardest problems: 1) Prometheus Operator: Dynamically sniffs out microservices and plots metrics dashboards. 2) CloudNativePG: Deploys HA PostgreSQL, takes automated point-in-time backups to S3, and fails over in 3 seconds flat. 3) Strimzi: Tames Apache Kafka clusters effortlessly!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Bu operatörler üretimde altın standarttır: 1) CloudNativePG (`postgresql.cnpg.io`): PostgreSQL streaming replication, PgBouncer bağlantı havuzu, WAL arşivleme ve S3/MinIO yedeklemelerini CRD'lerle tam otomatik yürütür. 2) Prometheus Operator (`monitoring.coreos.com`): `ServiceMonitor` CRD'si ile Spring Boot Actuator `/actuator/prometheus` uç noktasını otomatik olarak Prometheus hedeflerine ekler. 3) Strimzi (`kafka.strimzi.io`): Kafka broker ve Zookeeper/KRaft topolojisini yönetir.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Production staples: 1) CloudNativePG manages PostgreSQL physical streaming replication, seamless zero-downtime rolling upgrades, and automated barman-based WAL archiving to S3. 2) Prometheus Operator utilizes `ServiceMonitor` CRDs to auto-discover Spring Boot `/actuator/prometheus` endpoints. 3) Strimzi manages Kafka brokers, topics, and users purely via declarative YAML.]
    ]
  )
]

#spring_box[
```yaml
# servicemonitor-spring.yaml (Prometheus için Spring Boot İzleme Kuralı)
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: spring-boot-monitor
  namespace: coffee-shop
spec:
  selector:
    matchLabels:
      app: coffee-app
  endpoints:
    - port: http
      path: /actuator/prometheus
      interval: 15s # Her 15 saniyede bir JVM metriklerini topla!
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Operatör kurarken CRD'lerin küme geneli (Cluster-wide) yetki gerektirdiğini unutmayın! Standart bir namespace geliştiricisi tek başına CRD kuramaz; cluster-admin yetkisi gerekir.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Installing operators requires cluster-admin privileges because CRD installation is a cluster-scoped operation affecting all tenants.]
    ]
  )
]

#takeaways_box((
    ("Popüler açık kaynak operatörler yüzlerce saatlik operasyonel emeği kurtarır.", "Battle-tested open-source operators save hundreds of hours of maintenance toil."),
    ("`ServiceMonitor` nesnesi Spring Boot metriklerini otomatik Prometheus'a bağlar.", "ServiceMonitors auto-scrape Spring Boot Micrometer metrics without static configs."),
    ("Veritabanı felaket senaryoları insan hatası olmadan otomatik çözülür.", "Automated database failover eliminates catastrophic human mistakes during outages."),
))
