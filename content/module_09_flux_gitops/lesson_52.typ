#import "/template.typ": *

#show: doc => setup_book(title: "Ders 52: GitRepository ve Kustomization ile Spring Boot Dağıtımı", doc)

#lesson_header(
  52,
  "GitRepository ve Kustomization ile Spring Boot Dağıtımı",
  "Deploying Spring Boot via GitRepository & Kustomization",
  "FluxCD ile Modern GitOps — Tek Gerçek Kaynak Git!",
  "Modern GitOps with FluxCD — Git as the Single Source of Truth"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Bakkala sipariş verirken iki şeye ihtiyaç vardır: 1) Hangi bakkala gideceğiniz (`GitRepository`: 'Git şu GitHub deposuna bak!'), 2) Bakkaldan ne alacağınız ve eve nasıl yerleştireceğiniz (`Kustomization`: 'Deponun içindeki `coffee-app` klasörünü al, K8s kümesindeki `coffee-shop` ortamına kur ve her 5 dakikada bir kontrol et!').
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Ordering groceries requires two distinct instructions: 1) Where is the grocery store? (`GitRepository`: 'Track this GitHub repository branch!'), 2) What items to fetch and where to put them? (`Kustomization`: 'Extract the manifests inside `./apps/coffee-app`, apply them into the `coffee-shop` namespace, and check every 5 minutes!').]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      1) `GitRepository`: Source Controller'a hangi Git URL'sini, hangi branch'i (`ref.branch: main`) ve hangi kontrol aralığını (`interval: 1m`) izleyeceğini söyler. 2) `Kustomization`: Kustomize Controller'a bu repodaki hangi dizinin (`path: ./clusters/production/coffee-app`) hangi namespace'e uygulanacağını belirtir. `prune: true` parametresiyle Git'ten bir YAML silindiğinde K8s kümesinden de otomatik silinmesi sağlanır.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[1) `GitRepository` directs `source-controller` to pull from a Git endpoint, branch, and polling interval, producing an immutable tarball. 2) `Kustomization` instructs `kustomize-controller` to evaluate that tarball at a designated sub-path, target namespace, and interval. Enabling `prune: true` activates automated garbage collection of resources removed from Git.]
    ]
  )
]

#spring_box[
```yaml
# spring-boot-gitops.yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: fleet-repo
  namespace: flux-system
spec:
  interval: 1m
  url: https://github.com/my-org/k8s-gitops-fleet
  ref:
    branch: main
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: coffee-app-kustomization
  namespace: flux-system
spec:
  interval: 5m
  targetNamespace: coffee-shop
  sourceRef:
    kind: GitRepository
    name: fleet-repo
  path: ./clusters/production/coffee-app
  prune: true
  wait: true # Pod'lar ayağa kalkana kadar dağıtımı bekle!
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      `prune: true` parametresi ÇOK GÜÇLÜDÜR! Eğer yanlışlıkla Git deposundan bir YAML dosyasını silip push ederseniz, Flux o servisi ve pod'ları canlı kümeden anında siler! Dikkatli kullanılmalıdır.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[`prune: true` is unforgiving! If you delete a manifest file from Git and commit, Flux will immediately delete the live workload from the cluster.]
    ]
  )
]

#takeaways_box((
    ("GitRepository kaynak izleme görevini, Kustomization ise uygulama görevini üstlenir.", "GitRepository handles artifact pulling; Kustomization handles manifest application."),
    ("`prune: true` ile yetim kalan (orphaned) eski kaynaklar otomatik temizlenir.", "`prune: true` guarantees complete synchronization by sweeping away orphaned resources."),
    ("`flux get kustomizations` komutuyla dağıtım sağlığı anlık olarak izlenir.", "Inspect continuous delivery status via `flux get kustomizations`."),
))
