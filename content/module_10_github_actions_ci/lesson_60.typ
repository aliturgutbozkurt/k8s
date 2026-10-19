#import "/template.typ": *

#show: doc => setup_book(title: "Ders 60: BÜYÜK MEZUNİYET FİNALİ: Uçtan Uca Kurumsal Spring Boot Akışı!", doc)

#lesson_header(
  60,
  "BÜYÜK MEZUNİYET FİNALİ: Uçtan Uca Kurumsal Spring Boot Akışı!",
  "THE GRAND FINALE: Full End-to-End Enterprise Flow",
  "GitHub Actions CI/CD & Büyük Mezuniyet Senaryosu",
  "GitHub Actions CI/CD & The Grand Enterprise Finale"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Ve işte büyük orkestranın tüm enstrümanları sahnede! 60 ders boyunca öğrendiğimiz her parça tek bir kusursuz senfoniye dönüşüyor: Bilgisayarınızda Java Spring Boot kodundaki kahve mesajını değiştirip `git push` yapıyorsunuz. GitHub Actions uyanıyor, Maven ile test edip derliyor, Trivy ile tarıyor, Docker imajını GHCR'ye basıyor, GitOps reposunu güncelliyor, kümedeki Flux değişikliği çekiyor, OpenShift rotası trafiği yönlendiriyor ve siz k9s ekranında pod'ların yeşile dönmesini canlı izliyorsunuz! Tebrikler, artık bir Cloud-Native şampiyonusunuz!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[AND HERE IS THE GRAND SYMPHONY! All 60 lessons unite into one breathtaking enterprise performance: You edit a single line of Java in Spring Boot and type `git push`. GitHub Actions awakens, runs Maven tests, scans with Trivy, pushes the OCI container to GHCR, commits the release SHA to the GitOps fleet repo, Flux pulls the change in-cluster, OpenShift routes live traffic, and you lean back watching the pods glow neon green in k9s! Congratulations: You are officially a Cloud-Native Master!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Uçtan uca kurumsal yaşam döngüsünün tam özeti: 1) Geliştirici Spring Boot kodunu commitleyip push eder. 2) GitHub Actions CI: `mvn test` -> Docker layered build -> Trivy security scan -> GHCR push. 3) Promotion: Actions, GitOps filosundaki `deployment.yaml` imaj etiketini günceller. 4) Flux GitOps: Değişikliği 30 saniye içinde algılar ve K8s API'sine uygular. 5) K8s/OpenShift: RollingUpdate ile yeni pod'ları ayağa kaldırır, Actuator Startup/Readiness problarını bekler, sıfır kesintiyle trafiği yeni sürüme aktarır. 6) k9s & Prometheus: Sistem mühendisi canlıda logları, CPU/RAM'i ve metrikleri izler.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[The definitive Cloud-Native lifecycle synthesis: 1) Dev pushes Java code. 2) GitHub Actions: Maven validation -> Layered Docker build -> Trivy CVE scan -> Push to GHCR. 3) GitOps Promotion: Automation updates fleet manifest with the Git SHA. 4) Flux Reconciliation: Polls Git, detects divergence, applies to K8s API. 5) Orchestration: Zero-downtime RollingUpdate validates Spring Boot Actuator probes before routing traffic. 6) Observability: Real-time verification via k9s HUD and Prometheus telemetry.]
    ]
  )
]

#spring_box[
```bash
# 🚀 BÜYÜK MEZUNİYET KONTROL LİSTESİ:
# 1. Java Kodu: Spring Boot 3.x REST API + Actuator Probes (/actuator/health)
# 2. Docker: Multi-stage build + Layered JAR + Non-Root User (UID 10001)
# 3. K8s: Deployment + ClusterIP + Ingress + HPA + Requests/Limits
# 4. OpenShift: Security Context Constraints (SCC) + Edge Route
# 5. Operators: SpringBootApp CRD + Java Operator SDK Controller
# 6. k9s: Anlık canlı log takibi ('l'), tünel ('shift-f'), kaynak izleme
# 7. FluxCD: GitRepository + Kustomization + ImageUpdateAutomation
# 8. GitHub Actions: Maven Test -> Trivy Scan -> GHCR -> GitOps Auto-Commit

# Tek Komutla Tüm Dünyayı Canlıda İzle:
k9s -n coffee-shop
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Bulut bilişim yolculuğu burada bitmiyor, yeni başlıyor! Gerçek bir mühendis öğrendiği bu 8 teknolojiyi sürekli pratik yaparak, kendi projelerini konteynerize edip GitOps ile yöneterek refleks haline getirir.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[The Cloud-Native journey doesn't end here; it begins! Cement this mastery by building, containerizing, breaking, and healing your own microservices continuously.]
    ]
  )
]

#takeaways_box((
    ("60 derslik tam eğitim: Docker'dan K8s'e, OpenShift'ten Flux ve GitHub Actions'a.", "60 lessons spanning Docker, Kubernetes, OpenShift, k9s, Operators, Flux, and CI/CD."),
    ("Tüm akış endüstri standardı Java Spring Boot mikroservis mimarisiyle uygulandı.", "Anchored throughout by industry-standard Java Spring Boot production implementations."),
    ("Artık kurumsal bulut-yerel mimarileri baştan sona tasarlama ve yönetme yetkisine sahipsiniz!", "You are fully equipped to design, deploy, and automate enterprise cloud platforms!"),
))
