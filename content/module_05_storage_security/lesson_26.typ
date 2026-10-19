#import "/template.typ": *

#show: doc => setup_book(title: "Ders 26: StorageClass ve Dinamik Disk Tahsisi", doc)

#lesson_header(
  26,
  "StorageClass ve Dinamik Disk Tahsisi",
  "StorageClasses and Dynamic On-Demand Provisioning",
  "Depolama, Güvenlik & Otomatik Ölçekleme",
  "Storage, Security & Horizontal Autoscaling"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Eskiden bir yazılımcı disk istediğinde sistem yöneticisine e-posta atar, yönetici veri merkezine gidip kablo takardı (Statik Tahsis — 3 gün sürer!). StorageClass ise otomat makinesidir: Parayı atarsın (PVC talebi gönderirsin), makine sana saniyeler içinde AWS veya Google Cloud'dan gıcır gıcır bir SSD disk üretip verir (Dinamik Tahsis)!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[In the old days, when a developer needed a disk, they filed a ticket and waited 3 days for a sysadmin to rack a physical hard drive (Static Provisioning). A StorageClass is a vending machine: drop your token (PVC manifest), and the machine auto-provisions a shiny new SSD volume directly from the cloud provider in 5 seconds (Dynamic Provisioning)!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      StorageClass, arkasındaki CSI (Container Storage Interface) sürücüsünü (örn: `ebs.csi.aws.com`) ve disk parametrelerini (IOPS, disk tipi: gp3, io2) tanımlar. Bir PVC `storageClassName: fast-ssd` belirttiğinde, Kubernetes ilgili bulut sağlayıcısının API'sini çağırarak diski dinamik olarak oluşturur, anında bir PV nesnesi yaratır ve PVC'ye bağlar. `volumeBindingMode: WaitForFirstConsumer` ayarı diskin pod'un zamanlandığı uygun bölgede (Availability Zone) açılmasını sağlar.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[StorageClasses abstract CSI (Container Storage Interface) provisioners (e.g. AWS EBS CSI, GCP PD CSI). When a PVC specifies a storageClass, the CSI driver automatically creates cloud block volumes on-demand without manual PV creation. Setting `volumeBindingMode: WaitForFirstConsumer` delays volume provisioning until pod scheduling resolves, avoiding cross-zone attachment failures.]
    ]
  )
]

#spring_box[
```yaml
# storage-class-fast.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-nvme-ssd
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer # Pod hangi AZ'ye düşerse diski orada yarat!
parameters:
  type: gp3
  iops: "3000"
allowVolumeExpansion: true # İleride diski küçültmeden büyütebilme izni!
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Farklı Kullanılabilirlik Alanları (Availability Zones): AWS EBS diskleri başka bir AZ'deki sunucuya bağlanamaz! `WaitForFirstConsumer` kullanmazsanız disk A bölgesinde açılabilir ama pod B bölgesine düşüp asılı kalabilir.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Cloud block volumes are pinned to Availability Zones! Omitting `WaitForFirstConsumer` can provision a disk in us-east-1a while the pod is scheduled in 1b, causing permanent mount hangs.]
    ]
  )
]

#takeaways_box((
    ("Dinamik tahsis manuel disk oluşturma ve bağlama yükünü sıfıra indirir.", "Dynamic provisioning eliminates manual disk creation and operational tickets."),
    ("`allowVolumeExpansion: true` ile diskler canlıda kesintisiz büyütülebilir.", "Enables online live volume expansion without deleting claims or pods."),
    ("CSI sürücüleri K8s ile modern bulut depolama sistemleri arasındaki standart köprüdür.", "CSI plugins standardize integration across public clouds and on-prem storage."),
))
