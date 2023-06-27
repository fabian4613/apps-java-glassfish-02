FROM ubuntu:latest
MAINTAINER "Carlos Fabian Pavia - DGSISAN - GCBA"

# Establecer la zona horaria de forma directa
ENV TZ=America/Argentina/Buenos_Aires
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Configurar el idioma
RUN apt-get update && apt-get install -y locales
RUN locale-gen es_AR.UTF-8
RUN update-locale LANG=es_AR.UTF-8

# Instalar paquetes requeridos de Linux
RUN apt-get update && apt-get -y install wget unzip

# Instalar Java 8
RUN apt-get update && apt-get install -y openjdk-8-jdk

# Configurar variables de entorno
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin

# Instalar GlassFish 5
RUN wget -q --no-cookies --no-check-certificate "https://www.eclipse.org/downloads/download.php?file=/glassfish/glassfish-5.1.0.zip&mirror_id=1"
RUN mv /glassfish-5.1-0.zip /usr/local; cd /usr/local; unzip glassfish-5.1-0.zip ; rm -f glassfish-5.1-0.zip ; cd /

# Configurar variables de entorno
ENV GF_HOME /usr/local/glassfish5
ENV PATH $PATH:$GF_HOME/bin

# Permitir que Derby se inicie como un daemon (usado por algunas aplicaciones Java EE, como Pet Store)
RUN echo "grant { permission java.net.SocketPermission \"localhost:1527\", \"listen\"; };" >> $JAVA_HOME/jre/lib/security/java.policy

# Agregar nuestro script de inicio de GF
ADD start-gf.sh /usr/local/bin/start-gf.sh
RUN chmod 755 /usr/local/bin/start-gf.sh

# PUERTOS PARA EL ADMIN PORT, HTTP LISTENER-1 PORT, HTTPS LISTENER PORT, PURE JMX CLIENTS PORT, MESSAGE QUEUE PORT, IIOP PORT, IIOP/SSL PORT, IIOP/SSL PORT WITH MUTUAL AUTHENTICATION
#EXPOSE 4848 8080 8181 8686 7676 3700 3820 3920
# ElasticBeanstalk solo expone el primer puerto
EXPOSE 8080 4848

# Desplegar una aplicación en el contenedor
# Ejemplo a continuación - utiliza el servicio de autodespliegue de GlassFish
ADD https://github.com/fabian4613/apps-java-glassfish-02/blob/main/prueba2grupo1.war?raw=true /usr/local/glassfish5/glassfish/domains/domain1/autodeploy/prueba2grupo1.war
ADD https://github.com/fabian4613/apps-java-glassfish-02/blob/main/prueba2grupo2.war?raw=true /usr/local/glassfish5/glassfish/domains/domain1/autodeploy/prueba2grupo2.war

ENTRYPOINT ["/usr/local/bin/start-gf.sh"]
