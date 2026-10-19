// ==============================================================================
// KUBERNETES & GITOPS ELI5 - PROFESSIONAL TYPST TEMPLATE (v0.15+ COMPATIBLE)
// Çift Dilli (Türkçe & English) - Yayın Kalitesinde Kitap ve Ders Şablonu
// ==============================================================================

#let setup_book(title: "", author: "Antigravity & Community", body) = {
  set document(title: title, author: author)
  set text(font: ("Avenir Next", "Helvetica Neue", "Arial"), size: 10pt, lang: "tr")
  set page(
    paper: "a4",
    margin: (x: 2cm, top: 2.5cm, bottom: 2.5cm),
    header: context {
      let cur_page = counter(page).get().first()
      if cur_page > 2 [
        #text(size: 8pt, fill: rgb("64748b"))[
          #grid(
            columns: (1fr, 1fr),
            [Kubernetes, OpenShift, Flux & GitOps ELI5 Handbook],
            [#align(right)[Aptala Anlatır Gibi K8s & GitOps]]
          )
        ]
        #v(-2pt)
        #line(length: 100%, stroke: 0.5pt + rgb("e2e8f0"))
      ]
    },
    footer: context {
      let cur_page = counter(page).get().first()
      if cur_page > 2 [
        #line(length: 100%, stroke: 0.5pt + rgb("e2e8f0"))
        #v(2pt)
        #text(size: 8pt, fill: rgb("64748b"))[
          #grid(
            columns: (1fr, 1fr),
            [Java Spring Boot & Cloud-Native Suite],
            [#align(right)[Sayfa / Page #counter(page).display()]]
          )
        ]
      ]
    }
  )
  set par(justify: true, leading: 0.65em)
  body
}

#let eli5_box(body) = {
  v(6pt)
  rect(
    width: 100%,
    fill: rgb("eff6ff"), // soft blue
    stroke: (left: 4.5pt + rgb("2563eb"), rest: 0.5pt + rgb("bfdbfe")),
    radius: (right: 6pt),
    inset: (x: 14pt, y: 12pt),
    [
      #grid(
        columns: (1fr, 1fr),
        gutter: 10pt,
        [#text(weight: "bold", fill: rgb("1e40af"), size: 10.5pt)[💡 Aptala Anlatım (ELI5 Metaforu)]],
        [#align(right)[#text(weight: "bold", fill: rgb("1d4ed8"), size: 10.5pt)[💡 ELI5 Metaphor]]]
      )
      #v(6pt)
      #body
    ]
  )
  v(6pt)
}

#let deep_dive_box(body) = {
  v(6pt)
  rect(
    width: 100%,
    fill: rgb("f8fafc"), // slate
    stroke: (left: 4.5pt + rgb("475569"), rest: 0.5pt + rgb("cbd5e1")),
    radius: (right: 6pt),
    inset: (x: 14pt, y: 12pt),
    [
      #grid(
        columns: (1fr, 1fr),
        gutter: 10pt,
        [#text(weight: "bold", fill: rgb("334155"), size: 10.5pt)[🔍 Derinlemesine Teknik Bakış]],
        [#align(right)[#text(weight: "bold", fill: rgb("475569"), size: 10.5pt)[🔍 Technical Deep-Dive]]]
      )
      #v(6pt)
      #body
    ]
  )
  v(6pt)
}

#let spring_box(body) = {
  v(6pt)
  rect(
    width: 100%,
    fill: rgb("f0fdf4"), // emerald
    stroke: (left: 4.5pt + rgb("16a34a"), rest: 0.5pt + rgb("bbf7d0")),
    radius: (right: 6pt),
    inset: (x: 14pt, y: 12pt),
    [
      #grid(
        columns: (1fr, 1fr),
        gutter: 10pt,
        [#text(weight: "bold", fill: rgb("15803d"), size: 10.5pt)[☕ Java Spring Boot Pratiği]],
        [#align(right)[#text(weight: "bold", fill: rgb("166534"), size: 10.5pt)[☕ Spring Boot in Action]]]
      )
      #v(6pt)
      #body
    ]
  )
  v(6pt)
}

#let warning_box(body) = {
  v(6pt)
  rect(
    width: 100%,
    fill: rgb("fffbeb"), // amber
    stroke: (left: 4.5pt + rgb("d97706"), rest: 0.5pt + rgb("fde68a")),
    radius: (right: 6pt),
    inset: (x: 14pt, y: 12pt),
    [
      #grid(
        columns: (1fr, 1fr),
        gutter: 10pt,
        [#text(weight: "bold", fill: rgb("b45309"), size: 10.5pt)[⚠️ Acemi Tuzağı & Pro İpucu]],
        [#align(right)[#text(weight: "bold", fill: rgb("92400e"), size: 10.5pt)[⚠️ Gotchas & Pro-Tips]]]
      )
      #v(6pt)
      #body
    ]
  )
  v(6pt)
}

#let takeaways_box(takeaways) = {
  v(6pt)
  rect(
    width: 100%,
    fill: rgb("faf5ff"), // purple
    stroke: (left: 4.5pt + rgb("9333ea"), rest: 0.5pt + rgb("e9d5ff")),
    radius: (right: 6pt),
    inset: (x: 14pt, y: 12pt),
    [
      #grid(
        columns: (1fr, 1fr),
        gutter: 10pt,
        [#text(weight: "bold", fill: rgb("7e22ce"), size: 10.5pt)[🎯 Özet Çıkarımlar]],
        [#align(right)[#text(weight: "bold", fill: rgb("6b21a8"), size: 10.5pt)[🎯 Key Takeaways]]]
      )
      #v(6pt)
      #for item in takeaways [
        #grid(
          columns: (1fr, 1fr),
          gutter: 12pt,
          [#text(size: 9pt)[• #item.at(0)]],
          [#text(size: 9pt, fill: rgb("475569"))[• #item.at(1)]]
        )
        #v(3pt)
      ]
    ]
  )
  v(6pt)
}

