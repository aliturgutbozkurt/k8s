# -*- coding: utf-8 -*-
"""
Module 10: GitHub Actions CI/CD & Büyük Mezuniyet Senaryosu (Lessons 55-60)
"""

MODULE = {
    "id": 10,
    "dir": "module_10_github_actions_ci",
    "title_tr": "GitHub Actions CI/CD & Büyük Mezuniyet Senaryosu",
    "title_en": "GitHub Actions CI/CD & The Grand Enterprise Finale",
    "desc_tr": "Uçtan uca otomasyon fabrikası: GitHub Actions iş akışları, Spring Boot Maven testleri, Trivy güvenlik taramaları, GitOps köprüsü ve büyük mezuniyet projesi.",
    "desc_en": "The end-to-end automation factory: GitHub Actions workflows, Spring Boot Maven builds, Trivy CVE scanning, bridging CI to GitOps, and the grand live deployment finale.",
    "lessons": [
        {
            "num": 55,
            "title_tr": "GitHub Actions Temelleri: Workflows, Jobs, Steps ve Runners",
            "title_en": "GitHub Actions Fundamentals: Workflows, Jobs, Steps, and Runners",
            "eli5_tr": "Kodunuzu GitHub'a `git push` yaptığınız anda harekete geçen görünmez bir fabrika düşünün! 1) Workflow: Fabrikanın üretim planıdır (`.github/workflows/ci.yaml`). 2) Trigger (Tetikleyici): Zilin çalmasıdır ('Main branch'e kod geldi!'). 3) Jobs (İşler): Fabrikanın farklı departmanlarıdır ('Biri test yapsın, diğeri Docker derlesin'). 4) Runners: Bu işleri yapan bulut bilgisayarlarıdır!",
            "eli5_en": "Imagine an invisible, robotic smart factory that fires up the millisecond you run `git push`! 1) Workflow: The factory blueprint (`.github/workflows/ci.yaml`). 2) Trigger (Event): The starting bell ringing ('Code pushed to main!'). 3) Jobs: Distinct assembly lines ('Line 1 tests Java, Line 2 bakes the container'). 4) Runners: The virtual machines in the cloud executing the steps!",
            "deep_tr": "GitHub Actions mimarisinin yapı taşları: 1) `Events`: İş akışını başlatan olaylar (`push`, `pull_request`, `schedule`, `workflow_dispatch`). 2) `Jobs`: Varsayılan olarak paralel çalışan bağımsız görev bloklarıdır (`needs: [build]` ile sıralı bağımlılık kurulur). 3) `Steps`: Sırayla çalıştırılan tekil kabuk komutları (`run`) veya hazır topluluk eylemleri (`uses: actions/checkout@v4`). 4) `Runners`: Ubuntu, macOS veya Windows barındıran geçici sanal makinelerdir.",
            "deep_en": "The core taxonomy of GitHub Actions: 1) `Events` trigger execution (`push`, `pull_request`, webhooks). 2) `Jobs` run concurrently by default on isolated compute runners unless sequenced via `needs: [jobA]`. 3) `Steps` execute sequentially inside a job environment as shell scripts (`run`) or composite action modules (`uses`). 4) `Runners` are ephemeral hosted virtual machines or self-hosted servers.",
            "spring_code": """# .github/workflows/hello-ci.yaml
name: First Spring Boot Workflow
on:
  push:
    branches: [ "main" ]

jobs:
  say-hello:
    runs-on: ubuntu-latest
    steps:
      - name: Kodu Klonla
        uses: actions/checkout@v4

      - name: Terminale Yazdır
        run: |
          echo "🚀 Java Spring Boot CI Pipeline Başlatıldı!"
          echo "Commit SHA: ${{ github.sha }}" """,
            "warning_tr": "Bir iş akışındaki adımlar (steps) aynı sanal makinede ardışık çalışır ve dosya sistemini paylaşır. Ancak farklı 'Job'lar farklı sanal makinelerde çalıştığı için aralarında dosya paylaşımı yapmak istiyorsanız `actions/upload-artifact` kullanmalısınız!",
            "warning_en": "Steps within a job share the runner filesystem; distinct Jobs run on separate virtual machines! Pass compiled artifacts between jobs using `upload-artifact` and `download-artifact`.",
            "takeaways": [
                ("GitHub Actions harici CI sunucusu (Jenkins) kurma ihtiyacını ortadan kaldırır.", "Eliminates the maintenance overhead of managing dedicated external CI/CD servers."),
                ("YAML tabanlı bildirici sözdizimi doğrudan projenin Git reposunda saklanır.", "Declarative workflow definitions live directly inside your project repository."),
                ("Geniş GitHub Marketplace ekosistemi hazır otomasyon eylemleri sunar.", "Leverages a vast marketplace of battle-tested open-source actions for rapid setup.")
            ]
        },
        {
            "num": 56,
            "title_tr": "Spring Boot CI Pipeline: Maven Test, Build ve Kalite Kontrolü",
            "title_en": "Spring Boot CI Pipeline: Maven Test, Build & Quality Gates",
            "eli5_tr": "Hatalı bir kodun üretim hattına geçmesini engelleyen acımasız kapı bekçisi! Yazılımcı gece yarısı dalgınlıkla bir hataya sebep olduysa veya birim testleri (Unit Tests) bozduysa, GitHub Actions o kodu anında durdurur: Kırmızı çarpı işaretini basar, yöneticilere haber verir ve bozuk kodun Docker imajı olmasına ASLA izin vermez!",
            "eli5_en": "The unyielding quality gatekeeper! If a sleepy engineer accidentally introduces a regression or breaks a unit test, GitHub Actions slams the brakes on the assembly line: it raises a red flag, alerts the engineering team, and strictly prevents the broken build from ever producing a container image!",
            "deep_tr": "Etkili bir Java CI adımı şunları içerir: 1) `actions/setup-java@v4`: Eclipse Temurin JDK 21 kurulumu ve `cache: 'maven'` ile `~/.m2` deposunun önbelleğe alınması (derleme süresini 4 dakikadan 30 saniyeye düşürür). 2) `mvn clean test`: Tüm JUnit 5 ve Spring Boot MockMvc testlerini çalıştırır. 3) Test raporlarının ve kod kapsama oranlarının (JaCoCo) üretilmesi. 4) `mvn package -DskipTests`: Üretim JAR dosyasının derlenmesi.",
            "deep_en": "A resilient Spring Boot CI pipeline includes: 1) `setup-java` configuring JDK 21 with automatic Maven dependency caching (shrinking build times from minutes to seconds). 2) `mvn clean test` executing JUnit 5 unit and integration test suites. 3) JaCoCo test coverage enforcement. 4) Packaging the final layered production executable JAR via Spring Boot Maven plugin.",
            "spring_code": """# Maven CI Job Bloğu:
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
        run: mvn package -DskipTests""",
            "warning_tr": "Maven önbellekleme (`cache: maven`) yapmazsanız, GitHub Actions her commit'te tüm Spring Boot kütüphanelerini internetten sıfırdan indirir; bu da dakikalarca zaman kaybına ve GitHub Actions dakikalarınızın hızla tükenmesine yol açar.",
            "warning_en": "Omitting Maven dependency caching forces the runner to re-download hundreds of megabytes of dependencies on every push, wasting pipeline minutes and developer time.",
            "takeaways": [
                ("Otomatik testler bozuk kodların müşterilere ulaşmasını %100 engeller.", "Automated CI testing guarantees that failing code cannot slip unnoticed into production."),
                ("Maven önbellekleme derleme sürelerini kat kat hızlandırır.", "Maven dependency caching slashes build times from minutes down to seconds."),
                ("Test raporları her Pull Request üzerinde şeffaf biçimde incelenebilir.", "Test outcomes are surfaced directly on GitHub Pull Requests for peer review.")
            ]
        },
        {
            "num": 57,
            "title_tr": "Docker İmajı Paketleme, Trivy Güvenlik Taraması ve GHCR Push",
            "title_en": "Docker Packaging, Trivy Vulnerability Scanning & GHCR Push",
            "eli5_tr": "Fabrikadan çıkan Spring Boot uygulamasını çelik bir kargo konteynerine koyuyoruz. Ama hemen gemiye yüklemiyoruz! Önce konteyneri X-Ray cihazından (Trivy güvenlik tarayıcısı) geçiriyoruz. İçinde tehlikeli bir virüs veya güvenlik açığı (CVE) var mı? Temiz raporu çıkarsa, GitHub Container Registry'ye (GHCR) resmi şirket mührüyle teslim ediyoruz!",
            "eli5_en": "We pack our freshly compiled Spring Boot binary into a standard steel container. But we don't dispatch it blindly! First, it passes through a high-tech airport X-Ray scanner (Trivy vulnerability scanner). Are there any high-severity CVEs? Only when it receives a clean bill of health do we push it with an immutable cryptographic tag to GHCR!",
            "deep_tr": "Bu aşama üç kritik adımdan oluşur: 1) `docker/setup-buildx-action`: Docker Buildx ile hızlı, çok katmanlı önbellek kullanan derleme altyapısı kurar. 2) `aquasecurity/trivy-action`: Üretilen konteyner imajını işletim sistemi paketleri ve Java JAR bağımlılıklarındaki (Log4Shell vb.) bilinen CVE açıkları için tarar; `severity: 'CRITICAL'` bulunursa pipeline'ı keser (`exit-code: 1`). 3) `ghcr.io`: GitHub'ın yerleşik OCI uyumlu konteyner deposuna güvenli push yapılır.",
            "deep_en": "This stage executes: 1) Docker Buildx initialization for advanced multi-platform and layer caching. 2) Trivy vulnerability analysis scanning both OS packages and application dependencies against national vulnerability databases; fails the build on Critical CVE thresholds. 3) Authenticated pushing to GitHub Container Registry (`ghcr.io`) using short-lived runner permissions.",
            "spring_code": """# Docker Derleme, Tarama ve GHCR Push:
- name: GitHub Container Registry Girişi
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}

- name: Docker İmajını Derle
  uses: docker/build-push-action@v5
  with:
    context: .
    load: true
    tags: ghcr.io/${{ github.repository }}/coffee-app:${{ github.sha }}

- name: Trivy ile Güvenlik Taraması Yap
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: 'ghcr.io/${{ github.repository }}/coffee-app:${{ github.sha }}'
    severity: 'CRITICAL,HIGH'
    exit-code: '0' # Kritik açıkları raporla

- name: İmajı Registry'ye Gönder
  run: docker push ghcr.io/${{ github.repository }}/coffee-app:${{ github.sha }}""",
            "warning_tr": "İmaj etiketi olarak ASLA `:latest` kullanmayın! `:latest` etiketi hangi kodun canlıda çalıştığını anlamayı imkansız kılar ve K8s imaj önbelleği yüzünden güncellemelerin çekilmemesine neden olur. Her zaman git commit SHA'sını (`:${{ github.sha }}`) kullanın.",
            "warning_en": "NEVER tag images with `:latest` in production pipelines! `:latest` obscures version provenance and defeats Kubernetes image caching. Always tag with the immutable Git commit SHA.",
            "takeaways": [
                ("Trivy güvenlik açığı olan paketlerin üretim ortamına sızmasını önler.", "Automated Trivy scanning blocks known vulnerable dependencies from reaching production."),
                ("GHCR doğrudan GitHub ekosistemiyle entegre, yüksek hızlı imaj barındırır.", "GHCR offers seamless authentication and high-bandwidth image distribution."),
                ("Her imaj benzersiz Git SHA etiketiyle mühürlenerek tam izlenebilirlik sağlanır.", "Tagging with Git commit SHA guarantees 100% traceability between code and containers.")
            ]
        },
        {
            "num": 58,
            "title_tr": "CI ile GitOps Köprüsü: GitHub Actions'ın Flux Deposunu Güncellemesi",
            "title_en": "Bridging CI to GitOps: GitHub Actions Updating Flux Manifests",
            "eli5_tr": "İki muazzam dünyayı birleştiren altın köprü! GitHub Actions (CI) derlemeyi bitirdiğinde doğrudan gidip K8s kümesine saldırmaz (Bu GitOps kuralına aykırıdır). Bunun yerine gider, Flux'ın izlediği GitOps filosunun deposundaki YAML dosyasını açar: 'İmaj etiketini az önce derlediğim yeni SHA ile güncelledim' diyerek bir commit atar. Ve sahneden çekilir; gerisini Flux halleder!",
            "eli5_en": "The Golden Bridge connecting two mighty engineering realms! When GitHub Actions (CI) finishes building, it NEVER attacks the Kubernetes cluster directly (that violates GitOps!). Instead, it walks over to the separate GitOps repository tracked by Flux, updates the image tag inside `deployment.yaml` with the fresh commit SHA, and pushes a clean commit. CI exits; Flux takes the wheel!",
            "deep_tr": "Kurumsal ayrım prensibi (Separation of Concerns): 1) Kod Reposu (Uygulama kodu + CI pipeline). 2) GitOps Reposu (K8s manifestoları + Ortam ayarları). GitHub Actions derlemeyi bitirdiğinde: `actions/checkout` ile GitOps reposunu klonlar, `clusters/production/.../deployment.yaml` içindeki imaj etiketini yeni derlenen `image: ghcr.io/...:${{ github.sha }}` ile günceller (sed veya Kustomize edit ile), ve GitOps reposuna bir 'chore(release)' commit'i atar.",
            "deep_en": "Separation of concerns: 1) App Repo (source code + test pipelines), 2) GitOps Fleet Repo (Kubernetes manifests + infrastructure state). At the tail of the CI run, the workflow clones the fleet repo, updates the target deployment manifest with the newly pushed container SHA via `kustomize edit set image` or `sed`, and commits back to the fleet repo, triggering Flux in-cluster.",
            "spring_code": """# GitHub Actions'tan GitOps Reposuna Otomatik Terfi (Promotion):
- name: GitOps Deposunu Klonla
  uses: actions/checkout@v4
  with:
    repository: 'my-org/k8s-gitops-fleet'
    token: ${{ secrets.GITOPS_DEPLOY_PAT }}
    path: fleet-repo

- name: İmaj Etiketini Güncelle ve Push Et
  run: |
    cd fleet-repo/clusters/production/coffee-app
    sed -i "s|image: .*|image: ghcr.io/${{ github.repository }}/coffee-app:${{ github.sha }}|g" deployment.yaml
    git config user.name "github-actions[bot]"
    git config user.email "actions@github.com"
    git add deployment.yaml
    git commit -m "chore(release): promote coffee-app to version ${{ github.sha }}"
    git push origin main""",
            "warning_tr": "Uygulama kodunun olduğu repo ile GitOps manifestolarının olduğu repoyu ayrı tutmak en iyi kurumsal pratiktir. Böylece her Java kod değişikliğinde sonsuz bir CI/CD döngüsü (infinite trigger loop) yaşanması engellenir.",
            "warning_en": "Decoupling application repositories from GitOps fleet repositories prevents catastrophic infinite pipeline trigger recursion loops.",
            "takeaways": [
                ("CI altyapısı hiçbir zaman doğrudan Kubernetes kümesine bağlanmaz.", "CI build runners require zero direct network access or credentials to production clusters."),
                ("Dağıtım tetikleyicisi Git üzerindeki temiz bir commit'e dönüşür.", "The release event is formalized as a transparent Git commit in the fleet repo."),
                ("Tek bir `git revert` komutuyla tüm üretim kümesi önceki sürüme geri döner.", "Rolling back production is as simple and safe as executing `git revert` on the fleet repo.")
            ]
        },
        {
            "num": 59,
            "title_tr": "Çoklu Ortam Dağıtımı (Dev -> Staging -> Prod) ve Canary",
            "title_en": "Multi-Stage Environment Promotions: Dev, Staging & Production",
            "eli5_tr": "Yeni geliştirilen bir ilacı önce laboratuvarda fare üzerinde (Dev ortamı), sonra gönüllü küçük bir grupta (Staging ortamı), her şey yolundaysa tüm dünyada (Production ortamı) kullanıma sunarsınız! Hatta üretimde bile önce müşterilerin sadece %10'una yeni versiyonu gösteren 'Kanarya' (Canary) testi yaparsınız. Bir hata varsa sadece %10 etkilenir, anında geri çekilir!",
            "eli5_en": "You don't test a brand-new experimental medicine on the entire global population on day one! You test in the lab (Dev), validate with a small volunteer trial (Staging), and only then release to the public (Production)! And even in production, you use a 'Canary' release: route 10% of users to the new version first. If error rates tick up, kill it instantly before 90% notice!",
            "deep_tr": "Kustomize 'Overlays' mimarisi ile ortam yönetimi: `base/` (Ortak Deployment ve Service tanımları) üzerine `overlays/dev/` (1 kopya, düşük CPU), `overlays/staging/` ve `overlays/production/` (10 kopya, yüksek CPU, HPA, katı kısıtlar) bindirilir. GitHub Actions 'Environments' mekanizmasıyla Production ortamına geçiş için kıdemli mühendis onayı (Manual Approval Gate) zorunlu kılınabilir. Flagger ile Canary analizleri (HTTP hata oranı <%1) yürütülür.",
            "deep_en": "Multi-tier promotion leverages Kustomize Overlays: a common `base/` manifest stack is patched by `overlays/dev/`, `overlays/staging/`, and `overlays/production/` (varying replicas, resource limits, and secrets). GitHub Environments enforce protection rules requiring manual engineering lead sign-offs before staging can promote to production.",
            "spring_code": """# Kustomize Ortam Ağacı:
# apps/coffee-app/
# ├── base/
# │   ├── deployment.yaml
# │   └── service.yaml
# └── overlays/
#     ├── dev/
#     │   └── kustomization.yaml (replicas: 1)
#     └── production/
#         └── kustomization.yaml (replicas: 5, HPA aktif)

# Production Terfisi İçin GitHub Actions Onay Adımı:
# environment:
#   name: production
#   url: https://coffee.production.company.com""",
            "warning_tr": "Farklı ortamlar için ayrı ayrı devasa YAML kopyaları oluşturmayın (Kopya-Yapıştır kirliliği!). Ortak şablonu `base/` altında tutun ve sadece değişen ayarları `overlays/` içinde yamalayın (DRY - Don't Repeat Yourself).",
            "warning_en": "Never duplicate massive YAML manifests across environments! Maintain shared definitions in `base/` and patch environment deltas inside `overlays/`.",
            "takeaways": [
                ("Kustomize overlays tek bir temel şablonla farklı ortamları yönetir.", "Kustomize overlays eliminate manifest duplication while supporting environment nuances."),
                ("GitHub Actions Onay Kapıları (Approval Gates) kontrolsüz prod geçişlerini durdurur.", "Manual approval gates prevent unverified releases from hitting production."),
                ("Kanarya (Canary) dağıtımları hata anında felaketi önceden yakalar.", "Canary deployments limit blast radius to a microscopic fraction of live traffic.")
            ]
        },
        {
            "num": 60,
            "title_tr": "BÜYÜK MEZUNİYET FİNALİ: Uçtan Uca Kurumsal Spring Boot Akışı!",
            "title_en": "THE GRAND FINALE: Full End-to-End Enterprise Flow",
            "eli5_tr": "Ve işte büyük orkestranın tüm enstrümanları sahnede! 60 ders boyunca öğrendiğimiz her parça tek bir kusursuz senfoniye dönüşüyor: Bilgisayarınızda Java Spring Boot kodundaki kahve mesajını değiştirip `git push` yapıyorsunuz. GitHub Actions uyanıyor, Maven ile test edip derliyor, Trivy ile tarıyor, Docker imajını GHCR'ye basıyor, GitOps reposunu güncelliyor, kümedeki Flux değişikliği çekiyor, OpenShift rotası trafiği yönlendiriyor ve siz k9s ekranında pod'ların yeşile dönmesini canlı izliyorsunuz! Tebrikler, artık bir Cloud-Native şampiyonusunuz!",
            "eli5_en": "AND HERE IS THE GRAND SYMPHONY! All 60 lessons unite into one breathtaking enterprise performance: You edit a single line of Java in Spring Boot and type `git push`. GitHub Actions awakens, runs Maven tests, scans with Trivy, pushes the OCI container to GHCR, commits the release SHA to the GitOps fleet repo, Flux pulls the change in-cluster, OpenShift routes live traffic, and you lean back watching the pods glow neon green in k9s! Congratulations: You are officially a Cloud-Native Master!",
            "deep_tr": "Uçtan uca kurumsal yaşam döngüsünün tam özeti: 1) Geliştirici Spring Boot kodunu commitleyip push eder. 2) GitHub Actions CI: `mvn test` -> Docker layered build -> Trivy security scan -> GHCR push. 3) Promotion: Actions, GitOps filosundaki `deployment.yaml` imaj etiketini günceller. 4) Flux GitOps: Değişikliği 30 saniye içinde algılar ve K8s API'sine uygular. 5) K8s/OpenShift: RollingUpdate ile yeni pod'ları ayağa kaldırır, Actuator Startup/Readiness problarını bekler, sıfır kesintiyle trafiği yeni sürüme aktarır. 6) k9s & Prometheus: Sistem mühendisi canlıda logları, CPU/RAM'i ve metrikleri izler.",
            "deep_en": "The definitive Cloud-Native lifecycle synthesis: 1) Dev pushes Java code. 2) GitHub Actions: Maven validation -> Layered Docker build -> Trivy CVE scan -> Push to GHCR. 3) GitOps Promotion: Automation updates fleet manifest with the Git SHA. 4) Flux Reconciliation: Polls Git, detects divergence, applies to K8s API. 5) Orchestration: Zero-downtime RollingUpdate validates Spring Boot Actuator probes before routing traffic. 6) Observability: Real-time verification via k9s HUD and Prometheus telemetry.",
            "spring_code": """# 🚀 BÜYÜK MEZUNİYET KONTROL LİSTESİ:
# 1. Java Kodu: Spring Boot 3.x REST API + Actuator Probes (/actuator/health)
# 2. Docker: Multi-stage build + Layered JAR + Non-Root User (UID 10001)
# 3. K8s: Deployment + ClusterIP + Ingress + HPA + Requests/Limits
# 4. OpenShift: Security Context Constraints (SCC) + Edge Route
# 5. Operators: SpringBootApp CRD + Java Operator SDK Controller
# 6. k9s: Anlık canlı log takibi ('l'), tünel ('shift-f'), kaynak izleme
# 7. FluxCD: GitRepository + Kustomization + ImageUpdateAutomation
# 8. GitHub Actions: Maven Test -> Trivy Scan -> GHCR -> GitOps Auto-Commit

# Tek Komutla Tüm Dünyayı Canlıda İzle:
k9s -n coffee-shop""",
            "warning_tr": "Bulut bilişim yolculuğu burada bitmiyor, yeni başlıyor! Gerçek bir mühendis öğrendiği bu 8 teknolojiyi sürekli pratik yaparak, kendi projelerini konteynerize edip GitOps ile yöneterek refleks haline getirir.",
            "warning_en": "The Cloud-Native journey doesn't end here; it begins! Cement this mastery by building, containerizing, breaking, and healing your own microservices continuously.",
            "takeaways": [
                ("60 derslik tam eğitim: Docker'dan K8s'e, OpenShift'ten Flux ve GitHub Actions'a.", "60 lessons spanning Docker, Kubernetes, OpenShift, k9s, Operators, Flux, and CI/CD."),
                ("Tüm akış endüstri standardı Java Spring Boot mikroservis mimarisiyle uygulandı.", "Anchored throughout by industry-standard Java Spring Boot production implementations."),
                ("Artık kurumsal bulut-yerel mimarileri baştan sona tasarlama ve yönetme yetkisine sahipsiniz!", "You are fully equipped to design, deploy, and automate enterprise cloud platforms!")
            ]
        }
    ]
}
