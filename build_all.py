#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
build_all.py
Master generator and compiler for the 10-Module, 60-Lesson Bilingual ELI5
Kubernetes, OpenShift, k9s, Operators, Flux, Docker & GitHub Actions Handbook.

Outputs:
  - content/module_XX/lesson_YY.typ (60 files)
  - content/module_XX/module_XX.typ (10 files)
  - book.typ (Master unified book)
  - output/individual/lesson_XX.pdf (60 PDFs)
  - output/modules/module_XX.pdf (10 PDFs)
  - output/book/Kubernetes_GitOps_Mastery_ELI5.pdf (1 Master Mega-PDF)
  - web/data/lessons.json (Structured JSON for Web Companion Reader)
"""

import os
import sys
import json
import subprocess
from pathlib import Path

BASE_DIR = Path("/Users/aliturgutbozkurt/Desktop/k8s")
MODULES_DATA_DIR = BASE_DIR / "modules_data"
CONTENT_DIR = BASE_DIR / "content"
OUTPUT_DIR = BASE_DIR / "output"
WEB_DIR = BASE_DIR / "web"

sys.path.insert(0, str(MODULES_DATA_DIR))
import mod01_docker, mod02_k8s_basics, mod03_workloads, mod04_networking, mod05_storage_security
import mod06_k9s, mod07_openshift, mod08_operators, mod09_flux_gitops, mod10_github_actions

MODULES = [
    mod01_docker.MODULE,
    mod02_k8s_basics.MODULE,
    mod03_workloads.MODULE,
    mod04_networking.MODULE,
    mod05_storage_security.MODULE,
    mod06_k9s.MODULE,
    mod07_openshift.MODULE,
    mod08_operators.MODULE,
    mod09_flux_gitops.MODULE,
    mod10_github_actions.MODULE,
]

def sanitize_typst_string(s: str) -> str:
    # Escape quotes and brackets properly for Typst
    return s.replace('\\', '\\\\').replace('"', '\\"')

def generate_lesson_typ(m: dict, l: dict) -> str:
    lang = "bash"
    if "apiVersion" in l['spring_code'] or "kind:" in l['spring_code']:
        lang = "yaml"
    elif "public class" in l['spring_code'] or "@RestController" in l['spring_code'] or "@Service" in l['spring_code']:
        lang = "java"
    elif "FROM" in l['spring_code']:
        lang = "dockerfile"
    elif "services:" in l['spring_code']:
        lang = "yaml"

    takeaways_typ = ""
    for item in l['takeaways']:
        tr_item = item[0].replace('"', '\\"')
        en_item = item[1].replace('"', '\\"')
        takeaways_typ += f'    ("{tr_item}", "{en_item}"),\n'

    content = f'''#import "/template.typ": *

#show: doc => setup_book(title: "Ders {l['num']}: {l['title_tr']}", doc)

#lesson_header(
  {l['num']},
  "{l['title_tr']}",
  "{l['title_en']}",
  "{m['title_tr']}",
  "{m['title_en']}"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]\
      #v(3pt)
      {l['eli5_tr']}
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]\
      #v(3pt)
      #text(fill: rgb("334155"))[{l['eli5_en']}]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]\
      #v(3pt)
      {l['deep_tr']}
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]\
      #v(3pt)
      #text(fill: rgb("334155"))[{l['deep_en']}]
    ]
  )
]

#spring_box[
```{lang}
{l['spring_code']}
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]\
      #v(3pt)
      {l['warning_tr']}
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]\
      #v(3pt)
      #text(fill: rgb("78350f"))[{l['warning_en']}]
    ]
  )
]

#takeaways_box((
{takeaways_typ}))
'''
    return content

def generate_module_typ(m: dict) -> str:
    content = f'''#import "/template.typ": *

#show: doc => setup_book(title: "Bölüm {m['id']}: {m['title_tr']}", doc)

#module_cover(
  {m['id']},
  "{m['title_tr']}",
  "{m['title_en']}",
  "{m['desc_tr']}",
  "{m['desc_en']}"
)

'''
    for l in m['lessons']:
        filename = f"lesson_{l['num']:02d}.typ"
        content += f'#include "{filename}"\n#v(16pt)\n\n'
    return content

def generate_master_book_typ() -> str:
    content = '''#import "/template.typ": *

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
'''
    for m in MODULES:
        content += f'''
#module_cover(
  {m['id']},
  "{m['title_tr']}",
  "{m['title_en']}",
  "{m['desc_tr']}",
  "{m['desc_en']}"
)

'''
        for l in m['lessons']:
            rel_path = f"/content/{m['dir']}/lesson_{l['num']:02d}.typ"
            content += f'#include "{rel_path}"\n#v(14pt)\n\n'

    content += '''
#pagebreak()
#v(40pt)
#align(center)[
  #rect(fill: rgb("0f172a"), radius: 10pt, inset: (x: 24pt, y: 32pt), width: 90%)[
    #text(size: 24pt, fill: rgb("38bdf8"), weight: "bold")[🎓 TEBRİKLER! / CONGRATULATIONS!]\
    #v(10pt)
    #text(size: 14pt, fill: white)[60 Derslik Büyük Bulut-Yerel Yolculuğu Başarıyla Tamamladınız!]\
    #v(6pt)
    #text(size: 11pt, fill: rgb("94a3b8"))[You have successfully conquered all 60 lessons of the Cloud-Native Masterclass!]\
    #v(20pt)
    #line(length: 60%, stroke: 1pt + rgb("3b82f6"))
    #v(15pt)
    #text(size: 10pt, fill: rgb("cbd5e1"))[
      Docker • Kubernetes • OpenShift • k9s • Operators • FluxCD • GitHub Actions • Java Spring Boot
    ]
  ]
]
'''
    return content

def generate_web_json():
    data = {
        "title_tr": "Aptala Anlatır Gibi Kubernetes & GitOps",
        "title_en": "Explain Like I'm 5: Kubernetes & GitOps Masterclass",
        "description": "60 Ders • 10 Bölüm • Çift Dilli (TR & EN) • Java Spring Boot",
        "modules": MODULES
    }
    web_data_dir = WEB_DIR / "data"
    web_data_dir.mkdir(parents=True, exist_ok=True)
    with open(web_data_dir / "lessons.json", "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    with open(web_data_dir / "lessons.js", "w", encoding="utf-8") as f:
        f.write("window.LESSONS_DATA = " + json.dumps(data, ensure_ascii=False) + ";\n")
    print(f"Exported web data to {web_data_dir / 'lessons.json'} and lessons.js")

def write_all_typst_files():
    CONTENT_DIR.mkdir(parents=True, exist_ok=True)
    for m in MODULES:
        mod_dir = CONTENT_DIR / m['dir']
        mod_dir.mkdir(parents=True, exist_ok=True)
        for l in m['lessons']:
            lesson_typ = generate_lesson_typ(m, l)
            lesson_path = mod_dir / f"lesson_{l['num']:02d}.typ"
            with open(lesson_path, "w", encoding="utf-8") as f:
                f.write(lesson_typ)
        
        module_typ = generate_module_typ(m)
        module_path = mod_dir / f"module_{m['id']:02d}.typ"
        with open(module_path, "w", encoding="utf-8") as f:
            f.write(module_typ)
    
    book_typ = generate_master_book_typ()
    with open(BASE_DIR / "book.typ", "w", encoding="utf-8") as f:
        f.write(book_typ)
    print("All Typst source files generated successfully!")

def compile_typst(src: Path, out: Path) -> bool:
    out.parent.mkdir(parents=True, exist_ok=True)
    cmd = [
        "typst", "compile",
        "--root", str(BASE_DIR),
        str(src),
        str(out)
    ]
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode != 0:
        print(f"Error compiling {src.name}: {res.stderr}")
        return False
    return True

def compile_all_pdfs():
    (OUTPUT_DIR / "individual").mkdir(parents=True, exist_ok=True)
    (OUTPUT_DIR / "modules").mkdir(parents=True, exist_ok=True)
    (OUTPUT_DIR / "book").mkdir(parents=True, exist_ok=True)

    print("\n--- 1. Compiling Master Book PDF ---")
    book_src = BASE_DIR / "book.typ"
    book_out = OUTPUT_DIR / "book" / "Kubernetes_GitOps_Mastery_ELI5.pdf"
    if compile_typst(book_src, book_out):
        size_kb = book_out.stat().st_size / 1024
        print(f"✔ Master Book PDF created: {book_out.name} ({size_kb:.1f} KB)")

    print("\n--- 2. Compiling 10 Module PDFs ---")
    for m in MODULES:
        mod_src = CONTENT_DIR / m['dir'] / f"module_{m['id']:02d}.typ"
        mod_out = OUTPUT_DIR / "modules" / f"module_{m['id']:02d}_{m['dir']}.pdf"
        if compile_typst(mod_src, mod_out):
            size_kb = mod_out.stat().st_size / 1024
            print(f"✔ Module {m['id']} PDF: {mod_out.name} ({size_kb:.1f} KB)")

    print("\n--- 3. Compiling 60 Individual Lesson PDFs ---")
    success_count = 0
    for m in MODULES:
        for l in m['lessons']:
            les_src = CONTENT_DIR / m['dir'] / f"lesson_{l['num']:02d}.typ"
            les_out = OUTPUT_DIR / "individual" / f"lesson_{l['num']:02d}.pdf"
            if compile_typst(les_src, les_out):
                success_count += 1
    print(f"✔ Compiled {success_count}/60 Individual Lesson PDFs successfully!")

if __name__ == "__main__":
    print("🚀 Starting Complete Curriculum Generation...")
    write_all_typst_files()
    generate_web_json()

    mode = sys.argv[1] if len(sys.argv) > 1 else "--all"
    if mode == "--all":
        compile_all_pdfs()
    elif mode == "--book":
        book_src = BASE_DIR / "book.typ"
        book_out = OUTPUT_DIR / "book" / "Kubernetes_GitOps_Mastery_ELI5.pdf"
        compile_typst(book_src, book_out)
    elif mode == "--modules":
        for m in MODULES:
            mod_src = CONTENT_DIR / m['dir'] / f"module_{m['id']:02d}.typ"
            mod_out = OUTPUT_DIR / "modules" / f"module_{m['id']:02d}_{m['dir']}.pdf"
            compile_typst(mod_src, mod_out)
    elif mode == "--json-only":
        pass
