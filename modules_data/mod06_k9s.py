# -*- coding: utf-8 -*-
"""
Module 6: k9s — Terminalin Matrix Arayüzü (Lessons 31-36)
"""

MODULE = {
    "id": 6,
    "dir": "module_06_k9s",
    "title_tr": "k9s — Terminalin Matrix Arayüzü",
    "title_en": "k9s — The Terminal Matrix Cockpit",
    "desc_tr": "Terminalden ayrılmadan jet uçağı kokpiti gibi K8s yönetimi: k9s kısayolları, canlı log takibi, tek tuşla shell girişi, port yönlendirme ve özel eklentiler.",
    "desc_en": "Supersonic terminal cluster navigation: k9s shortcuts, live log streaming, one-key shell access, port-forwarding, and custom productivity plugins.",
    "lessons": [
        {
            "num": 31,
            "title_tr": "k9s Nedir? Neden kubectl'den 10 Kat Daha Hızlıdır?",
            "title_en": "Introducing k9s: Why It's 10x Faster Than Raw kubectl",
            "eli5_tr": "Sürekli `kubectl get pods -n coffee-shop`, `kubectl describe pod ...`, `kubectl logs ...` yazmak, her kelime için daktiloda harf aramak gibidir. `k9s` ise terminalinizde açılan gerçek zamanlı, renkli bir Matrix kokpitidir! Tek bir tuşa basarak kümeyi izler, hatalı pod'ları kırmızı renkle anında yakalarsınız. Fareye gerek yok, parmaklarınız klavyede dans eder!",
            "eli5_en": "Typing `kubectl get pods -n my-ns`, `kubectl describe pod`, and `kubectl logs` 50 times an hour feels like writing code on an antique typewriter. `k9s` is a real-time, terminal-native supersonic fighter jet HUD! Red bars instantly scream at crashed pods; green glows mean peace. Zero mouse required—your fingers fly purely on muscle memory!",
            "deep_tr": "k9s, Go diliyle yazılmış Terminal User Interface (TUI) tabanlı bir Kubernetes yönetim aracıdır. API Server ile kalıcı Watch Stream (gRPC/HTTP2) bağlantısı kurar. Her komutta API'ye yeni baştan sorgu atan `kubectl`'in aksine, k9s kümedeki olayları (events) anlık olarak yerel bellek önbelleğinde günceller. Bu da sorgu gecikmesini sıfıra indirir. `~/.kube/config` dosyanızı otomatik olarak okur.",
            "deep_en": "k9s is a high-performance terminal UI (TUI) written in Go. Rather than issuing stateless polling queries like `kubectl`, k9s establishes long-lived HTTP/2 Watch streams with the API Server, dynamically synchronizing state directly into its internal cache. It leverages your standard `~/.kube/config`, inheriting existing RBAC tokens and multi-cluster contexts seamlessly.",
            "spring_code": """# macOS Homebrew ile k9s kurulumu:
brew install derailed/k9s/k9s

# k9s'i başlatmak (Tek kelime yeterli!):
k9s

# Belirli bir namespace ile başlatmak:
k9s -n coffee-shop --context eli5-cluster""",
            "warning_tr": "k9s arka planda API Server ile sürekli canlı bağlantı (watch) kurduğu için, binlerce pod'un olduğu devasa kurumsal kümelerde çalıştırırken API Server üzerindeki CPU yükünü artırabilir. Çok büyük kümelerde `--all-namespaces` yerine spesifik namespace ile açmak önerilir.",
            "warning_en": "In colossal enterprise clusters with tens of thousands of pods, watching all namespaces simultaneously can put strain on the API Server. Open k9s directly in a target namespace (`k9s -n target-ns`).",
            "takeaways": [
                ("k9s, CLI verimliliğini görsel bir arayüz hızında birleştiren terminal aracıdır.", "Combines the speed of the command line with the clarity of a visual dashboard."),
                ("Gerçek zamanlı watch stream sayesinde değişiklikler anında ekranda parlar.", "Displays real-time cluster state transitions instantly without polling."),
                ("Mevcut kubeconfig ve RBAC yetkilerini aynen miras alır.", "Inherits your active kubeconfig credentials, contexts, and RBAC restrictions automatically.")
            ]
        },
        {
            "num": 32,
            "title_tr": "k9s Kısayolları ve Filtreleme: Işınlanma Sanatı",
            "title_en": "k9s Navigation & Filtering: The Art of Instant Teleportation",
            "eli5_tr": "k9s'te gezinmek bir büyü gibidir! `:` tuşuna basıp `po` yazarsanız pod'lar listelenir, `deploy` yazarsanız deployment'lar açılır, `ns` yazarsanız tüm ortamlar önünüze dökülür. Arama yapmak için sadece `/` tuşuna basıp `coffee` yazmanız yeterlidir; aradığınız pod saniyesinde karşınızda!",
            "eli5_en": "Navigating k9s feels like instant teleportation! Press `:` and type `po` for pods, `deploy` for deployments, `svc` for services, `ns` for namespaces. To search, press `/`, type `coffee`, and press enter. You've filtered down 5,000 pods to your exact Spring Boot microservice in 0.5 seconds!",
            "deep_tr": "k9s Vim benzeri tuş kombinasyonlarıyla (Keybindings) çalışır. Temel komutlar: `:` (Komut moduna geçer; K8s kısayol adlarını destekler: `:po`, `:svc`, `:ing`, `:cm`, `:sec`, `:cr`), `/` (Filtreleme modu; regex aramayı destekler), `ctrl-a` (Tüm namespace'leri tek ekranda gösterir), `0` (Sadece varsayılan namespace), `esc` (Bir önceki ekrana veya filtreyi temizlemeye yarar). Ok tuşları veya `j`/`k` ile listelerde gezinilir.",
            "deep_en": "k9s embraces Vim navigation paradigms. Primary bindings: `:` activates command mode (accepting shortnames like `:po`, `:svc`, `:deploy`, `:ing`, `:cm`), `/` activates regex-capable text filtering, `ctrl-a` aggregates all namespaces, `esc` cancels filters or navigates backward. Standard `j`/`k` or arrow keys move row cursors effortlessly.",
            "spring_code": """# En Çok Kullanılan k9s Komut Modu Kısayolları:
:po        # Pod listesi
:deploy    # Deployment listesi
:svc       # Service listesi
:ing       # Ingress listesi
:ns        # Namespace seçici
:nodes     # Küme düğümleri ve kaynak durumları
:context   # K8s kümeleri arasında geçiş yap!""",
            "warning_tr": "Bazen filtreleme yapıp (`/coffee`) aramayı açık unuttuğunuzda ekrandaki diğer pod'lar kaybolmuş gibi gelebilir. Panik yapmayın, `esc` tuşuna basarak filtreyi sıfırlayın!",
            "warning_en": "If resources seem to have vanished, check if a filter is active! Press `esc` twice to clear the `/` search filter and reveal all workloads.",
            "takeaways": [
                ("`:` tuşu ile herhangi bir K8s kaynağına 1 saniyede ulaşılır.", "The `:` key provides instant access to any standard or custom K8s resource type."),
                ("`/` tuşu ile canlı filtreleme yapılarak hedef pod saniyeler içinde bulunur.", "The `/` key enables blazing fast real-time search across massive pod fleets."),
                ("`ctrl-a` tüm namespace'leri tek pencerede toplayarak genel bakış sunar.", "`ctrl-a` expands your viewport across all namespaces simultaneously.")
            ]
        },
        {
            "num": 33,
            "title_tr": "Canlı Log İnceleme, Arama ve Pod İçine Giriş (`s` ve `l`)",
            "title_en": "Live Log Tailing, Searching & One-Key Shelling (`s` and `l`)",
            "eli5_tr": "Gece saat 02:00'de üretimde bir hata çıktı! Spring Boot pod'unuzun loglarına bakmak için uzun uzun komut yazmazsınız. Pod'un üzerine gelin ve `l` tuşuna basın: Renkli loglar anında şelale gibi akar! Hata mı arıyorsunuz? `/Exception` yazın, bulsun. Pod'un içine girip dosyaları kontrol etmek mi istiyorsunuz? `s` tuşuna basın; anında pod'un içindeki terminaldesiniz!",
            "eli5_en": "Midnight production outage! You don't fumble with lengthy CLI commands. Move the cursor over your Spring Boot pod and press `l`: colorized log streams cascade down your screen! Need to locate a bug? Press `/Exception` to jump straight to the stack trace. Need to verify environment configs? Press `s`: boom, you have an interactive shell inside the container!",
            "deep_tr": "`l` (Logs) tuşu: K8s API'si üzerinden streaming log soketi açar. `0` tuşuyla logları baştan (head) sarabilir, `w` ile satır kaydırmayı (wrap) açıp kapatabilir, `t` ile zaman damgalarını (timestamps) ekleyebilirsiniz. `s` (Shell) tuşu: Pod içinde sırasıyla `bash`, `sh`, `/bin/sh` arar ve interaktif TTY oturumu başlatır (`kubectl exec -it`). Non-root çalışan konteynerlerde de sorunsuz çalışır.",
            "deep_en": "Pressing `l` (Logs) opens a streaming WebSocket log channel with colorized ANSI output, log wrapping toggle (`w`), and timestamp prefixes (`t`). Pressing `s` (Shell) launches an interactive TTY execution session into the container (`kubectl exec -it`), iteratively attempting `/bin/bash`, `/bin/sh`, and `/bin/ash` under the container's configured user identity.",
            "spring_code": """# k9s Log ve Shell Kısayol Tuşları:
l         # Seçili pod'un canlı loglarını aç
p         # Önceki çöken pod'un loglarını gör (Previous Crashed Logs!)
s         # Pod içine terminal (Shell) aç
d         # Describe pod detaylarını aç (Event'leri görmek için!)
e         # Pod veya Deployment YAML'ını canlıda düzenle (Edit)""",
            "warning_tr": "Eğer pod çökmüş ve `CrashLoopBackOff` durumundaysa, `l` tuşuna bastığınızda boş ekran görebilirsiniz. Çöken pod'un son nefesindeki hatayı görmek için mutlaka `p` (Previous Logs) tuşuna basmalısınız!",
            "warning_en": "If a pod is caught in `CrashLoopBackOff`, normal logs might be empty! Press `p` to view PREVIOUS logs and read the fatal exception that killed the container.",
            "takeaways": [
                ("`l` tuşu pod loglarını anlık akış olarak ekrana getirir.", "`l` streams live application logs with zero configuration."),
                ("`p` tuşu az önce çöken konteynerin hata günlüğünü (previous log) yakalar.", "`p` inspects the historical logs of terminated, crashed container instances."),
                ("`s` tuşu tek dokunuşla pod'un içine SSH benzeri güvenli shell bağlantısı kurar.", "`s` instantly opens an interactive shell session into the running container.")
            ]
        },
        {
            "num": 34,
            "title_tr": "Terminalden Port-Forwarding ve Pod Restart (`shift-f` ve `ctrl-d`)",
            "title_en": "Port-Forwarding and Workload Restarts (`shift-f` and `ctrl-d`)",
            "eli5_tr": "K8s içindeki kapalı bir Spring Boot servisini laptopunuzun tarayıcısında test etmek istiyorsunuz. Normalde karmaşık komutlar gerekir. k9s'te pod'un üzerine gelip `shift-f` tuşuna basarsınız; '8080:8080 tüneli açılsın mı?' diye sorar, enter'a basarsınız ve tarayıcınızda `localhost:8080` anında çalışır! Pod saçmaladı mı? `ctrl-d` tuşuna basın, anında öldürün; Deployment yenisini doğursun!",
            "eli5_en": "You want to test a strictly private internal Spring Boot pod on your laptop browser. Normally this takes annoying commands. In k9s, highlight the pod and press `shift-f`: it prompts 'Port 8080:8080?', press Enter, and your laptop is tunneled to the pod! Pod acting weird? Highlight it, press `ctrl-d` to kill it, and watch the Deployment instantly hatch a clean replacement!",
            "deep_tr": "`shift-f` (Port-Forward): k9s yerel makinenizde bir TCP soketi açar ve K8s SPDY/HTTP2 port-forward API'si üzerinden hedef pod'un portuna tünel kurar. Aktif tünelleri görmek için `:pf` komutu yazılır. `ctrl-d` (Delete): Pod'u siler (`kubectl delete pod`). Eğer pod bir Deployment tarafından yönetiliyorsa, ReplicaSet saniyesinde yeni bir pod yaratır. Bir Deployment'ı kesintisiz yeniden başlatmak içinse Deployment ekranında `r` (Restart) tuşuna basılır.",
            "deep_en": "Pressing `shift-f` invokes the SPDY/HTTP/2 port-forwarding subsystem, tunneling localhost sockets directly to internal pod ports without requiring NodePorts or Ingress. Type `:pf` to manage active forwards. Pressing `ctrl-d` deletes the highlighted resource. For Deployments, pressing `r` initiates a graceful `rollout restart`.",
            "spring_code": """# k9s Tünel ve Yeniden Başlatma Kısayolları:
shift-f   # Port-forward tüneli aç
:pf       # Tüm açık tünelleri listele ve yönet
r         # Deployment üzerinde: Rolling Restart başlat!
ctrl-d    # Seçili Pod'u öldür (Kill / Delete)""",
            "warning_tr": "Üretim ortamında (Production) yanlışlıkla bir Pod veya Deployment üzerindeyken `ctrl-d` tuşuna basmamak için k9s'in salt-okunur modunu (`k9s --readonly`) kullanabilirsiniz!",
            "warning_en": "Prevent accidental deletions in production clusters by launching k9s in read-only mode: `k9s --readonly`.",
            "takeaways": [
                ("`shift-f` ile iç servisler saniyeler içinde localhost'a tünellenir.", "`shift-f` creates frictionless localhost port-forward tunnels in seconds."),
                ("`:pf` menüsü tüm açık tünelleri görsel olarak izlemeyi ve kapatmayı sağlar.", "`:pf` provides centralized monitoring and teardown of active tunnels."),
                ("Deployment üzerindeyken `r` tuşuna basmak kesintisiz rolling restart tetikler.", "Pressing `r` on a Deployment triggers an instant rolling restart.")
            ]
        },
        {
            "num": 35,
            "title_tr": "Kaynak İzleme: Renkli CPU ve Bellek Göstergeleriyle Darboğaz Avı",
            "title_en": "Resource Monitoring: Visual CPU & Memory Bottleneck Hunting",
            "eli5_tr": "Sisteminiz neden yavaşladı? Hangi Spring Boot pod'u sunucunun tüm enerjisini emiyor? k9s pod listesinde CPU ve Bellek sütunlarını yeşil, sarı ve kırmızı renkli barlarla gösterir. Bir pod %95 belleğe yaklaştığında bar kıpkırmızı parlar: 'Beni kurtarın, birazdan OOMKilled olacağım!' diye bağırır. Dedektif gibi darboğazı yakalarsınız!",
            "eli5_en": "Why is the API suddenly sluggish? Which rogue Spring Boot pod is devouring server energy? k9s displays intuitive percentage bars next to CPU and Memory columns. When a pod reaches 95% RAM utilization, its gauge turns violently red, screaming: 'Help, I'm about to get OOMKilled!' You catch performance leaks like a master detective!",
            "deep_tr": "k9s, Metrics Server API (`metrics.k8s.io`) ile entegre çalışır. Kaynak kullanımını iki farklı referansa göre gösterir: 1) `%REQUEST` (Pod'un rezerve ettiği taban kaynak kullanım yüzdesi), 2) `%LIMIT` (Pod'un tavan sınırına olan uzaklığı). Eğer bir Java pod'unun bellek barı sürekli artıyor ve hiç azalmıyorsa bu bir JVM Memory Leak (bellek sızıntısı) işaretidir. Node ekranında (`:nodes`) sunucu bazlı darboğazlar da anında izlenir.",
            "deep_en": "k9s parses metrics directly from `metrics.k8s.io`. It dynamically evaluates utilization against both `%REQUEST` (guaranteed reservation) and `%LIMIT` (hard ceiling). If a Java pod's memory gauge climbs monotonically without garbage collection dips, you are observing a live JVM memory leak before OOMKilled evictions occur.",
            "spring_code": """# k9s Ekranında CPU ve Bellek Göstergeleri:
# NAME             READY  STATUS   RESTARTS  CPU%  MEM%  CPU/REQ  MEM/REQ
# coffee-app-7b8c  1/1    Running  0          12%   84%   120m     430Mi
# (MEM% barı sarıya/kırmızıya dönüyorsa dikkat!)""",
            "warning_tr": "Eğer CPU ve MEM sütunlarında `n/a` veya boşluk görüyorsanız, kümenizde `metrics-server` kurulu değildir! Minikube'da `minikube addons enable metrics-server` komutuyla aktif edebilirsiniz.",
            "warning_en": "If CPU and MEM columns display `n/a`, your cluster lacks `metrics-server`! Enable it locally via `minikube addons enable metrics-server`.",
            "takeaways": [
                ("Renkli göstergeler sayesinde bellek darboğazları kriz çıkmadan fark edilir.", "Color-coded utilization bars spot resource exhaustion before crashes occur."),
                ("JVM bellek sızıntıları (memory leaks) canlıda grafiksel olarak yakalanır.", "JVM heap leaks are easily identified by observing continuous memory increases."),
                ("`:nodes` komutuyla sunucuların genel doluluk oranları denetlenir.", "The `:nodes` view shows host capacity and identifies overloaded hardware.")
            ]
        },
        {
            "num": 36,
            "title_tr": "k9s Eklentileri ve Özel Kısayollar (Custom Plugins)",
            "title_en": "k9s Custom Plugins & Supercharged Productivity Hotkeys",
            "eli5_tr": "Uçağınızın kokpitine kendi özel kırmızı butonlarınızı eklemek! Örneğin tek bir tuşa (`ctrl-j`) basarak Spring Boot pod'unun içinden anında 'Java Thread Dump' almak veya log seviyesini tek tuşla `DEBUG` moduna geçirmek istiyorsunuz. k9s Plugins mekanizmasıyla istediğiniz özel komutu bir tuşa bağlayabilirsiniz!",
            "eli5_en": "Adding custom red fire-buttons to your fighter jet cockpit! What if you could press `ctrl-j` on any pod to immediately dump JVM thread traces, or press `ctrl-b` to toggle Spring Boot log levels to `DEBUG`? k9s Plugins allow you to bind any custom shell or kubectl command to custom hotkeys!",
            "deep_tr": "k9s eklentileri `~/.config/k9s/plugins.yaml` dosyasında tanımlanır. Bir eklenti şunları içerir: 1) `shortCut` (Tetikleyici tuş; örn: `shift-t`), 2) `scopes` (Hangi kaynakta geçerli; örn: `po`, `deploy`), 3) `command` ve `args` (Çalıştırılacak script). k9s çalışma anında `$NAMESPACE`, `$NAME`, `$POD`, `$CONTAINER` gibi ortam değişkenlerini komuta otomatik aktarır.",
            "deep_en": "k9s plugins are defined declaratively in `~/.config/k9s/plugins.yaml`. Each plugin specifies a `shortCut`, target `scopes` (e.g. `pods`), and an executable `command` with arguments. k9s dynamically interpolates contextual variables like `$NAMESPACE`, `$NAME`, and `$CONTAINER` at runtime.",
            "spring_code": """# ~/.config/k9s/plugins.yaml Örneği:
plugin:
  # Spring Boot Pod'undan Tek Tuşla Java Thread Dump Al!
  jvm-thread-dump:
    shortCut: Shift-T
    description: JVM Thread Dump
    scopes:
      - pods
    command: kubectl
    background: false
    confirm: false
    args:
      - exec
      - -it
      - -n
      - $NAMESPACE
      - $NAME
      - --
      - jcmd
      - "1"
      - Thread.print""",
            "warning_tr": "Eklentiler yerel bilgisayarınızdaki araçları (jcmd, curl, jq) çağırır. Eklentinin çalışabilmesi için ilgili aracın bilgisayarınızda veya konteyner içinde yüklü olması gerekir.",
            "warning_en": "Custom plugins invoke local or in-pod CLI binaries. Ensure required binaries (like `jcmd` or `jq`) exist before triggering custom hotkeys.",
            "takeaways": [
                ("k9s eklentileri günlük rutin bakım görevlerini tek tuşa indirir.", "Custom plugins compress repetitive operational routines into single keypresses."),
                ("Çalışma anı değişkenleri ($NAMESPACE, $NAME) dinamik komut yönetimini sağlar.", "Runtime context variables enable dynamic, context-aware command executions."),
                ("Takım standartları için ortak `plugins.yaml` dosyaları paylaşılabilir.", "Teams can standardize and share unified `plugins.yaml` across engineering orgs.")
            ]
        }
    ]
}
