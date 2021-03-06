FROM tomcat:8.0-jre8
MAINTAINER "M Rautenberg <rautenberg@uni-mainz.de>"

# remove preinstalled webapps 
RUN rm -fr /usr/local/tomcat/webapps/ROOT
RUN rm -fr /usr/local/tomcat/webapps/host-manager
RUN rm -fr /usr/local/tomcat/webapps/manager
RUN rm -fr /usr/local/tomcat/webapps/docs
RUN rm -fr /usr/local/tomcat/webapps/examples
RUN chmod 777 /usr/local

# copy and unzip the application war file
ADD target/weka_rs-0.5.0.war /usr/local/tomcat/webapps/ROOT.war
RUN unzip -d /usr/local/tomcat/webapps/ROOT /usr/local/tomcat/webapps/ROOT.war && rm -f /usr/local/tomcat/webapps/ROOT.war

# add openam certificat to tomcat's cert-store
RUN openssl s_client -showcerts -connect openam.in-silico.ch:443 </dev/null 2>/dev/null|openssl x509 -outform PEM > /usr/local/tomcat/in-silicoch.crt
RUN keytool -keystore /etc/ssl/certs/java/cacerts -keypass changeit -storepass changeit -noprompt -importcert -alias openam.in-silico.ch -file /usr/local/tomcat/in-silicoch.crt

# Expose the J Profiler agent
# Make sure to use the same JProfiler version as the one installed on your local machine by using the correct URL.
# (http://download-keycdn.ej-technologies.com/jprofiler/jprofiler_linux_{major_version}_{minor_version}.tar.gz)
RUN wget http://download-keycdn.ej-technologies.com/jprofiler/jprofiler_linux_9_2.tar.gz -P /tmp/ &&\
 tar -xzf /tmp/jprofiler_linux_9_2.tar.gz -C /usr/local &&\
 rm /tmp/jprofiler_linux_9_2.tar.gz
ENV JPAGENT_PATH="-agentpath:/usr/local/jprofiler9/bin/linux-x64/libjprofilerti.so=nowait"

# Create a non-priviledged user to run Tomcat
RUN useradd -u 501 -m -g root tomcat && chown -R tomcat:root /usr/local/tomcat

# Set file permissions for that user.
RUN chown -R tomcat:root /usr/local/tomcat

# run as that user
USER 501

EXPOSE 8849
EXPOSE 8080

# ENTRYPOINT sleep 5 && /usr/local/jprofiler9/bin/jpenable -g -p 8849