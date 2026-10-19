#import "/template.typ": *

#show: doc => setup_book(title: "Ders 38: OpenShift Mimarisi: CoreOS, OKD ve Platform Operatörleri", doc)

#lesson_header(
  38,
  "OpenShift Mimarisi: CoreOS, OKD ve Platform Operatörleri",
  "OpenShift Architecture: CoreOS, OKD, and Platform Operators",
  "Red Hat OpenShift (OCP) — Kurumsal Kubernetes",
  "Red Hat OpenShift (OCP) — Enterprise Kubernetes"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Geleneksel sunucularda işletim sistemini güncellemek mayın tarlasında yürümek gibidir; bir paket uyuşmaz, tüm sunucu çöker. OpenShift ise Red Hat CoreOS adı verilen 'değiştirilemez' (immutable) bir işletim sistemi kullanır. Düğümlerde SSH ile dosya değiştiremezsiniz; tüm işletim sistemi bir konteyner imajı gibi tek parça halinde atomik olarak güncellenir! Kümenin her organını da özel bir robot (Cluster Operator) yönetir.
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Upgrading standard Linux servers is like tiptoeing through a minefield; one conflicting library breaks everything. OpenShift runs on Red Hat Enterprise Linux CoreOS (RHCOS)—an immutable, container-optimized OS. You don't SSH into nodes to patch them; the entire OS updates atomically like an iPhone firmware update! Cluster Operators supervise every vital subsystem 24/7.]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      OpenShift 4 mimarisi iki temel kavrama dayanır: 1) RHCOS (Red Hat Enterprise Linux CoreOS): Salt-okunur kök dosya sistemi ve `ignition` ile provizyonlanan, Machine Config Operator (MCO) tarafından yönetilen işletim sistemi. 2) Cluster Operators: DNS, Network, Ingress, Authentication, Storage gibi tüm platform bileşenleri birer Kubernetes Operatörüdür. Cluster Version Operator (CVO), tüm kümenin sürüm yükseltmelerini tek bir bildirimle otomatik gerçekleştirir.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[OpenShift 4 architecture centers on: 1) Immutable RHCOS provisioned via Ignition and managed entirely by the Machine Config Operator (MCO). 2) Self-driving Platform Operators: Network, DNS, Ingress, and Storage are all managed by specialized operators. The Cluster Version Operator (CVO) orchestrates end-to-end zero-downtime cluster upgrades declaratively.]
    ]
  )
]

#spring_box[
```bash
# Kümedeki tüm platform operatörlerinin sağlık durumunu incele:
oc get clusteroperators

# Küme sürüm durumunu ve yükseltme geçmişini sorgula:
oc get clusterversion
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      CoreOS düğümlerine girip manuel olarak `apt-get` veya `yum install` yapamazsınız! Kök dosya sistemi salt-okunurdur. Tüm sistem ayarları `MachineConfig` CRD'leri üzerinden yapılmalıdır.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Never attempt to manually patch RHCOS nodes via SSH. The root OS filesystem is read-only; all kernel tweaks must flow through `MachineConfig` manifests.]
    ]
  )
]

#takeaways_box((
    ("RHCOS değiştirilemez işletim sistemi sayesinde düğümler asla 'drift' olmaz.", "Immutable CoreOS prevents configuration drift across physical and virtual nodes."),
    ("Platform Operatörleri kümenin kendi kendini yönetmesini ve onarmasını sağlar.", "Platform operators manage cluster subsystems autonomously with self-healing loops."),
    ("Tek tıkla tüm küme (işletim sistemi dahil) kesintisiz güncellenebilir.", "Enables seamless, one-click atomic updates spanning both K8s and the underlying OS."),
))
