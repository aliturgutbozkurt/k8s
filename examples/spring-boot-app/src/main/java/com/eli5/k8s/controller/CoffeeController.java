package com.eli5.k8s.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.availability.ApplicationAvailability;
import org.springframework.boot.availability.AvailabilityChangeEvent;
import org.springframework.boot.availability.ReadinessState;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class CoffeeController {

    private final ApplicationEventPublisher eventPublisher;
    private final ApplicationAvailability availability;
    private final List<byte[]> memoryLeakList = new ArrayList<>();

    @Value("${app.message:Kubernetes is awesome!}")
    private String customMessage;

    @Value("${app.version:1.0.0}")
    private String version;

    public CoffeeController(ApplicationEventPublisher eventPublisher, ApplicationAvailability availability) {
        this.eventPublisher = eventPublisher;
        this.availability = availability;
    }

    @GetMapping("/coffee")
    public Map<String, Object> serveCoffee() {
        String podName = System.getenv().getOrDefault("HOSTNAME", "local-dev-machine");
        String podIp = "unknown";
        try {
            podIp = InetAddress.getLocalHost().getHostAddress();
        } catch (UnknownHostException ignored) {}

        return Map.of(
            "drink", "☕ Freshly Brewed Cloud Espresso",
            "message", customMessage,
            "version", version,
            "servedByPod", podName,
            "podIp", podIp,
            "readinessStatus", availability.getReadinessState().toString(),
            "timestamp", Instant.now().toString()
        );
    }

    // ELI5: K8s Readiness Probe Testi!
    // K8s bu pod'a trafik göndermeyi kesecek ama pod'u öldürmeyecek.
    @PostMapping("/chaos/break-readiness")
    public ResponseEntity<String> breakReadiness() {
        AvailabilityChangeEvent.publish(eventPublisher, this, ReadinessState.REFUSING_TRAFFIC);
        return ResponseEntity.ok("Readiness State: REFUSING_TRAFFIC! K8s Service will no longer send traffic to this Pod.");
    }

    @PostMapping("/chaos/recover")
    public ResponseEntity<String> recoverReadiness() {
        AvailabilityChangeEvent.publish(eventPublisher, this, ReadinessState.ACCEPTING_TRAFFIC);
        return ResponseEntity.ok("Readiness State: ACCEPTING_TRAFFIC! K8s Service resumed sending traffic.");
    }

    // ELI5: K8s OOMKilled (Out Of Memory) Testi!
    // Memory Limit aşılınca K8s Kubelet pod'u anında SIGKILL ile öldürür.
    @PostMapping("/chaos/oom-kill")
    public ResponseEntity<String> triggerMemoryLeak() {
        new Thread(() -> {
            while (true) {
                memoryLeakList.add(new byte[10 * 1024 * 1024]); // 10MB chunk
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ignored) {}
            }
        }).start();
        return ResponseEntity.ok("Memory leak triggered! Pod will be OOMKilled by Kubernetes shortly.");
    }
}
