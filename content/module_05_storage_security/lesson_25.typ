#import "/template.typ": *

#show: doc => setup_book(title: "Ders 25: Kalıcı Depolama: PersistentVolume (PV) ve PersistentVolumeClaim (PVC)", doc)

#lesson_header(
  25,
  "Kalıcı Depolama: PersistentVolume (PV) ve PersistentVolumeClaim (PVC)",
  "Persistent Storage: PersistentVolumes (PV) and Claims (PVC)",
  "Depolama, Güvenlik & Otomatik Ölçekleme",
  "Storage, Security & Horizontal Autoscaling"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Araba kiralama şirketi metaforu: 1) PersistentVolume (PV): Otoparkta bekleyen gerçek fiziksel arabadır (Sistem yöneticisinin hazırladığı 100GB'lık gerçek SSD disk). 2) PersistentVolumeClaim (PVC): Müşterinin elindeki kiralama kuponudur ('Bana 20GB'lık hızlı bir araba ver'). Kubernetes bu kuponu alır, otoparktaki uygun araba ile eşleştirir (Binding) ve anahtarı Spring Boot pod'una teslim eder!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[The Car Rental Metaphor: 1) PersistentVolume (PV): The actual physical car parked in the garage (A real 100GB SSD provisioned by the infrastructure admin). 2) PersistentVolumeClaim (PVC): The customer's rental voucher ('I need a 20GB fast car'). Kubernetes matches the voucher to an available car (Binding) and hands the ignition keys to your Spring Boot Pod!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      PV küme çapında yönetilen gerçek depolama kaynağıdır (NFS, AWS EBS, Ceph). PVC ise bir pod'un talep ettiği depolama isteğidir (boyut ve erişim modu). Erişim modları: 1) `ReadWriteOnce` (RWO: Tek bir düğüm tarafından okunup yazılabilir; veritabanları için standarttır), 2) `ReadOnlyMany` (ROX: Birden fazla düğüm sadece okuyabilir), 3) `ReadWriteMany` (RWX: Birden fazla düğüm aynı anda yazabilir; NFS gerektirir). Pod PVC'yi bir volume olarak bağlar.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[PV is a cluster-level resource backed by raw storage (AWS EBS, Ceph, NFS). PVC is a namespace-scoped ticket requesting capacity and access modes. Core modes: 1) `ReadWriteOnce` (RWO: mountable by a single node as read-write, ideal for databases), 2) `ReadOnlyMany` (ROX: concurrent read-only by multiple nodes), 3) `ReadWriteMany` (RWX: concurrent read-write, requires NFS/Gluster). K8s matches claims against volumes during the Binding lifecycle phase.]
    ]
  )
]

#spring_box[
```yaml
# coffee-pvc.yaml (Spring Boot Yüklenen Dosyalar İçin Kalıcı Disk Talebi)
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: coffee-receipts-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi

# Pod İçinde Bağlama (Volume Mount):
# spec.containers[0].volumeMounts:
#   - mountPath: /app/uploads
#     name: receipts-storage
# spec.volumes:
#   - name: receipts-storage
#     persistentVolumeClaim:
#       claimName: coffee-receipts-pvc
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      `ReadWriteOnce` modu 'aynı anda sadece 1 pod yazabilir' DEĞİL, 'aynı anda sadece 1 sunucu düğümü (Node) yazabilir' anlamına gelir! Farklı sunuculardaki iki pod aynı anda RWO diski paylaşamaz.
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[`ReadWriteOnce` means mountable by a single NODE, not a single Pod! Pods residing on different physical nodes cannot attach to the same RWO volume simultaneously.]
    ]
  )
]

#takeaways_box((
    ("Pod silinse veya başka düğüme taşınsa bile PVC'deki veriler korunur.", "Data persists safely even if the hosting pod is evicted or rescheduled elsewhere."),
    ("Yazılımcılar PV detaylarını bilmeden sadece PVC ile disk talep eder.", "Decouples application developers (PVC) from storage administrators (PV)."),
    ("Veritabanları ve kalıcı dosya yüklemeleri için zorunludur.", "Essential for reliable stateful workloads, file uploads, and databases."),
))
