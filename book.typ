#import "/template.typ": *

#show: doc => setup_book(
  title: "Aptala Anlatır Gibi Kubernetes, OpenShift, Flux & GitOps Handbook",
  author: "Antigravity & Cloud-Native Engineering Team",
  doc
)

#book_front_cover()

#pagebreak()
#v(20pt)
#align(center)[
  #text(size: 20pt, weight: "bold", fill: rgb("0f172a"))[Önsöz ve Başlarken / Preface & Getting Started]
]
#v(16pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  [
    == 🇹🇷 Bu Eğitim Hakkında
    Bu kitap; Kubernetes, Red Hat OpenShift, k9s, Kubernetes Operators, FluxCD, Docker ve GitHub Actions gibi modern bulut-yerel (Cloud-Native) dünyasını *bir aptala anlatır gibi* en sade, en eğlenceli ve en akılda kalıcı metaforlarla öğretmek için tasarlanmıştır.

    Her ders; gerçek dünyadan benzetmeler, teknik derinlik, üretime hazır Java Spring Boot 3.x kod örnekleri ve acemi tuzakları içerir. 60 dersin sonunda tek satır koddan canlı kümede çalışan zırhlı mikroservislere kadar tam bir kurumsal döngüyü bizzat yöneteceksiniz!
  ],
  [
    == 🇬🇧 About This Handbook
    This handbook is engineered to demystify Kubernetes, Red Hat OpenShift, k9s, Kubernetes Operators, FluxCD, Docker, and GitHub Actions using crystal-clear *Explain Like I'm 5 (ELI5)* metaphors and zero gatekeeping.

    Every lesson pairs side-by-side Turkish and English explanations, real-world analogies, enterprise-grade Java Spring Boot 3.x manifests, and battle-tested SRE pro-tips. By Lesson 60, you will confidently architect and operate complete GitOps continuous delivery fleets!
  ]
)

#v(20pt)
#line(length: 100%, stroke: 0.8pt + rgb("e2e8f0"))
#v(10pt)

#outline(
  title: [İçindekiler / Table of Contents],
  depth: 2,
  indent: auto
)

#pagebreak()

#module_cover(
  1,
  "Konteyner Dünyası & Docker Temelleri",
  "Container World & Docker Fundamentals",
  "Yazılım dünyasının standart kargo konteynerleri: Sanal makinelerden Docker'a, multi-stage Spring Boot derlemelerine ve ağ yönetimine sıfırdan adım atış.",
  "The standard shipping containers of software: From VMs to Docker, multi-stage Spring Boot builds, volumes, and networks from scratch."
)

#include "/content/module_01_docker/lesson_01.typ"
#v(14pt)

#include "/content/module_01_docker/lesson_02.typ"
#v(14pt)

#include "/content/module_01_docker/lesson_03.typ"
#v(14pt)

#include "/content/module_01_docker/lesson_04.typ"
#v(14pt)

#include "/content/module_01_docker/lesson_05.typ"
#v(14pt)

#include "/content/module_01_docker/lesson_06.typ"
#v(14pt)


#module_cover(
  2,
  "Kubernetes ile Tanışma — Orkestra Şefi",
  "Introduction to Kubernetes — The Conductor",
  "Neden sadece Docker yetmez? K8s mimarisi, Control Plane, Worker Node'lar, Pod kavramı ve ilk Spring Boot manifestomuzu çalıştırma rehberi.",
  "Why Docker alone falls short: K8s architecture, Control Plane, Worker Nodes, Pods, declarative models, and running your first Spring Boot manifest."
)

#include "/content/module_02_k8s_basics/lesson_07.typ"
#v(14pt)

#include "/content/module_02_k8s_basics/lesson_08.typ"
#v(14pt)

#include "/content/module_02_k8s_basics/lesson_09.typ"
#v(14pt)

#include "/content/module_02_k8s_basics/lesson_10.typ"
#v(14pt)

#include "/content/module_02_k8s_basics/lesson_11.typ"
#v(14pt)

#include "/content/module_02_k8s_basics/lesson_12.typ"
#v(14pt)


#module_cover(
  3,
  "K8s İş Yükleri & Dayanıklılık",
  "K8s Workloads & Self-Healing Resilience",
  "Ölümsüz uygulamalar mimarisi: Deployments, ReplicaSets, kesintisiz güncellemeler, Spring Boot Actuator sağlık probları, StatefulSet ve kaynak kotaları.",
  "Immortal applications architecture: Deployments, ReplicaSets, zero-downtime rolling updates, Spring Boot Actuator health probes, StatefulSets, and resource limits."
)

