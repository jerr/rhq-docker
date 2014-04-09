#Dockerfile for RHQ 4.11.0 

FROM fedora:20

MAINTAINER Garik Khachikyan <gkhachik@redhat.com>

ENV RHQ_VERSION 4.11.0-SNAPSHOT

# install missing commands
#RUN yum -y update --skip-broken
RUN yum -y install wget unzip expect spawn java-1.7.0-openjdk-devel postgresql-server

# Init postgres service
RUN su -l postgres -c "/usr/bin/initdb --pgdata='/var/lib/pgsql/data' --auth='ident'" \  >> "/var/lib/pgsql/initdb.log" 2>&1 < /dev/null

# Edit postgres config 
RUN  sed 's/ident/trust/'  /var/lib/pgsql/data/pg_hba.conf > pg_hba.conf

# Replace old properties file with the new one
RUN cp -u pg_hba.conf /var/lib/pgsql/data/pg_hba.conf

# Start postgres service, create rhqadmin role and rhq db
RUN expect -c ' spawn su -l postgres -c " pg_ctl start " ; expect -re   "pg_log" {send \"\r\"; exp_continue } }';\
 ps -aux; expect -c ' spawn createuser -h 127.0.0.1 -p 5432 -U postgres -S -D -R -P  rhqadmin;    expect -re "Enter"  { send \"\r\"; exp_continue }  "Enter" { send \"\r\"; exp_continue } ';\
 createdb -h 127.0.0.1 -p 5432 -U postgres -O rhqadmin rhq;


# Download rhq-server-4.11.0.zip from sourceforge
## TODO ## RUN wget -q http://sourceforge.net/projects/rhq/files/rhq/rhq-4.10/rhq-server-4.10.0.zip -O /opt/rhq-server-4.10.0.zip 2>&1 >/dev/null
RUN wget -q http://hudson.qa.jboss.com/hudson/view/RHQ/job/rhq-master-gwt-locales/1035/artifact/modules/enterprise/server/appserver/target/rhq-server-${RHQ_VERSION}.zip -O /opt/rhq-server-${RHQ_VERSION}.zip 2>&1 >/dev/null

# Unzip rhq-server-4.11.0.zip
RUN unzip /opt/rhq-server-${RHQ_VERSION}.zip -d /opt 2>&1 >/dev/null

# Change jboss.bind.address
RUN sed -i 's/rhq.server.management.password=/rhq.server.management.password=35c160c1f841a889d4cda53f0bfc94b6/;s/jboss.bind.address=/jboss.bind.address=0.0.0.0/;s/rhq.storage.nodes=/rhq.storage.nodes=127.0.0.1/' /opt/rhq-server-${RHQ_VERSION}/bin/rhq-server.properties

ENV RHQ_SERVER_JAVA_EXE_FILE_PATH /usr/bin/java

# Print out java version
RUN java -version; ls -l /etc/alternatives/java; rpm -qa | grep openjdk

EXPOSE 7080
WORKDIR ./opt/rhq-server-${RHQ_VERSION}/bin

ENTRYPOINT expect -c ' spawn su -l postgres -c " pg_ctl restart -m fast " ; expect -re   "pg_log" {send \"\r\"; exp_continue } }' ;\
su root -c '/opt/rhq-server-${RHQ_VERSION}/bin/rhqctl install  --agent-preference="127.0.0.1"';\
su root -c '/opt/rhq-server-${RHQ_VERSION}/bin/rhqctl start';\
/bin/bash
