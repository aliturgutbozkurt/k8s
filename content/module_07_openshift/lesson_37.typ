#import "/template.typ": *

#show: doc => setup_book(title: "Ders 37: OpenShift Nedir? Standart K8s vs OpenShift", doc)

#lesson_header(
  37,
  "OpenShift Nedir? Standart K8s vs OpenShift",
  "What is OpenShift? Vanilla Kubernetes vs Red Hat OpenShift",
  "Red Hat OpenShift (OCP) — Kurumsal Kubernetes",
  "Red Hat OpenShift (OCP) — Enterprise Kubernetes"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Düz Kubernetes (Vanilla K8s), parçaları kutuda gelen bir yarış arabası şasisidir; motoru vardır ama koltukları, emniyet kemerini, klimayı, hatta kapı kollarını (Monitoring, Ingress, Registry, CI/CD) sanayiye gidip kendiniz tek tek taktırmak zorundasınız (Vahşi Batı!). Red Hat OpenShift ise fabrikadan zırhlı camları, deri koltukları, 24 saat yol yardımı ve tam güvenlik donanımıyla anahtar teslim çıkmış kurumsal bir Mercedes'tir!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Vanilla Kubernetes is a DIY kit car chassis: you get an engine, but you must fabricate your own seats, seatbelts, AC, and mirrors (monitoring, ingress, registries, CI pipelines). Red Hat OpenShift is an armor-plated, fully assembled, factory-warrantied enterprise Mercedes delivered turnkey with 24/7 Red Hat enterprise support!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Red Hat OpenShift Container Platform (OCP), CNCF sertifikalı standart Kubernetes çekirdeği üzerine inşa edilmiş, tam teşekküllü kurumsal bir uygulama platformudur. Düz K8s'e ek olarak şunları yerleşik (out-of-the-box) getirir: 1) Yerleşik kurumsal Container Registry, 2) Prometheus/Grafana izleme yığını, 3) OpenShift Router (HAProxy tabanlı Route mekanizması), 4) Güçlü Web Konsolu (Developer ve Admin modları), 5) Otomasyonlu işletim sistemi (Red Hat Enterprise Linux CoreOS).
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[OpenShift is a CNCF-certified Kubernetes distribution wrapped with integrated enterprise services. Beyond the core K8s API, OCP pre-packages: an integrated OCI image registry, full-stack Prometheus/Alertmanager monitoring, automated OS provisioning via RHEL CoreOS, HAProxy routing, Git-to-deployment pipelines (BuildConfigs), and a unified developer-centric Web UI.]
    ]
  )
]

#spring_box[
```bash
# Standart Kubernetes CLI:
kubectl get pods

# OpenShift CLI (Tam geriye dönük uyumlu + ek süper güçler!):
oc get pods
oc status
oc whoami
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Düz Kubernetes için yazılmış standart YAML dosyalarının %99'u OpenShift üzerinde doğrudan çalışır. Ancak OpenShift'in varsayılan güvenlik kısıtlamaları (SCC) nedeniyle `root` olarak çalışan konteynerler anında engellenir!
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[While 99% of standard K8s manifests run on OpenShift, containers requiring root privileges will be immediately rejected by OpenShift's strict security policies.]
    ]
  )
]

#takeaways_box((
    ("OpenShift, Kubernetes motoru üzerine inşa edilmiş anahtar teslim kurumsal platformdur.", "OpenShift is a fully supported, production-ready enterprise distribution of Kubernetes."),
    ("Geliştirici odaklı araçlar, izleme ve imaj depoları yerleşik olarak gelir.", "Built-in integrated registry, monitoring, build pipelines, and routing out of the box."),
    ("Dünyadaki büyük bankaların ve telekomünikasyon şirketlerinin 1 numaralı tercihidir.", "The enterprise standard across Fortune 500 banks, airlines, and telecom leaders."),
))
