#import "/template.typ": *

#show: doc => setup_book(title: "Bölüm 4: Ağ, Keşif & Dış Dünyaya Açılma", doc)

#module_cover(
  4,
  "Ağ, Keşif & Dış Dünyaya Açılma",
  "Networking, Discovery & Ingress Routing",
  "Pod'lar arası dinamik IP kaosuna son: ClusterIP servisleri, NodePort, LoadBalancer, Ingress kontrolcüleri, CoreDNS ve ConfigMap/Secret yönetimi.",
  "Taming ephemeral IP chaos: ClusterIP services, NodePort, LoadBalancers, Ingress traffic cops, CoreDNS resolution, and externalizing configs via ConfigMaps & Secrets."
)

#include "lesson_19.typ"
#v(16pt)

#include "lesson_20.typ"
#v(16pt)

#include "lesson_21.typ"
#v(16pt)

#include "lesson_22.typ"
#v(16pt)

#include "lesson_23.typ"
#v(16pt)

#include "lesson_24.typ"
#v(16pt)

