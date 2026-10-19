#import "/template.typ": *

#show: doc => setup_book(title: "Ders 53: Otomatik İmaj Güncellemesi (ImageUpdateAutomation)", doc)

#lesson_header(
  53,
  "Otomatik İmaj Güncellemesi (ImageUpdateAutomation)",
  "Automated Image Updates: Flux Auto-Commit Magic",
  "FluxCD ile Modern GitOps — Tek Gerçek Kaynak Git!",
  "Modern GitOps with FluxCD — Git as the Single Source of Truth"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Gözlerinize inanamayacağınız bir otomasyon! GitHub Actions yeni bir Spring Boot Docker imajı derleyip registry'ye yüklediğinde (örn: `v1.0.5`), Flux bunu tespit eder. Ardından Flux KENDİ KENDİNE Git deponuza bir commit atar: 'Ben yeni imajı gördüm, manifestoyu v1.0.5 yaptım!' der, push eder ve küme güncellenir! Hiçbir insana ihtiyaç kalmaz!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Pure hands-free engineering magic! When your CI pipeline bakes and pushes a new Spring Boot container image (e.g. `v1.0.5`), Flux sniffs it out. Then Flux ITSELF writes a Git commit to your repository: 'Updated coffee-app image to v1.0.5', pushes the commit, and rolls out the release! Zero human clicks required!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Flux Image Automation üç özel CRD ile çalışır: 1) `ImageRepository`: Docker Registry'yi (GHCR, Quay) tarayarak yeni imaj etiketlerini (tags) keşfeder. 2) `ImagePolicy`: Semantik Sürümleme (SemVer: `1.0.x` veya `^1.0.0`) kurallarına göre en güncel stabil sürümü seçer. 3) `ImageUpdateAutomation`: Git deposundaki YAML dosyasında `# {'$imagepolicy': 'flux-system:coffee-policy'}` işaretçisini bulur, etiketi günceller ve Git'e otomatik yazar.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Flux Image Automation orchestrates 3 CRDs: 1) `ImageRepository` scans container registries for new OCI tags. 2) `ImagePolicy` resolves the newest tag using SemVer rules (`range: >=1.0.0 <2.0.0`). 3) `ImageUpdateAutomation` locates setter comments in YAML manifests (`# {"$imagepolicy": ...}`), updates the image tag in-place, and pushes a signed Git commit back to the repo.]
    ]
  )
]

#spring_box[
```yaml
# deployment.yaml içindeki Flux Sihirli Yorum Satırı:
spec:
  containers:
    - name: coffee-container
      # Flux bu satırı otomatik güncelleyip Git'e commit atar:
      image: ghcr.io/eli5-k8s/spring-boot-k8s-eli5:1.0.0 # {"$imagepolicy": "flux-system:coffee-policy"}

# image-policy.yaml
apiVersion: image.toolkit.fluxcd.io/v1beta2
kind: ImagePolicy
metadata:
  name: coffee-policy
  namespace: flux-system
spec:
  imageRepositoryRef:
    name: coffee-image-repo
  policy:
    semver:
      range: '^1.0.0' # 1.x ailesindeki en yeni yamayı otomatik al!
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      ImageUpdateAutomation'ın çalışabilmesi için Flux'ın GitHub deposuna 'YAZMA' (write/push) yetkisinin olması gerekir. Salt-okunur (read-only) deploy key ile bu özellik çalışmaz!
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[ImageUpdateAutomation requires write permissions to your Git repository! A read-only deploy key will fail when Flux attempts to push automated commits.]
    ]
  )
]

#takeaways_box((
    ("Yeni Docker imajları hiçbir manuel müdahale olmadan anında canlıya alınır.", "Container releases occur automatically without manual manifest editing toil."),
    ("SemVer politikaları sayesinde sadece test edilmiş stabil yamalar alınır.", "Semantic versioning policies prevent accidental promotion of untested major releases."),
    ("Git deposu her zaman canlıda çalışan gerçek imaj etiketini tam olarak yansıtır.", "Git commits ensure that your repository always mirrors what is live in production."),
))
