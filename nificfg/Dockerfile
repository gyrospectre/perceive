from apache/nifi
RUN        cd /opt/nifi/lib && \
           find . \
               ! -path './bootstrap*' \
               ! -name 'javax.servlet-api*.jar' \
               ! -name 'jcl-over-slf4j*.jar' \
               ! -name 'jetty-schemas*.jar' \
               ! -name 'jul-to-slf4j*.jar' \
               ! -name 'log4j-over-slf4j*.jar' \
               ! -name 'logback-classic*.jar' \
               ! -name 'logback-core*.jar' \
               ! -name 'nifi-api*.jar' \
               ! -name 'nifi-documentation*.jar' \
               ! -name 'nifi-framework-api*.jar' \
               ! -name 'nifi-framework-nar*.nar' \
               ! -name 'nifi-html-nar*.nar' \
               ! -name 'nifi-http-context-map-nar*.nar' \
               ! -name 'nifi-jetty-bundle*.nar' \
               ! -name 'nifi-kerberos-iaa-providers-nar*.nar' \
               ! -name 'nifi-ldap-iaa-providers-nar*.nar' \
               ! -name 'nifi-nar-utils*.jar' \
               ! -name 'nifi-properties*.jar' \
               ! -name 'nifi-provenance-repository-nar*.nar' \
               ! -name 'nifi-runtime*.jar' \
               ! -name 'nifi-scripting-nar*.nar' \
               ! -name 'nifi-site-to-site-reporting-nar*.nar' \
               ! -name 'nifi-ssl-context-service-nar*.nar' \
               ! -name 'nifi-standard-nar*.nar' \
               ! -name 'nifi-standard-services-api-nar*.nar' \
               ! -name 'nifi-update-attribute-nar*.nar' \
               ! -name 'slf4j-api*.jar' \
               ! -name 'nifi-elasticsearch*.nar' \
               ! -name 'nifi-kafka-*.nar' \
               -delete
COPY --chown=nifi:nifi flow.xml.gz /opt/nifi/nifi-1.6.0/conf/
