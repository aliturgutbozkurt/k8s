#import "/template.typ": *

#show: doc => setup_book(title: "Ders 56: Spring Boot CI Pipeline: Maven Test, Build ve Kalite Kontrolü", doc)

#lesson_header(
  56,
  "Spring Boot CI Pipeline: Maven Test, Build ve Kalite Kontrolü",
  "Spring Boot CI Pipeline: Maven Test, Build & Quality Gates",
  "GitHub Actions CI/CD & Büyük Mezuniyet Senaryosu",
  "GitHub Actions CI/CD & The Grand Enterprise Finale"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Hatalı bir kodun üretim hattına geçmesini engelleyen acımasız kapı bekçisi! Yazılımcı gece yarısı dalgınlıkla bir hataya sebep olduysa veya birim testleri (Unit Tests) bozduysa, GitHub Actions o kodu anında durdurur: Kırmızı çarpı işaretini basar, yöneticilere haber verir ve bozuk kodun Docker imajı olmasına ASLA izin vermez!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[The unyielding quality gatekeeper! If a sleepy engineer accidentally introduces a regression or breaks a unit test, GitHub Actions slams the brakes on the assembly line: it raises a red flag, alerts the engineering team, and strictly prevents the broken build from ever producing a container image!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Etkili bir Java CI adımı şunları içerir: 1) `actions/setup-java@v4`: Eclipse Temurin JDK 21 kurulumu ve `cache: 'maven'` ile `~/.m2` deposunun önbelleğe alınması (derleme süresini 4 dakikadan 30 saniyeye düşürür). 2) `mvn clean test`: Tüm JUnit 5 ve Spring Boot MockMvc testlerini çalıştırır. 3) Test raporlarının ve kod kapsama oranlarının (JaCoCo) üretilmesi. 4) `mvn package -DskipTests`: Üretim JAR dosyasının derlenmesi.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[A resilient Spring Boot CI pipeline includes: 1) `setup-java` configuring JDK 21 with automatic Maven dependency caching (shrinking build times from minutes to seconds). 2) `mvn clean test` executing JUnit 5 unit and integration test suites. 3) JaCoCo test coverage enforcement. 4) Packaging the final layered production executable JAR via Spring Boot Maven plugin.]
    ]
  )
]

#spring_box[
```bash
# Maven CI Job Bloğu:
jobs:
  test-and-package:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: JDK 21 Temurin Kur ve Maven Önbellekle
        uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'
          cache: maven

      - name: Birim ve Entegrasyon Testlerini Çalıştır
        run: mvn clean test

      - name: Üretim JAR Paketini Derle
        run: mvn package -DskipTests
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Maven önbellekleme (`cache: maven`) yapmazsanız, GitHub Actions her commit'te tüm Spring Boot kütüphanelerini internetten sıfırdan indirir; bu da dakikalarca zaman kaybına ve GitHub Actions dakikalarınızın hızla tükenmesine yol açar.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Omitting Maven dependency caching forces the runner to re-download hundreds of megabytes of dependencies on every push, wasting pipeline minutes and developer time.]
    ]
  )
]

#takeaways_box((
    ("Otomatik testler bozuk kodların müşterilere ulaşmasını %100 engeller.", "Automated CI testing guarantees that failing code cannot slip unnoticed into production."),
    ("Maven önbellekleme derleme sürelerini kat kat hızlandırır.", "Maven dependency caching slashes build times from minutes down to seconds."),
    ("Test raporları her Pull Request üzerinde şeffaf biçimde incelenebilir.", "Test outcomes are surfaced directly on GitHub Pull Requests for peer review."),
))