#include "/content/module_03_workloads/lesson_13.typ"
#v(14pt)

#include "/content/module_03_workloads/lesson_14.typ"
#v(14pt)

#include "/content/module_03_workloads/lesson_15.typ"
#v(14pt)

#include "/content/module_03_workloads/lesson_16.typ"
#v(14pt)

#include "/content/module_03_workloads/lesson_17.typ"
#v(14pt)

#include "/content/module_03_workloads/lesson_18.typ"
#v(14pt)


#module_cover(
  4,
  "Ağ, Keşif & Dış Dünyaya Açılma",
  "Networking, Discovery & Ingress Routing",
  "Pod'lar arası dinamik IP kaosuna son: ClusterIP servisleri, NodePort, LoadBalancer, Ingress kontrolcüleri, CoreDNS ve ConfigMap/Secret yönetimi.",
  "Taming ephemeral IP chaos: ClusterIP services, NodePort, LoadBalancers, Ingress traffic cops, CoreDNS resolution, and externalizing configs via ConfigMaps & Secrets."
)

#include "/content/module_04_networking/lesson_19.typ"
#v(14pt)

#include "/content/module_04_networking/lesson_20.typ"
#v(14pt)

#include "/content/module_04_networking/lesson_21.typ"
#v(14pt)

#include "/content/module_04_networking/lesson_22.typ"
#v(14pt)

#include "/content/module_04_networking/lesson_23.typ"
#v(14pt)

#include "/content/module_04_networking/lesson_24.typ"
#v(14pt)


#module_cover(
  5,
  "Depolama, Güvenlik & Otomatik Ölçekleme",
  "Storage, Security & Horizontal Autoscaling",
  "Kalıcı diskler (PV/PVC), StorageClass, RBAC erişim kontrolü, sıkı Pod güvenlik standartları, Namespace izolasyonu ve HPA ile otomatik ölçekleme.",
  "Persistent storage (PV/PVC), StorageClasses, RBAC permissions, hardened Pod security contexts, Namespace tenancy, and HPA auto-scaling under load."
)

#include "/content/module_05_storage_security/lesson_25.typ"
#v(14pt)

#include "/content/module_05_storage_security/lesson_26.typ"
#v(14pt)

#include "/content/module_05_storage_security/lesson_27.typ"
#v(14pt)

#include "/content/module_05_storage_security/lesson_28.typ"
#v(14pt)

#include "/content/module_05_storage_security/lesson_29.typ"
#v(14pt)

#include "/content/module_05_storage_security/lesson_30.typ"
#v(14pt)


#module_cover(
  6,
  "k9s — Terminalin Matrix Arayüzü",
  "k9s — The Terminal Matrix Cockpit",
  "Terminalden ayrılmadan jet uçağı kokpiti gibi K8s yönetimi: k9s kısayolları, canlı log takibi, tek tuşla shell girişi, port yönlendirme ve özel eklentiler.",
  "Supersonic terminal cluster navigation: k9s shortcuts, live log streaming, one-key shell access, port-forwarding, and custom productivity plugins."
)

#include "/content/module_06_k9s/lesson_31.typ"
#v(14pt)

#include "/content/module_06_k9s/lesson_32.typ"
#v(14pt)

#include "/content/module_06_k9s/lesson_33.typ"
#v(14pt)

#include "/content/module_06_k9s/lesson_34.typ"
#v(14pt)

#include "/content/module_06_k9s/lesson_35.typ"
#v(14pt)

#include "/content/module_06_k9s/lesson_36.typ"
#v(14pt)


#module_cover(
  7,
  "Red Hat OpenShift (OCP) — Kurumsal Kubernetes",
  "Red Hat OpenShift (OCP) — Enterprise Kubernetes",
  "Kurumsal bankaların ve dev telekomların tercihi: Standart K8s vs OpenShift, CoreOS, `oc` komutları, Routes, SCC güvenlik kısıtları ve S2I ile otomatik derleme.",
  "The enterprise standard for banks and telcos: Vanilla K8s vs OpenShift, CoreOS, `oc` CLI, Routes, strict SCC security policies, and Source-to-Image (S2I) builds."
)

#include "/content/module_07_openshift/lesson_37.typ"
#v(14pt)

#include "/content/module_07_openshift/lesson_38.typ"
#v(14pt)

#include "/content/module_07_openshift/lesson_39.typ"
#v(14pt)

