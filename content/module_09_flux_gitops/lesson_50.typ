#import "/template.typ": *

#show: doc => setup_book(title: "Ders 50: FluxCD Mimarisi: 4 Silahşörler Kontrolcüleri", doc)

#lesson_header(
  50,
  "FluxCD Mimarisi: 4 Silahşörler Kontrolcüleri",
  "FluxCD Architecture: The Four Musketeer Controllers",
  "FluxCD ile Modern GitOps — Tek Gerçek Kaynak Git!",
  "Modern GitOps with FluxCD — Git as the Single Source of Truth"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Flux devasa, hantal tek bir program değildir; her biri kendi işinde uzmanlaşmış 4 süper kahraman robottur: 1) Source Controller: Gözlerini kırpmadan Git deposunu ve Docker registry'yi izleyen gözcü. 2) Kustomize Controller: Çekilen YAML'ları K8s kümesine uygulayan usta işçi. 3) Helm Controller: Dışarıdan paket indiren kargo şefi. 4) Notification Controller: Bir şey olduğunda Slack veya Teams'e haber uçuran haberci!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Flux is not a monolithic bloated daemon; it is a modular league of 4 specialized micro-controllers: 1) Source Controller: The tireless scout watching Git repos and OCI registries. 2) Kustomize Controller: The builder reconciling raw manifests into the cluster. 3) Helm Controller: The logistics manager orchestrating Helm chart lifecycles. 4) Notification Controller: The town crier alerting Slack/Teams when events occur!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Flux v2 (GitOps Toolkit) mimarisi Kubernetes Controller Runtime prensiplerine tam uyumludur: 1) `source-controller`: Git depolarını, OCI imajlarını, Helm repo'larını klonlar ve bir gzip tarball olarak küme içi belleğe sunar. 2) `kustomize-controller`: Bu paketi alır, Kustomize yamalarını (overlays) çözer, K8s API'sine uygular ve `prune: true` ile Git'ten silinen kaynakları kümeden de siler. 3) `helm-controller`: Helm paketlerinin sürümlerini ve yükseltmelerini bildirici yönetir. 4) `notification-controller`: Webhook'ları kabul eder.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[The Flux GitOps Toolkit is a composable set of specialized controllers: 1) `source-controller` clones Git/Helm/Bucket repositories and serves them as localized tarball artifacts. 2) `kustomize-controller` evaluates manifests via Kustomize engines, applies resources to the API Server, and garbage collects orphaned resources when deleted from Git (`prune: true`). 3) `helm-controller` manages Helm chart releases declaratively. 4) `notification-controller` manages outbound notifications and inbound webhooks.]
    ]
  )
]

#spring_box[
```bash
# Flux Kontrolcülerinin Kümedeki Durumunu Sorgula:
flux check

# Çıktı:
# ► checking controllers
# ✔ source-controller: deployment ready
# ✔ kustomize-controller: deployment ready
# ✔ helm-controller: deployment ready
# ✔ notification-controller: deployment ready
# ✔ all checks passed
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Eski Flux v1 tek parçaydı (monolith). Modern Flux v2 ise modüler 'GitOps Toolkit' üzerine kuruludur. Eski v1 dokümanlarındaki `fluxctl` komutlarını kullanmayın; daima modern `flux` CLI'ını kullanın!
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Never use legacy Flux v1 tutorials or the deprecated `fluxctl` CLI. Modern Flux v2 is entirely re-architected around the GitOps Toolkit controller family.]
    ]
  )
]

#takeaways_box((
    ("Flux modüler yapısı sayesinde sadece ihtiyaç duyulan kontrolcüler kurulabilir.", "Micro-controller architecture allows adopting only the controllers you actually need."),
    ("Kustomize Controller otomatik çöp toplayıcı (Garbage Collector) gibi çalışır.", "Kustomize controller's `prune: true` automatically purges deleted resources cleanly."),
    ("Notification Controller ile dağıtım durumları Slack veya Discord'a bağlanır.", "Notification controller routes release events directly to corporate communication channels."),
))
