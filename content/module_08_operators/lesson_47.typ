#import "/template.typ": *

#show: doc => setup_book(title: "Ders 47: Java ile Operator Yazımı: Java Operator SDK (JOSDK) Temelleri", doc)

#lesson_header(
  47,
  "Java ile Operator Yazımı: Java Operator SDK (JOSDK) Temelleri",
  "Building Operators in Java: Java Operator SDK (JOSDK)",
  "Kubernetes Operators — Kendi Akıllı Robotunu Kodla",
  "Kubernetes Operators — Build Your Own Robot SRE"
)

#eli5_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("1e40af"), size: 9pt)[🇹🇷 TÜRKÇE]      #v(3pt)
      Dünyadaki herkes size 'Kubernetes operatörleri sadece Go (Golang) ile yazılır' diye yalan söyleyebilir. İnanmayın! Bir Java ve Spring Boot geliştiricisi olarak, kendi en iyi bildiğiniz dilde K8s operatörü yazabilirsiniz. Java Operator SDK (JOSDK) sayesinde tek yapmanız gereken bir Java arayüzünü (`Reconciler<SpringBootApp>`) uygulamak ve içine kodunuzu yazmaktır!
    ],
    [
      #text(weight: "bold", fill: rgb("1d4ed8"), size: 9pt)[🇬🇧 ENGLISH]      #v(3pt)
      #text(fill: rgb("334155"))[The tech world might tell you that Kubernetes operators can ONLY be coded in Go. Don't believe the myth! As a Java and Spring Boot engineer, you can build production-grade operators in your favorite language. With Java Operator SDK (JOSDK), you simply implement a clean Java interface (`Reconciler<SpringBootApp>`) and write standard object-oriented code!]
    ]
  )
]

#deep_dive_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("334155"), size: 9pt)[🇹🇷 TEKNİK DETAY]      #v(3pt)
      Java Operator SDK (JOSDK), Fabric8 Kubernetes Client üzerine kurulmuş modern bir framework'tür. Quarkus veya Spring Boot ile entegre çalışır. `@ControllerConfiguration` anotasyonuyla CRD'ye bağlanır. Reconciler arayüzü tek bir metod içerir: `UpdateControl<SpringBootApp> reconcile(SpringBootApp resource, Context<SpringBootApp> context)`. JOSDK arka planda thread havuzunu, Watch eventlerini, retry mekanizmalarını ve exponential backoff algoritmalarını otomatik yönetir.
    ],
    [
      #text(weight: "bold", fill: rgb("475569"), size: 9pt)[🇬🇧 TECHNICAL CORE]      #v(3pt)
      #text(fill: rgb("334155"))[Java Operator SDK (JOSDK) is a high-performance framework built atop Fabric8 Kubernetes Client, integrating seamlessly with Spring Boot and Quarkus. By implementing `Reconciler<T>` and annotating with `@ControllerConfiguration`, JOSDK manages informers, work queues, event filtering, and exponential backoff retry semantics transparently.]
    ]
  )
]

#spring_box[
```java
// Java Operator Reconciler İskeleti:
@ControllerConfiguration(name = "springbootapp-controller")
public class SpringBootAppReconciler implements Reconciler<SpringBootApp> {

    private final KubernetesClient client;

    public SpringBootAppReconciler(KubernetesClient client) {
        this.client = client;
    }

    @Override
    public UpdateControl<SpringBootApp> reconcile(SpringBootApp resource, Context<SpringBootApp> context) {
        String appName = resource.getMetadata().getName();
        String targetImage = resource.getSpec().getImage();
        int replicas = resource.getSpec().getReplicas();

        // Akıllı Robot Mantığı: Deployment var mı kontrol et, yoksa yarat!
        reconcileDeployment(resource, appName, targetImage, replicas);

        return UpdateControl.noUpdate();
    }
}
```
]

#warning_box[
  #grid(
    columns: (1fr, 1fr),
    gutter: 14pt,
    [
      #text(weight: "bold", fill: rgb("b45309"), size: 9pt)[🇹🇷 AMAN DİKKAT]      #v(3pt)
      Java ile operatör yazarken Docker imajınızın bellek tüketimine dikkat edin. Standart bir HotSpot JVM operatör için 200MB RAM harcayabilir. GraalVM Native Image derlemesi yaparak operatörünüzü 20MB RAM ile 0.01 saniyede açılan bir ikili dosyaya dönüştürebilirsiniz!
    ],
    [
      #text(weight: "bold", fill: rgb("92400e"), size: 9pt)[🇬🇧 WATCH OUT]      #v(3pt)
      #text(fill: rgb("78350f"))[Standard JVM runtime footprints hover around 200MB. For optimal lightweight operator footprints, compile your Java operator with GraalVM Native Image.]
    ]
  )
]

#takeaways_box((
    ("Java geliştiricileri Go öğrenmek zorunda kalmadan yerel K8s operatörleri yazabilir.", "Java engineers can build high-performance K8s operators without mastering Go."),
    ("Fabric8 client K8s API'sindeki tüm nesneleri tip güvenli (type-safe) Java sınıflarına çevirir.", "Fabric8 provides type-safe Java POJOs for all native and custom K8s resources."),
    ("Quarkus ve Spring Boot entegrasyonu modern geliştirme konforu sunar.", "Seamless integration with Spring Boot enables dependency injection and metrics."),
))