#let lesson_header(lesson_num, title_tr, title_en, module_name_tr, module_name_en) = {
  v(6pt)
  rect(
    width: 100%,
    fill: rgb("0f172a"), // dark navy
    radius: 8pt,
    inset: (x: 16pt, y: 14pt),
    [
      #grid(
        columns: (auto, 1fr),
        gutter: 14pt,
        [
          #circle(radius: 20pt, fill: rgb("3b82f6"))[
            #align(center + horizon)[#text(weight: "bold", fill: white, size: 13pt)[#lesson_num]]
          ]
        ],
        [
          #text(size: 8pt, fill: rgb("94a3b8"), weight: "bold")[
            BÖLÜM: #upper(module_name_tr)  |  MODULE: #upper(module_name_en)
          ]
          #v(2pt)
          #text(size: 13.5pt, fill: white, weight: "bold")[#title_tr]
          #v(2pt)
          #text(size: 11pt, fill: rgb("38bdf8"), weight: "medium")[#title_en]
        ]
      )
    ]
  )
  v(8pt)
}

#let module_cover(module_num, title_tr, title_en, desc_tr, desc_en) = {
  pagebreak()
  v(30pt)
  align(center)[
    #rect(
      width: 100%,
      fill: rgb("1e293b"),
      radius: 12pt,
      inset: (x: 24pt, y: 32pt),
      [
        #text(size: 14pt, fill: rgb("38bdf8"), weight: "bold")[BÖLÜM #module_num / MODULE #module_num]
        #v(10pt)
        #text(size: 22pt, fill: white, weight: "bold")[#title_tr]
        #v(6pt)
        #text(size: 16pt, fill: rgb("94a3b8"), weight: "medium")[#title_en]
        #v(16pt)
        #line(length: 60%, stroke: 1.5pt + rgb("3b82f6"))
        #v(16pt)
        #grid(
          columns: (1fr, 1fr),
          gutter: 20pt,
          [
            #align(left)[
              #text(size: 10pt, fill: rgb("cbd5e1"))[#desc_tr]
            ]
          ],
          [
            #align(left)[
              #text(size: 10pt, fill: rgb("94a3b8"))[#desc_en]
            ]
          ]
        )
      ]
    )
  ]
  v(20pt)
}

#let book_front_cover() = {
  set page(header: none, footer: none, margin: 0pt)
  rect(
    width: 100%,
    height: 100%,
    fill: rgb("0a0f1d"), // deep space navy
    inset: (x: 3.5cm, y: 3.5cm),
    [
      #v(20pt)
      #rect(fill: rgb("1e3a8a"), radius: 4pt, inset: (x: 10pt, y: 6pt))[
        #text(size: 10pt, fill: rgb("93c5fd"), weight: "bold")[ENTERPRISE CLOUD-NATIVE SUITE (BILINGUAL / ÇİFT DİLLİ)]
      ]
      #v(16pt)
      #text(size: 30pt, fill: white, weight: "bold")[
        Aptala Anlatır Gibi\ Kubernetes & GitOps
      ]
      #v(8pt)
      #text(size: 18pt, fill: rgb("38bdf8"), weight: "medium")[
        Explain Like I'm 5: K8s, OpenShift, k9s, Operators, Flux & GitHub Actions
      ]
      #v(12pt)
      #text(size: 12pt, fill: rgb("94a3b8"))[
        10 Bölüm • 60 Ders • Java Spring Boot Odaklı Uçtan Uca Kurumsal Rehber
      ]
      #v(24pt)
      #line(length: 100%, stroke: 2pt + rgb("3b82f6"))
      #v(24pt)
      #grid(
        columns: (1fr, 1fr, 1fr),
        gutter: 12pt,
        [
          #rect(fill: rgb("1e293b"), radius: 6pt, inset: 10pt, width: 100%)[
            #text(weight: "bold", fill: white, size: 9.5pt)[🐳 Docker & K8s]\
            #v(2pt)
            #text(size: 8pt, fill: rgb("94a3b8"))[Container mimarisi, Pod'lar, Servisler, Ingress]
          ]
        ],
        [
          #rect(fill: rgb("1e293b"), radius: 6pt, inset: 10pt, width: 100%)[
            #text(weight: "bold", fill: white, size: 9.5pt)[🛡️ OpenShift & k9s]\
            #v(2pt)
            #text(size: 8pt, fill: rgb("94a3b8"))[Kurumsal OCP, SCC, Terminal Matrix Kokpiti]
          ]
        ],
        [
          #rect(fill: rgb("1e293b"), radius: 6pt, inset: 10pt, width: 100%)[
            #text(weight: "bold", fill: white, size: 9.5pt)[⚡ FluxCD & CI/CD]\
            #v(2pt)
            #text(size: 8pt, fill: rgb("94a3b8"))[GitOps, Operators, GitHub Actions Pipeline]
          ]
        ]
      )
      #v(40pt)
      #align(bottom)[
        #text(size: 9.5pt, fill: rgb("64748b"))[
          Yayın Sürümü: 1.0.0 • Java 21 & Spring Boot 3.x Uyumlu • 2026
        ]
      ]
    ]
  )
}
