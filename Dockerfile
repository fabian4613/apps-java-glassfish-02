FROM adoptopenjdk:11-jdk-hotspot

# Instalar herramientas necesarias
RUN apt-get update && apt-get install -y curl unzip zip && rm -rf /var/lib/apt/lists/*

# Descargar y descomprimir GlassFish
RUN curl -L -o /tmp/glassfish-5.1.0.zip "https://www.eclipse.org/downloads/download.php?file=/glassfish/glassfish-5.1.0.zip&mirror_id=1" && \
    unzip /tmp/glassfish-5.1.0.zip -d /opt && \
    rm /tmp/glassfish-5.1.0.zip

# Establecer variables de entorno
ENV GLASSFISH_HOME=/opt/glassfish5
ENV PATH=$PATH:$GLASSFISH_HOME/bin

# Copiar el script de inicio
COPY start-domain.sh /opt/start-domain.sh

# Dar permisos de ejecución al script
RUN chmod +x /opt/start-domain.sh

# Puerto de administración
EXPOSE 4848 8080

# Ejecutar el script de inicio cuando se inicie el contenedor
CMD ["/opt/start-domain.sh"]
