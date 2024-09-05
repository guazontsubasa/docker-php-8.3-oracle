# Apache-php-8.3-oci8 + SSL

## servidor para desarrollo 
Crear docker-compose.yml, y una carpeta ssl dentro con los certificados con nombre 'server.crt' y 'server.key' creados con mkcert o openssl

```
#Ejemplo de docker-compose.yml:

services:
   app:
     container_name: server
     image: guazontsubasa/server
     restart: always
     ports:
       - 80:80
       - 443:443
     volumes:
       - ../:/var/www/html/public
       - ./ssl:/etc/apache2/ssl/cert
```

Para crear certificados SSL autofirmados (server.crt y server.key) tanto en Windows como en Ubuntu, puedes usar OpenSSL. Vamos a ver cómo hacerlo en ambos sistemas operativos:
En Windows:

1. Primero, necesitas instalar OpenSSL si aún no lo tienes. Puedes descargarlo e instalarlo desde https://slproweb.com/products/Win32OpenSSL.html
2. Una vez instalado, abre una terminal de PowerShell o CMD como administrador.
3. Navega al directorio donde quieres crear los certificados.
4. Ejecuta los siguientes comandos:

```
# Generar una clave privada
openssl genrsa -out server.key 2048

# Crear una solicitud de firma de certificado (CSR)
openssl req -new -key server.key -out server.csr

# Generar un certificado autofirmado
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
```
Durante el proceso, se te pedirá que ingreses información para el certificado (país, estado, organización, etc.). Puedes dejar en blanco los campos que no sean relevantes presionando Enter.

En Ubuntu:

1. OpenSSL generalmente viene preinstalado en Ubuntu. Si no lo tienes, puedes instalarlo con:
```
sudo apt-get update
sudo apt-get install openssl
```
2. Abre una terminal.
3. Navega al directorio donde quieres crear los certificados.
4. Ejecuta los siguientes comandos:
```
# Generar una clave privada
openssl genrsa -out server.key 2048

# Crear una solicitud de firma de certificado (CSR)
openssl req -new -key server.key -out server.csr

# Generar un certificado autofirmado
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
```
Al igual que en Windows, se te pedirá que ingreses información para el certificado.

Después de ejecutar estos comandos, tendrás los archivos server.key (tu clave privada) y server.crt (tu certificado autofirmado) en el directorio actual.



