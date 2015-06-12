FROM ubuntu:14.04

ADD init.groovy /tmp/WEB-INF/init.groovy
ADD ec2provision /bin/ec2provision
ADD ec2terminate /bin/ec2terminate
ADD filetrim /bin/filetrim
ADD r53a /bin/r53a
ADD s3copy /bin/s3copy
ADD s3download /bin/s3download
ADD s3latest /bin/s3latest
ADD s3trim /bin/s3trim
ADD s3upload /bin/s3upload

RUN echo "1.574" > .lts-version-number && \
apt-get update && apt-get install -y wget git curl zip && \
apt-get update && apt-get install -y --no-install-recommends openjdk-7-jdk && \
apt-get update && apt-get install -y maven=3.0.5-1 ant=1.9.3-2build1 ruby rbenv make && \
apt-get install -y python-pip python-dev build-essential && \
pip install --upgrade pip && \
pip install --upgrade virtualenv && \
pip install --upgrade boto && \
pip install --upgrade ansible && \
cd /tmp/ && curl -O -L http://www.opscode.com/chef/install.sh && \
cd /tmp/ && sudo /bin/sh install.sh && \
wget -q -O - http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key | sudo apt-key add - && \
echo deb http://pkg.jenkins-ci.org/debian-stable binary/ >> /etc/apt/sources.list && \
apt-get update && apt-get install -y jenkins build-essential && \
mkdir -p /var/jenkins_home && chown -R jenkins /var/jenkins_home && \
cd /tmp && zip -g /usr/share/jenkins/jenkins.war WEB-INF/init.groovy && \
cd /tmp/ && curl -O -L http://www.opscode.com/chef/install.sh && \
cd /tmp/ sh install.sh && \
chmod 755 /bin/ec2provision && \
chmod 755 /bin/ec2terminate && \
chmod 755 /bin/filetrim && \
chmod 755 /bin/r53a && \
chmod 755 /bin/s3copy && \
chmod 755 /bin/s3download && \
chmod 755 /bin/s3latest && \
chmod 755 /bin/s3trim && \
chmod 755 /bin/s3upload

USER jenkins

# VOLUME /var/jenkins_home - bind this in via -v if you want to make this persistent.
ENV JENKINS_HOME /var/jenkins_home

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

CMD ["/usr/bin/java",  "-jar",  "/usr/share/jenkins/jenkins.war"]
