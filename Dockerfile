FROM adoptopenjdk:11-jdk-hotspot

# Instalar GlassFish
ENV GLASSFISH_VERSION 5.1.0
ENV GLASSFISH_HOME /usr/local/glassfish5
RUN apt-get update && apt-get install -y curl unzip zip && rm -rf /var/lib/apt/lists/*
RUN curl -L -o /tmp/glassfish-5.1.0.zip "https://www.eclipse.org/downloads/download.php?file=/glassfish/glassfish-5.1.0.zip&mirror_id=1" && \
    unzip /tmp/glassfish-5.1.0.zip -d /usr/local && \
    rm -f /tmp/glassfish-5.1.0.zip

# Configurar GlassFish
ENV PATH $PATH:$GLASSFISH_HOME/bin
RUN echo 'AS_ADMIN_PASSWORD=adminadmin' > /tmp/glassfishpwd && \
    $GLASSFISH_HOME/bin/asadmin --user=admin --passwordfile=/tmp/glassfishpwd change-admin-password --domain_name domain1 && \
    $GLASSFISH_HOME/bin/asadmin start-domain && \
    $GLASSFISH_HOME/bin/asadmin --user=admin enable-secure-admin && \
    $GLASSFISH_HOME/bin/asadmin restart-domain && \
    $GLASSFISH_HOME/bin/asadmin create-service --name server --serviceuser admin && \
    rm /tmp/glassfishpwd

# Descargar archivos WAR desde el repositorio Git
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/fabian4613/apps-java-glassfish-02.git /tmp/apps-java-glassfish-02

# Autodespliegue de archivos WAR descargados
RUN cp /tmp/apps-java-glassfish-02/*.war $GLASSFISH_HOME/domains/domain1/autodeploy/

# Puerto de escucha
EXPOSE 8080 4848

# Comando para iniciar GlassFish
CMD $GLASSFISH_HOME/bin/asadmin start-domain --verbose
