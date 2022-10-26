yum install java-17* -y
useradd tomcat
cd /tmp
mkdir -p /opt/tomcat
mkdir -p /var/tomcat
wget -O /tmp/tomcat9.zip https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.68/bin/apache-tomcat-9.0.68.zip
unzip /tmp/tomcat9.zip -d /opt/tomcat
mkdir -p /opt/tomcat/apache-tomcat-9.0.68/tmp
chmod 755 /opt/tomcat/apache-tomcat-9.0.68/bin/*.sh
chown -R tomcat:tomcat /opt/tomcat
chown tomcat:tomcat /var/tomcat/