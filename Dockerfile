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

# Cambiar la contraseña de administrador y luego iniciar y detener el dominio
RUN echo 'AS_ADMIN_PASSWORD=adminadmin' > /tmp/glassfishpwd && \
    asadmin start-domain && \
    asadmin --user=admin --passwordfile=/tmp/glassfishpwd change-admin-password --domain_name domain1 && \
    asadmin stop-domain && \
    rm /tmp/glassfishpwd

# Puerto de administración
EXPOSE 4848 8080

# Comando predeterminado para ejecutar GlassFish
CMD ["asadmin", "start-domain", "--verbose"]
