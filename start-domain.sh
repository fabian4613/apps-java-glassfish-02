#!/bin/bash

# Iniciar el dominio
asadmin start-domain

# Cambiar la contraseña del administrador
echo 'AS_ADMIN_PASSWORD=adminadmin' > /tmp/glassfishpwd
asadmin --user=admin --passwordfile=/tmp/glassfishpwd change-admin-password --domain_name domain1
rm /tmp/glassfishpwd

# Detener el dominio
asadmin stop-domain --domain_name domain1

# Iniciar el dominio nuevamente en modo verbose
asadmin start-domain --verbose
