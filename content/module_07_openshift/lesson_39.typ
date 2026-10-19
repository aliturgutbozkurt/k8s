#import "/template.typ": *

#show: doc => setup_book(title: "Ders 39: `oc` Komut Satırı ve OpenShift Web Konsolu ile Görsel Yönetim", doc)

#lesson_header(
  39,
  "`oc` Komut Satırı ve OpenShift Web Konsolu ile Görsel Yönetim",
  "The `oc` CLI & Enterprise Web Console Experience",
  "Red Hat OpenShift (OCP) — Kurumsal Kubernetes",
  "Red Hat OpenShift (OCP) — Enterprise Kubernetes"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      `oc` komut satırı aracı, `kubectl`'in siyah kuşak sahibi karate hocasıdır! `kubectl`'in tüm komutlarını anlar ama üstüne `oc new-app`, `oc login`, `oc project` gibi hayat kurtaran sihirli komutlar ekler. Web Konsolu ise bilim kurgu filmlerindeki kumanda merkezidir: Mikroservislerinizin durumunu birbiriyle konuşan renkli halkalar (Pod Donuts) halinde görsel olarak izlersiniz!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[The `oc` CLI is `kubectl` with a black belt in karate! It executes every single `kubectl` command natively, while introducing developer shortcuts like `oc new-app`, `oc status`, and `oc project`. Meanwhile, the OpenShift Web Console looks like a NASA mission control room: dynamic visual topology graphs display your Spring Boot pods as glowing, animated status rings!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      `oc` CLI ile OpenShift'e özgü kaynaklar (`routes`, `buildconfigs`, `imagestreams`, `deploymentconfigs`) yönetilir. `oc project coffee-shop` komutu, `kubectl config set-context` komutunun yaptığı karmaşık isim alanı geçişini tek hamlede yapar. Web Konsolu iki görünüme sahiptir: 1) Developer Perspective (Kod odaklı, Git bağlantılı, görsel topoloji haritası), 2) Administrator Perspective (Düğümler, depolama, RBAC ve küme operatörleri).
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[The `oc` binary provides first-class support for OpenShift custom resource definitions (`routes`, `imagestreams`, `buildconfigs`). Running `oc project <name>` simplifies namespace switching. The Web Console features two purpose-built modes: 1) Developer Perspective (visual topology maps, Git import wizards, log streams), 2) Administrator Perspective (cluster health, CRDs, quotas, hardware nodes).]
    ]
  )
]

#spring_box[
```bash
# 1. OpenShift kümesine giriş yap
oc login https://api.mycluster.openshift.com:6443 -u developer

# 2. Yeni bir proje (güçlendirilmiş namespace) oluştur ve geç
oc new-project coffee-shop

# 3. Projenin genel durumunu özetle
oc status

# 4. Pod ve servisleri listele
oc get all
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      OpenShift'te 'Project' aslında arka planda bir Kubernetes 'Namespace'idir. Ancak Project nesnesi ek olarak açıklama, görünen isim ve otomatik RBAC izinleri barındırır.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[In OpenShift, a 'Project' is a decorated Kubernetes Namespace with metadata annotations and pre-configured default RBAC roles.]
    ]
  )
]

#takeaways_box((
    ("`oc` CLI `kubectl` ile %100 uyumludur ve ek kurumsal kolaylıklar sunar.", "The `oc` CLI is fully compatible with `kubectl` while adding high-productivity shortcuts."),
    ("Developer Web Konsolu mikroservis bağımlılıklarını görsel grafikle sunar.", "The visual topology console visualizes real-time microservice interactions intuitively."),
    ("Tek bir komutla (`oc project`) ortamlar arasında zahmetsizce geçiş yapılır.", "Switching environments is as simple as typing `oc project <name>`."),
))
