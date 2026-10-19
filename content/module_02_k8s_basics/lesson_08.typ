#import "/template.typ": *

#show: doc => setup_book(title: "Ders 8: K8s Mimarisi: Control Plane (Beyin) vs Worker Nodes (Kas Gücü)", doc)

#lesson_header(
  8,
  "K8s Mimarisi: Control Plane (Beyin) vs Worker Nodes (Kas Gücü)",
  "K8s Architecture: Control Plane (Brain) vs Worker Nodes (Muscle)",
  "Kubernetes ile Tanışma — Orkestra Şefi",
  "Introduction to Kubernetes — The Conductor"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Dev bir inşaat şirketi düşünün. Şirketin lüks genel merkezinde (Control Plane) oturan yöneticiler vardır: 1) Resepsiyonist (API Server): Tüm emirleri kabul eder. 2) Noter (etcd): Yapılan her sözleşmeyi kasaya kilitler. 3) Teşrifatçı (Scheduler): Hangi işçinin hangi şantiyeye gideceğini seçer. 4) Denetmen (Controller Manager): Eksik işçi var mı diye kontrol eder. Şantiyede (Worker Node) ise baretini takıp harç karan işçiler (Kubelet ve Kube-Proxy) bulunur!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Picture a massive global construction firm. The air-conditioned headquarters is the Control Plane: 1) Receptionist (API Server): The only entry door for orders. 2) Master Vault (etcd): Immutable ledger storing all facts. 3) Dispatcher (Scheduler): Decides which worker goes to which site. 4) Inspector (Controller Manager): Constantly counts headcount. The actual construction sites are Worker Nodes with Kubelet (Site Foreman) and Kube-Proxy (Traffic Controller)!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Control Plane bileşenleri: 1) kube-apiserver (REST API sunar; tüm bileşenler sadece onunla konuşur), 2) etcd (Raft konsensüs algoritması kullanan dağıtık anahtar-değer veritabanı; kümenin tek gerçek kaynağı), 3) kube-scheduler (Kaynak ihtiyaçlarına göre Pod'u en uygun Node'a atar), 4) kube-controller-manager (Deployment, Node, Endpoints kontrol döngülerini çalıştırır). Worker Node bileşenleri: 1) kubelet (Düğümdeki K8s ajanı; konteynerleri başlatır ve denetler), 2) kube-proxy (Ağ kurallarını ve iptables/IPVS yönlendirmelerini yönetir), 3) Container Runtime (containerd/CRI-O).
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Control Plane internals: 1) kube-apiserver (central REST gateway; all cluster state passes here), 2) etcd (high-availability Raft-backed key-value store), 3) kube-scheduler (assigns unscheduled pods to optimal nodes), 4) kube-controller-manager (executes reconciliation loops). Worker Node components: 1) kubelet (node agent interacting with CRI to manage containers), 2) kube-proxy (maintains network packet filtering rules via iptables/IPVS), 3) Container Runtime (CRI-O / containerd).]
    ]
  )
]

#spring_box[
```bash
# Control plane ve worker node'ların durumunu sorgula:
kubectl get nodes -o wide

# Cluster bileşenlerinin sağlık durumunu kontrol et:
kubectl get componentstatuses 2>/dev/null || kubectl get --raw='/readyz'
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      etcd veritabanı çökerse tüm küme kör olur! Üretim ortamında etcd her zaman tek sayılı (3 veya 5 düğüm) quorum mimarisiyle ve yüksek hızlı SSD disklerle çalıştırılmalıdır.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[If etcd loses quorum, your entire cluster enters read-only paralysis! Always run 3 or 5 odd-numbered etcd nodes on dedicated NVMe storage.]
    ]
  )
]

#takeaways_box((
    ("API Server kümenin tek giriş kapısıdır; kimse doğrudan etcd ile konuşamaz.", "The API Server is the sole gateway; components never talk directly to etcd."),
    ("Kubelet, API Server'dan aldığı talimatları yerel konteyner motoruna iletir.", "Kubelet ensures containers described in PodSpecs are running and healthy."),
    ("Düğümler arızalansa bile Control Plane pod'ları başka düğümlere taşır.", "When a worker node dies, the Control Plane reschedules pods seamlessly."),
))
