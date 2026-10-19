#import "/template.typ": *

#show: doc => setup_book(title: "Ders 11: Yerel K8s Laboratuvarı: Minikube / Kind ve kubectl Temelleri", doc)

#lesson_header(
  11,
  "Yerel K8s Laboratuvarı: Minikube / Kind ve kubectl Temelleri",
  "Local K8s Lab: Minikube / Kind and kubectl Command Mastery",
  "Kubernetes ile Tanışma — Orkestra Şefi",
  "Introduction to Kubernetes — The Conductor"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Koca bir Boeing 747 uçağını uçurmayı öğrenmek için hemen gerçek yolcu uçağına binmezsiniz; uçuş simülatöründe antrenman yaparsınız! Minikube veya Kind (Kubernetes IN Docker), laptopunuzun içinde güvenle çarpıp parçalayabileceğiniz minyatür bir Kubernetes kümesidir. `kubectl` ise bu uçağın direksiyonu ve vites koludur.
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[You don't learn to pilot a Boeing 747 on a live passenger flight; you practice in a flight simulator! Minikube and Kind (Kubernetes IN Docker) are zero-cost local simulators running right on your laptop where you can crash clusters safely. `kubectl` is the flight stick and control dashboard!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Kind (Kubernetes-in-Docker), her bir K8s düğümünü (Node) ayrı bir Docker konteyneri olarak ayağa kaldırır. Çok düğümlü (multi-node) yerel kümeleri saniyeler içinde başlatmak için idealdir. `kubectl`, `~/.kube/config` dosyasındaki kimlik doğrulama sertifikalarını ve küme uç noktalarını kullanarak doğrudan `kube-apiserver` ile HTTPS üzerinden REST haberleşmesi yapar. Temel bağlamlar (Context) arasında hızlı geçiş sağlar.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Kind runs containerized Kubernetes nodes using Docker containers as mock hardware nodes, making multi-node cluster provisioning instantaneous. `kubectl` parses `~/.kube/config` to authenticate and route encrypted HTTPS REST requests directly to the cluster's `kube-apiserver` endpoint.]
    ]
  )
]

#spring_box[
```bash
# 1. Kind ile yerel bir K8s kümesi oluştur
kind create cluster --name eli5-cluster

# 2. Küme durumunu ve düğümleri listele
kubectl cluster-info
kubectl get nodes

# 3. Kubeconfig bağlamını kontrol et
kubectl config current-context

# 4. Tüm isim alanlarındaki pod'ları listele
kubectl get pods -A
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Çok fazla yerel küme açıp kapatırsanız Docker diskiniz ve belleğiniz şişebilir. Kullanmadığınız Kind kümelerini `kind delete cluster --name eli5-cluster` ile silmeyi unutmayın.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Running multiple local Kind clusters consumes heavy RAM. Always delete unused clusters via `kind delete cluster` when done.]
    ]
  )
]

#takeaways_box((
    ("Kind ve Minikube sıfır maliyetle profesyonel K8s geliştirme ortamı sağlar.", "Kind and Minikube provide rapid, zero-cost local sandbox environments."),
    ("`kubectl` komut satırı aracı API Server ile konuşan anahtardır.", "`kubectl` translates CLI commands into structured JSON REST requests to API Server."),
    ("`~/.kube/config` birden fazla kümenin erişim anahtarlarını barındırır.", "The kubeconfig file manages tokens and contexts across multiple clusters."),
))
