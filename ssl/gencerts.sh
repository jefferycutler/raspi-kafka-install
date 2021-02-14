#!/bin/bash
#######################################################################
#  Certificate Generator for Pi Kafka nodes
#    This script will generated certificates for client server and 
#    clients in a kafka cluster.  We are using self signed certificates
#######################################################################

# Set the certificate common name 
SRV_COMMON_NAME="Kafka-Server"
CLI_COMMON_NAME="Kafka-Client"
VALID_DAYS=365

# generate key store passwords for server and client
SRVPASS=$(tr -dc A-Za-z0-0 </dev/urandom | head -c 16 ; echo '')
echo $SRVPASS > srvpasswd.txt

CLIPASS=$(tr -dc A-Za-z0-0 </dev/urandom | head -c 16 ; echo '')
echo $CLIPASS > clipasswd.txt

# clean up if this is not the first run
rm -f *.jks
rm -f server-*

######################################################################
# Part 1 - Create the server certificate

# create the new keyout
openssl req -new -newkey rsa:4096 -days $VALID_DAYS -x509 -subj "/CN=${SRV_COMMON_NAME}" -keyout server-key -out server-cert -nodes

## use key tool to create a keystore, the jks file
keytool -genkey -keystore kafka.server.keystore.jks -validity $VALID_DAYS -storepass $SRVPASS -keypass $SRVPASS -dname "CN=${SRV_COMMON_NAME}" -storetype pkcs12 -keyalg RSA

## create signing request file
keytool -keystore kafka.server.keystore.jks -certreq -file server-file -storepass $SRVPASS -keypass $SRVPASS

## sign the cert
openssl x509 -req -CA server-cert -CAkey server-key -in server-file -out server-signed -days $VALID_DAYS -CAcreateserial -passin pass:$SRVPASS

## create trusted store and import signed cert
keytool -keystore kafka.server.truststore.jks -alias $SRV_COMMON_NAME -import -file server-cert -storepass $SRVPASS -keypass $SRVPASS -noprompt -keyalg RSA

## import public ca certificate in the keystore file
keytool -keystore kafka.server.keystore.jks -alias $SRV_COMMON_NAME -import -file server-cert -storepass $SRVPASS -keypass $SRVPASS -noprompt -keyalg RSA

## import private ca certiciate in the keystore 
keytool -keystore kafka.server.keystore.jks -import -file server-signed -storepass $SRVPASS -keypass $SRVPASS -noprompt -keyalg RSA

######################################################################
# Part 2 - Create the client certificate

# create the client trust store and import the server cert
keytool -keystore kafka.client.truststore.jks -alias $SRV_COMMON_NAME -import -file server-cert -storepass $CLIPASS -keypass $CLIPASS -noprompt -keyalg RSA

# create the keystore and client key pair
keytool -genkey -keystore kafka.client.keystore.jks -validity $VALID_DAYS -storepass $CLIPASS -keypass $CLIPASS -dname "CN=${CLI_COMMON_NAME}" -alias $CLI_COMMON_NAME -storetype pkcs12 -keyalg RSA

# create a request to sign the certificate
keytool -keystore kafka.client.keystore.jks -certreq -file client-sign-request -alias $CLI_COMMON_NAME -storepass $CLIPASS -keypass $CLIPASS -keyalg RSA

# signing authority (that's us!) signs the certificate
openssl x509 -req -CA server-cert -CAkey server-key -in client-sign-request -out client-signed -days $VALID_DAYS -CAcreateserial -passin pass:$SRVPASS

# import the signed cert into the client keystore 
keytool -keystore kafka.client.keystore.jks -alias $SVR_COMMON_NAME -import -file server-cert -storepass $CLIPASS -keypass $CLIPASS -noprompt -keyalg RSA

# import the client's signed certificate
keytool -keystore kafka.client.keystore.jks -import -file client-signed -alias $CLI_COMMON_NAME -storepass $CLIPASS -keypass $CLIPASS -noprompt -keyalg RSA

