#import "/template.typ": *

#show: doc => setup_book(title: "Ders 59: Çoklu Ortam Dağıtımı (Dev -> Staging -> Prod) ve Canary", doc)

#lesson_header(
  59,
  "Çoklu Ortam Dağıtımı (Dev -> Staging -> Prod) ve Canary",
  "Multi-Stage Environment Promotions: Dev, Staging & Production",
  "GitHub Actions CI/CD & Büyük Mezuniyet Senaryosu",
  "GitHub Actions CI/CD & The Grand Enterprise Finale"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Yeni geliştirilen bir ilacı önce laboratuvarda fare üzerinde (Dev ortamı), sonra gönüllü küçük bir grupta (Staging ortamı), her şey yolundaysa tüm dünyada (Production ortamı) kullanıma sunarsınız! Hatta üretimde bile önce müşterilerin sadece %10'una yeni versiyonu gösteren 'Kanarya' (Canary) testi yaparsınız. Bir hata varsa sadece %10 etkilenir, anında geri çekilir!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[You don't test a brand-new experimental medicine on the entire global population on day one! You test in the lab (Dev), validate with a small volunteer trial (Staging), and only then release to the public (Production)! And even in production, you use a 'Canary' release: route 10% of users to the new version first. If error rates tick up, kill it instantly before 90% notice!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Kustomize 'Overlays' mimarisi ile ortam yönetimi: `base/` (Ortak Deployment ve Service tanımları) üzerine `overlays/dev/` (1 kopya, düşük CPU), `overlays/staging/` ve `overlays/production/` (10 kopya, yüksek CPU, HPA, katı kısıtlar) bindirilir. GitHub Actions 'Environments' mekanizmasıyla Production ortamına geçiş için kıdemli mühendis onayı (Manual Approval Gate) zorunlu kılınabilir. Flagger ile Canary analizleri (HTTP hata oranı <%1) yürütülür.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Multi-tier promotion leverages Kustomize Overlays: a common `base/` manifest stack is patched by `overlays/dev/`, `overlays/staging/`, and `overlays/production/` (varying replicas, resource limits, and secrets). GitHub Environments enforce protection rules requiring manual engineering lead sign-offs before staging can promote to production.]
    ]
  )
]

#spring_box[
```bash
# Kustomize Ortam Ağacı:
# apps/coffee-app/
# ├── base/
# │   ├── deployment.yaml
# │   └── service.yaml
# └── overlays/
#     ├── dev/
#     │   └── kustomization.yaml (replicas: 1)
#     └── production/
#         └── kustomization.yaml (replicas: 5, HPA aktif)

# Production Terfisi İçin GitHub Actions Onay Adımı:
# environment:
#   name: production
#   url: https://coffee.production.company.com
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Farklı ortamlar için ayrı ayrı devasa YAML kopyaları oluşturmayın (Kopya-Yapıştır kirliliği!). Ortak şablonu `base/` altında tutun ve sadece değişen ayarları `overlays/` içinde yamalayın (DRY - Don't Repeat Yourself).
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Never duplicate massive YAML manifests across environments! Maintain shared definitions in `base/` and patch environment deltas inside `overlays/`.]
    ]
  )
]

#takeaways_box((
    ("Kustomize overlays tek bir temel şablonla farklı ortamları yönetir.", "Kustomize overlays eliminate manifest duplication while supporting environment nuances."),
    ("GitHub Actions Onay Kapıları (Approval Gates) kontrolsüz prod geçişlerini durdurur.", "Manual approval gates prevent unverified releases from hitting production."),
    ("Kanarya (Canary) dağıtımları hata anında felaketi önceden yakalar.", "Canary deployments limit blast radius to a microscopic fraction of live traffic."),
))