#include "/content/module_07_openshift/lesson_40.typ"
#v(14pt)

#include "/content/module_07_openshift/lesson_41.typ"
#v(14pt)

#include "/content/module_07_openshift/lesson_42.typ"
#v(14pt)


#module_cover(
  8,
  "Kubernetes Operators — Kendi Akıllı Robotunu Kodla",
  "Kubernetes Operators — Build Your Own Robot SRE",
  "Bir insan SRE mühendisinin beynini koda dökmek: CRD'ler, sonsuz mutabakat (reconciliation) döngüsü, popüler operatörler, OperatorHub ve Java Operator SDK (JOSDK).",
  "Automating the human Site Reliability Engineer: Custom Resource Definitions (CRDs), the reconciliation loop, production operators, OperatorHub, and building Java operators."
)

#include "/content/module_08_operators/lesson_43.typ"
#v(14pt)

#include "/content/module_08_operators/lesson_44.typ"
#v(14pt)

#include "/content/module_08_operators/lesson_45.typ"
#v(14pt)

#include "/content/module_08_operators/lesson_46.typ"
#v(14pt)

#include "/content/module_08_operators/lesson_47.typ"
#v(14pt)

#include "/content/module_08_operators/lesson_48.typ"
#v(14pt)


#module_cover(
  9,
  "FluxCD ile Modern GitOps — Tek Gerçek Kaynak Git!",
  "Modern GitOps with FluxCD — Git as the Single Source of Truth",
  "Canlı sunucuya el sürmeye son: GitOps felsefesi, FluxCD mimarisi, GitHub bootstrap kurulumu, otomatik imaj güncellemesi ve deklaratif Helm yönetimi.",
  "Eliminating manual cluster tinkering: GitOps principles, FluxCD architecture, GitHub bootstrapping, automated image releases, and declarative Helm management."
)

#include "/content/module_09_flux_gitops/lesson_49.typ"
#v(14pt)

#include "/content/module_09_flux_gitops/lesson_50.typ"
#v(14pt)

#include "/content/module_09_flux_gitops/lesson_51.typ"
#v(14pt)

#include "/content/module_09_flux_gitops/lesson_52.typ"
#v(14pt)

#include "/content/module_09_flux_gitops/lesson_53.typ"
#v(14pt)

#include "/content/module_09_flux_gitops/lesson_54.typ"
#v(14pt)


#module_cover(
  10,
  "GitHub Actions CI/CD & Büyük Mezuniyet Senaryosu",
  "GitHub Actions CI/CD & The Grand Enterprise Finale",
  "Uçtan uca otomasyon fabrikası: GitHub Actions iş akışları, Spring Boot Maven testleri, Trivy güvenlik taramaları, GitOps köprüsü ve büyük mezuniyet projesi.",
  "The end-to-end automation factory: GitHub Actions workflows, Spring Boot Maven builds, Trivy CVE scanning, bridging CI to GitOps, and the grand live deployment finale."
)

#include "/content/module_10_github_actions_ci/lesson_55.typ"
#v(14pt)

#include "/content/module_10_github_actions_ci/lesson_56.typ"
#v(14pt)

#include "/content/module_10_github_actions_ci/lesson_57.typ"
#v(14pt)

#include "/content/module_10_github_actions_ci/lesson_58.typ"
#v(14pt)

#include "/content/module_10_github_actions_ci/lesson_59.typ"
#v(14pt)

#include "/content/module_10_github_actions_ci/lesson_60.typ"
#v(14pt)


#pagebreak()
#v(40pt)
#align(center)[
  #rect(fill: rgb("0f172a"), radius: 10pt, inset: (x: 24pt, y: 32pt), width: 90%)[
    #text(size: 24pt, fill: rgb("38bdf8"), weight: "bold")[🎓 TEBRİKLER! / CONGRATULATIONS!]    #v(10pt)
    #text(size: 14pt, fill: white)[60 Derslik Büyük Bulut-Yerel Yolculuğu Başarıyla Tamamladınız!]    #v(6pt)
    #text(size: 11pt, fill: rgb("94a3b8"))[You have successfully conquered all 60 lessons of the Cloud-Native Masterclass!]    #v(20pt)
    #line(length: 60%, stroke: 1pt + rgb("3b82f6"))
    #v(15pt)
    #text(size: 10pt, fill: rgb("cbd5e1"))[
      Docker • Kubernetes • OpenShift • k9s • Operators • FluxCD • GitHub Actions • Java Spring Boot
    ]
  ]
]
