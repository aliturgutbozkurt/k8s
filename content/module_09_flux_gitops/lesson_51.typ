#import "/template.typ": *

#show: doc => setup_book(title: "Ders 51: Flux Bootstrap: K8s Kümesi ile GitHub Deposunu Nikahlama", doc)

#lesson_header(
  51,
  "Flux Bootstrap: K8s Kümesi ile GitHub Deposunu Nikahlama",
  "Flux Bootstrap: Marrying the K8s Cluster to a GitHub Repo",
  "FluxCD ile Modern GitOps — Tek Gerçek Kaynak Git!",
  "Modern GitOps with FluxCD — Git as the Single Source of Truth"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Eskiden GitOps kurmak haftalarca süren sertifika ve konfigürasyon eziyetiydi. Flux Bootstrap tek bir sihirli nikah memurudur! Terminale tek bir komut yazarsınız (`flux bootstrap github`): K8s kümenize gider Flux'ı kurar, GitHub hesabınızda yepyeni bir repo açar, içine şifreli SSH anahtarlarını yerleştirir ve ikisini sonsuza dek birbirine bağlar!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Setting up GitOps used to require days of manual SSH key juggling. Flux Bootstrap is a one-line automated marriage officiant! You run a single command (`flux bootstrap github`): it installs Flux on your cluster, creates the Git repository on your GitHub account, configures secure deploy keys, and binds them together in holy matrimony!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      `flux bootstrap` komutu hem emirsel başlatıcı hem de bildirici bir döngüdür. Arka planda: 1) GitHub API'sini kullanarak belirtilen organizasyon veya kullanıcı altında Git reposunu oluşturur. 2) Kümede Flux manifestolarını ayağa kaldırır. 3) Bir SSH Deploy Key çifti üretir; genel anahtarı GitHub reposuna 'read/write' yetkisiyle ekler, özel anahtarı ise K8s `flux-system` namespace'ine Secret olarak kilitler. 4) Flux'ın kendi manifestolarını Git'e commit atar; böylece Flux kendi kendini bile GitOps ile günceller!
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[The `flux bootstrap` command is idempotent and self-referential: 1) It provisions the target Git repository via the GitHub REST API, 2) Generates a dedicated SSH keypair, installing the public key as a GitHub Deploy Key and the private key as a Kubernetes Secret, 3) Commits its own component manifests into Git (`flux-system`), allowing Flux to upgrade itself via GitOps.]
    ]
  )
]

#spring_box[
```bash
# GitHub Kişisel Erişim Belirteci (Token) Belirle:
export GITHUB_TOKEN="ghp_yourPersonalAccessTokenHere"

# Tek Komutla Flux Bootstrap Kurulumu:
flux bootstrap github \
  --owner=my-org \
  --repository=k8s-gitops-fleet \
  --branch=main \
  --path=clusters/production \
  --personal
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Oluşturduğunuz GitHub Token'ın `repo` izinlerine sahip olduğundan emin olun! Token izinleri yetersizse Bootstrap işlemi reponun açılması veya deploy key eklenmesi aşamasında hata verir.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Your GitHub Personal Access Token requires full `repo` scopes! Insufficient token permissions will fail during deploy key or webhook injection.]
    ]
  )
]

#takeaways_box((
    ("Bootstrap işlemi küme ile Git deposu arasındaki güvenli köprüyü kurar.", "Bootstrap establishes the cryptographically secured bridge between Git and cluster."),
    ("Flux kendi kendini yöneten (self-managing) bir yapıya kavuşur.", "Flux manages its own version and configuration via GitOps once bootstrapped."),
    ("Kümenin tüm tanımı Git üzerindeki `clusters/production` klasöründe saklanır.", "Cluster state lives transparently inside the version-controlled `clusters/` directory."),
))
