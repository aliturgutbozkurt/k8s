# ☸️ Aptala Anlatır Gibi Kubernetes & GitOps El Kitabı
### *Explain Like I'm 5 (ELI5): Kubernetes, OpenShift, k9s, Operators, FluxCD, Docker & GitHub Actions*
**10 Bölüm • 60 Ders • Çift Dilli (Türkçe & İngilizce) • Java Spring Boot 3.x Odaklı**

---

## 🌟 Proje Vizyonu (Project Overview)

Bu eğitim serisi ve kitap; bulut bilişim dünyasının en kritik teknolojilerini (Docker, Kubernetes, Red Hat OpenShift, k9s, Kubernetes Operators, FluxCD ve GitHub Actions) **en ufak bir kafa karışıklığına yer bırakmadan, gündelik hayattan eğlenceli metaforlarla (ELI5 - Explain Like I'm 5)** ve kurumsal **Java Spring Boot** mikroservis pratiğiyle öğretmek üzere hazırlanmıştır.

- **🇹🇷 & 🇬🇧 Tam Çift Dilli:** Her ders hem Türkçe hem de İngilizce paralel anlatıma sahiptir.
- **📄 60 Tekil PDF + 10 Bölüm PDF'i + 196 Sayfalık Dev Ana Kitap:** Her parça tekil olarak derlenmiş, modüler olarak paketlenmiş ve tek bir ana kitapta birleştirilmiştir.
- **☕ Java Spring Boot 3.x & Actuator:** Tüm kod örnekleri, sağlık probları (liveness/readiness), katmanlı Dockerfile ve konfigürasyonlar gerçek dünyada çalışan mikroservis kodudur.
- **🌐 İnteraktif Web Okuma Portalı:** Tarayıcı üzerinden dersleri gezebileceğiniz, tek tuşla dilleri değiştirebileceğiniz ve kod kopyalayabileceğiniz modern arayüz (`web/index.html`).

---

## 📚 10 Bölüm ve 60 Ders Müfredatı (Curriculum)

| Bölüm | Konu (Topic) | Dersler | İçerik Özeti |
|---|---|---|---|
| **Bölüm 1** | 🐳 **Konteyner Dünyası & Docker Temelleri** | Ders 1 - 6 | Sanal Makineler vs Konteynerler, Docker mimarisi, Multi-stage Spring Boot paketleme, Volumes & Networks, Docker Compose, Non-Root güvenlik & minimal imajlar. |
| **Bölüm 2** | ☸️ **Kubernetes ile Tanışma — Orkestra Şefi** | Ders 7 - 12 | Neden K8s?, Control Plane (API Server, etcd, Scheduler) vs Worker Nodes, Pod anatomisi, Bildirici (Declarative) model, Minikube/Kind laboratuvarı, İlk Pod YAML'ı. |
| **Bölüm 3** | 🔄 **K8s İş Yükleri & Dayanıklılık** | Ders 13 - 18 | Deployment & ReplicaSet (ölümsüz pod'lar), Kesintisiz güncelleme (Rolling Update & Rollback), Spring Boot Actuator Probes (Liveness/Readiness), StatefulSet, DaemonSet & CronJob, Requests/Limits (OOMKilled önleme). |
| **Bölüm 4** | 🌐 **Ağ, Keşif & Dış Dünyaya Açılma** | Ders 19 - 24 | ClusterIP Servisleri, NodePort ve Cloud LoadBalancer, Ingress Trafik Polisi, CoreDNS ile mikroservis iletişimi, Network Policies (iç güvenlik duvarı), ConfigMap & Secret. |
| **Bölüm 5** | 🛡️ **Depolama, Güvenlik & Otomatik Ölçekleme** | Ders 25 - 30 | PersistentVolume (PV) ve PVC disk talepleri, StorageClass ile dinamik disk sağlama, RBAC (ServiceAccount, Role, RoleBinding), SecurityContext (Restricted Pods), Namespaces, HPA (Horizontal Pod Autoscaler). |
| **Bölüm 6** | 📟 **k9s — Terminalin Matrix Arayüzü** | Ders 31 - 36 | k9s nedir ve kurulumu, Işınlanma ve filtreleme kısayolları, Canlı log takibi ve pod içine giriş (`l` ve `s`), Terminalden port yönlendirme (`shift-f`) ve restart, Kaynak izleme barları, Özel eklentiler (Plugins). |
| **Bölüm 7** | 🔴 **Red Hat OpenShift (OCP) — Kurumsal K8s** | Ders 37 - 42 | Standart K8s vs OpenShift, RHCOS & Platform Operatörleri mimarisi, `oc` CLI ve Developer Web Konsolu, Routes vs Ingress (Edge TLS), Security Context Constraints (SCC), S2I (Source-to-Image) derlemeleri. |
| **Bölüm 8** | 🤖 **Kubernetes Operators — Robot SRE Kodlama** | Ders 43 - 48 | Operator Deseni nedir?, CRD (Custom Resource Definition) ve Reconciliation döngüsü, Prometheus & CloudNativePG & Strimzi Kafka, OperatorHub & OLM, Java Operator SDK (JOSDK), `SpringBootApp` Operatörü. |
| **Bölüm 9** | ⚡ **FluxCD ile Modern GitOps** | Ders 49 - 54 | GitOps felsefesi (Push vs Pull), Flux kontrolcüleri (Source, Kustomize, Helm, Notification), `flux bootstrap` ile GitHub eşleme, GitRepository & Kustomization, ImageUpdateAutomation, Declarative Helm. |
| **Bölüm 10** | 🚀 **GitHub Actions CI/CD & Büyük Final** | Ders 55 - 60 | GitHub Actions mimarisi, Spring Boot Maven test & build pipeline, Docker paketleme & Trivy güvenlik taraması & GHCR push, CI'dan GitOps'a otomatik terfi, Dev/Staging/Prod Canary, Büyük Uçtan Uca Final. |

---

## 📁 Proje Dizin Yapısı (Project Architecture)

```
k8s/
├── book.typ                          # 196 Sayfalık Ana Kitap Typst Kaynak Kodu
├── template.typ                      # Profesyonel Çift Dilli Typst Şablonu (v0.15+ uyumlu)
├── build_all.py                      # Otomatik PDF ve İçerik Derleyici (Master Engine)
├── README.md                         # Bu Kapsamlı Dokümantasyon
│
├── modules_data/                     # 10 Bölüm ve 60 Dersin Zengin Python Veri Kaynağı
│   ├── mod01_docker.py               # Ders 1 - 6
│   ├── mod02_k8s_basics.py           # Ders 7 - 12
│   ├── mod03_workloads.py            # Ders 13 - 18
│   ├── mod04_networking.py           # Ders 19 - 24
│   ├── mod05_storage_security.py     # Ders 25 - 30
│   ├── mod06_k9s.py                  # Ders 31 - 36
│   ├── mod07_openshift.py            # Ders 37 - 42
│   ├── mod08_operators.py            # Ders 43 - 48
│   ├── mod09_flux_gitops.py          # Ders 49 - 54
│   └── mod10_github_actions.py       # Ders 55 - 60
│
├── content/                          # Üretilen Typst Kaynak Dosyaları
│   ├── module_01_docker/             # lesson_01.typ ... lesson_06.typ & module_01.typ
│   ├── module_02_k8s_basics/         # lesson_07.typ ... lesson_12.typ & module_02.typ
│   └── ... (module_03 -> module_10)
│
├── output/                           # Derlenmiş Yayın Kalitesinde PDF Dosyaları
│   ├── book/
│   │   └── Kubernetes_GitOps_Mastery_ELI5.pdf  # 196 Sayfalık Master Kitap (1.7 MB)
│   ├── modules/                      # 10 Adet Bölüm Paketi PDF'i
│   │   ├── module_01_module_01_docker.pdf
│   │   └── ... (module_02 -> module_10)
│   └── individual/                   # 60 Adet Tekil Ders PDF'i
│       ├── lesson_01.pdf
│       └── ... (lesson_02 -> lesson_60)
│
├── web/                              # İnteraktif Web Okuma ve İnceleme Portalı
│   ├── index.html                    # Modern Web Arayüzü
│   ├── styles.css                    # Glassmorphism & Koyu Tema CSS
│   ├── app.js                        # Dinamik Arama, Dil Değiştirici ve Klavye Kontrolleri
│   └── data/
│       └── lessons.json              # 60 Dersin JSON Veritabanı
│
└── examples/                         # Çalıştırılabilir Gerçek Kod Örnekleri
    ├── spring-boot-app/              # Spring Boot 3.x REST API + Actuator + Multi-Stage Dockerfile
    ├── k8s-manifests/                # All-in-one Kubernetes Manifestoları (Deployment, HPA, Ingress)
    ├── openshift-manifests/          # OpenShift Route ve Güvenlik Tanımları
    ├── operators/                    # SpringBootApp CRD ve Özel Kaynak
    ├── flux-system/                  # GitRepository ve Kustomization GitOps Tanımları
    └── .github/workflows/ci-cd.yaml  # GitHub Actions Uçtan Uca CI/CD Pipeline
```

---

## 🚀 Hızlı Başlangıç (Quick Start)

### 1. Web Portalı ile Tarayıcıda İnceleme
Web portalı arka planda `http://localhost:4580/web/index.html` adresinde çalışmaktadır:
```bash
# Web portalını başlatmak için:
python3 -m http.server 4580 --directory /Users/aliturgutbozkurt/Desktop/k8s
```
Tarayıcınızda açtığınızda:
- `🌐 İkisi`: Türkçe ve İngilizce yan yana çift sütun okuma modu
- `🇹🇷 TR`: Sadece Türkçe odaklı okuma modu
- `🇬🇧 EN`: Sadece İngilizce odaklı okuma modu
- `/` veya `k`: Canlı anlık arama çubuğu
- `📥 PDF İndir`: 60 dersin ve ana kitabın indirme modalı

### 2. PDF'leri Sıfırdan Yeniden Derleme
Tüm PDF'ler `typst` motoru ile milisaniyeler içinde üretilir:
```bash
# Tüm 60 tekil PDF'i, 10 modül PDF'ini ve 196 sayfalık ana kitabı derlemek için:
python3 build_all.py --all

# Sadece ana kitabı derlemek için:
python3 build_all.py --book

# Sadece 10 bölüm paketini derlemek için:
python3 build_all.py --modules
```

---

## ☕ Spring Boot Örnek Uygulaması Testi

`examples/spring-boot-app` dizinindeki mikroservis üretime hazırdır:
```bash
cd examples/spring-boot-app

# 1. Maven ile test ve paketleme:
mvn clean test package

# 2. Katmanlı (Layered) Docker imajı derleme:
docker build -t coffee-app:1.0.0 .

# 3. Çalıştırma:
docker run -d -p 8080:8080 --name coffee-app coffee-app:1.0.0

# 4. K8s Actuator Problarını denetleme:
curl http://localhost:8080/actuator/health/liveness
curl http://localhost:8080/actuator/health/readiness
curl http://localhost:8080/api/coffee
```

---

## 📜 Lisans & Yayın Hakları
Bu eğitim materyali, bulut bilişim ve DevOps kültürünü yaygınlaştırmak amacıyla topluluğun faydalanması için hazırlanmıştır. Ticari veya eğitim amaçlı serbestçe kullanılabilir.
