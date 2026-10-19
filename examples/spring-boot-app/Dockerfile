# ==============================================================================
# MULTI-STAGE DOCKERFILE: SPRING BOOT 3.x (LAYERED JAR + NON-ROOT DISTRO)
# ELI5: Önce mutfakta yemeği pişir (Build), sonra sadece tabağı servise çıkar (Runtime)!
# ==============================================================================

# STAGE 1: Derleme Aşaması (Build Stage)
FROM maven:3.9.6-eclipse-temurin-21-alpine AS builder
WORKDIR /workspace
COPY pom.xml .
# Bağımlılıkları önbelleğe al
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# STAGE 2: Layered JAR Ayıklama (Layer Extraction Stage)
# Spring Boot katmanları sayesinde değişmeyen kütüphaneler Docker önbelleğinde kalır!
FROM eclipse-temurin:21-jre-alpine AS extractor
WORKDIR /workspace
COPY --from=builder /workspace/target/*.jar app.jar
RUN java -Djarmode=layertools -jar app.jar extract

# STAGE 3: Üretim Aşaması (Ultra Hafif & Güvenli Runtime)
FROM eclipse-temurin:21-jre-alpine AS runner
WORKDIR /app

# Güvenlik: Asla ROOT kullanma! (OpenShift ve K8s en iyi pratiği)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser:appgroup

# Katmanları en az değişenden en çok değişene doğru sırayla kopyala
COPY --from=extractor /workspace/dependencies/ ./
COPY --from=extractor /workspace/spring-boot-loader/ ./
COPY --from=extractor /workspace/snapshot-dependencies/ ./
COPY --from=extractor /workspace/application/ ./

# JVM Konteyner Bellek Ayarları
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:+UseG1GC"
EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS org.springframework.boot.loader.launch.JarLauncher"]
