#!/bin/bash

# Iniciar el dominio
asadmin start-domain

# Cambiar la contraseña del administrador
echo 'AS_ADMIN_PASSWORD=adminadmin' > /tmp/glassfishpwd
asadmin --user=admin --passwordfile=/tmp/glassfishpwd change-admin-password --domain_name domain1
rm /tmp/glassfishpwd

# Detener el dominio
asadmin stop-domain --domain_name domain1

# Clonar el repositorio de GitHub
git clone https://github.com/fabian4613/apps-java-glassfish-02.git /tmp/apps-java-glassfish-02

# Copiar los archivos WAR a la carpeta autodeploy
cp /tmp/apps-java-glassfish-02/*.war $GLASSFISH_HOME/glassfish/domains/domain1/autodeploy/

# Eliminar el repositorio clonado
rm -rf /tmp/apps-java-glassfish-02

# Iniciar el dominio nuevamente en modo verbose
asadmin start-domain --verbose
