#import "/template.typ": *

#show: doc => setup_book(title: "Ders 55: GitHub Actions Temelleri: Workflows, Jobs, Steps ve Runners", doc)

#lesson_header(
  55,
  "GitHub Actions Temelleri: Workflows, Jobs, Steps ve Runners",
  "GitHub Actions Fundamentals: Workflows, Jobs, Steps, and Runners",
  "GitHub Actions CI/CD & Büyük Mezuniyet Senaryosu",
  "GitHub Actions CI/CD & The Grand Enterprise Finale"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Kodunuzu GitHub'a `git push` yaptığınız anda harekete geçen görünmez bir fabrika düşünün! 1) Workflow: Fabrikanın üretim planıdır (`.github/workflows/ci.yaml`). 2) Trigger (Tetikleyici): Zilin çalmasıdır ('Main branch'e kod geldi!'). 3) Jobs (İşler): Fabrikanın farklı departmanlarıdır ('Biri test yapsın, diğeri Docker derlesin'). 4) Runners: Bu işleri yapan bulut bilgisayarlarıdır!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[Imagine an invisible, robotic smart factory that fires up the millisecond you run `git push`! 1) Workflow: The factory blueprint (`.github/workflows/ci.yaml`). 2) Trigger (Event): The starting bell ringing ('Code pushed to main!'). 3) Jobs: Distinct assembly lines ('Line 1 tests Java, Line 2 bakes the container'). 4) Runners: The virtual machines in the cloud executing the steps!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      GitHub Actions mimarisinin yapı taşları: 1) `Events`: İş akışını başlatan olaylar (`push`, `pull_request`, `schedule`, `workflow_dispatch`). 2) `Jobs`: Varsayılan olarak paralel çalışan bağımsız görev bloklarıdır (`needs: [build]` ile sıralı bağımlılık kurulur). 3) `Steps`: Sırayla çalıştırılan tekil kabuk komutları (`run`) veya hazır topluluk eylemleri (`uses: actions/checkout@v4`). 4) `Runners`: Ubuntu, macOS veya Windows barındıran geçici sanal makinelerdir.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[The core taxonomy of GitHub Actions: 1) `Events` trigger execution (`push`, `pull_request`, webhooks). 2) `Jobs` run concurrently by default on isolated compute runners unless sequenced via `needs: [jobA]`. 3) `Steps` execute sequentially inside a job environment as shell scripts (`run`) or composite action modules (`uses`). 4) `Runners` are ephemeral hosted virtual machines or self-hosted servers.]
    ]
  )
]

#spring_box[
```bash
# .github/workflows/hello-ci.yaml
name: First Spring Boot Workflow
on:
  push:
    branches: [ "main" ]

jobs:
  say-hello:
    runs-on: ubuntu-latest
    steps:
      - name: Kodu Klonla
        uses: actions/checkout@v4

      - name: Terminale Yazdır
        run: |
          echo "🚀 Java Spring Boot CI Pipeline Başlatıldı!"
          echo "Commit SHA: ${{ github.sha }}" 
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Bir iş akışındaki adımlar (steps) aynı sanal makinede ardışık çalışır ve dosya sistemini paylaşır. Ancak farklı 'Job'lar farklı sanal makinelerde çalıştığı için aralarında dosya paylaşımı yapmak istiyorsanız `actions/upload-artifact` kullanmalısınız!
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Steps within a job share the runner filesystem; distinct Jobs run on separate virtual machines! Pass compiled artifacts between jobs using `upload-artifact` and `download-artifact`.]
    ]
  )
]

#takeaways_box((
    ("GitHub Actions harici CI sunucusu (Jenkins) kurma ihtiyacını ortadan kaldırır.", "Eliminates the maintenance overhead of managing dedicated external CI/CD servers."),
    ("YAML tabanlı bildirici sözdizimi doğrudan projenin Git reposunda saklanır.", "Declarative workflow definitions live directly inside your project repository."),
    ("Geniş GitHub Marketplace ekosistemi hazır otomasyon eylemleri sunar.", "Leverages a vast marketplace of battle-tested open-source actions for rapid setup."),
))
