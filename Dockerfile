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

RUN chmod 755 /bin/ec2provision
RUN chmod 755 /bin/ec2terminate
RUN chmod 755 /bin/filetrim
RUN chmod 755 /bin/r53a
RUN chmod 755 /bin/s3copy
RUN chmod 755 /bin/s3download
RUN chmod 755 /bin/s3latest
RUN chmod 755 /bin/s3trim
RUN chmod 755 /bin/s3upload
RUN echo "1.574" > .lts-version-number
RUN apt-get update && apt-get install -y wget git curl zip
RUN apt-get update && apt-get install -y --no-install-recommends openjdk-7-jdk
RUN apt-get update && apt-get install -y maven=3.0.5-1 ant=1.9.3-2build1 ruby rbenv make
RUN apt-get install -y python-pip python-dev build-essential
RUN pip install --upgrade pip
RUN pip install --upgrade virtualenv
RUN pip install --upgrade boto
RUN pip install --upgrade ansible
RUN cd /tmp/ && curl -O -L http://www.opscode.com/chef/install.sh
RUN cd /tmp/ && sudo /bin/sh install.sh
RUN wget -q -O - http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key | sudo apt-key add -
RUN echo deb http://pkg.jenkins-ci.org/debian-stable binary/ >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y jenkins build-essential
RUN mkdir -p /var/jenkins_home && chown -R jenkins /var/jenkins_home
RUN cd /tmp && zip -g /usr/share/jenkins/jenkins.war WEB-INF/init.groovy
RUN cd /tmp/ && curl -O -L http://www.opscode.com/chef/install.sh
RUN cd /tmp/ sh install.sh

USER jenkins

# VOLUME /var/jenkins_home - bind this in via -v if you want to make this persistent.
ENV JENKINS_HOME /var/jenkins_home

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

CMD ["/usr/bin/java",  "-jar",  "/usr/share/jenkins/jenkins.war"]
