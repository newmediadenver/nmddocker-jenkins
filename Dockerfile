FROM phusion/baseimage:latest

ADD ec2provision /bin/ec2provision
ADD ec2terminate /bin/ec2terminate
ADD filetrim /bin/filetrim
ADD r53a /bin/r53a
ADD s3copy /bin/s3copy
ADD s3download /bin/s3download
ADD s3latest /bin/s3latest
ADD s3trim /bin/s3trim
ADD s3upload /bin/s3upload
ADD s3upload /bin/s3upload
ADD hosts /etc/ansible/hosts
ADD ec2.ini /etc/ansible/ec2.ini
ADD ansible.cfg /etc/ansible/ansible.cfg
RUN mkdir /etc/service/jenkins
ADD run /etc/service/jenkins/run

RUN chmod 755 /bin/ec2provision && chmod 755 /bin/ec2terminate && chmod 755 /bin/filetrim && chmod 755 /bin/r53a && chmod 755 /bin/s3copy && chmod 755 /bin/s3download && chmod 755 /bin/s3latest && chmod 755 /bin/s3trim && chmod 755 /bin/s3upload && chmod 755 /bin/s3upload && chmod 755 /etc/service/jenkins/run && curl -L http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key | sudo apt-key add - && echo deb http://pkg.jenkins-ci.org/debian-stable binary/ >> /etc/apt/sources.list && apt-get update && apt-get install -y git curl && apt-get install -y --no-install-recommends openjdk-7-jdk && apt-get install -y maven=3.0.5-1 ant=1.9.3-2build1 ruby rbenv make && apt-get install -y python-pip python-dev build-essential && curl -L http://www.opscode.com/chef/install.sh | bash && apt-get install -y jenkins && mkdir -p /var/jenkins_home && chown -R jenkins /var/jenkins_home
RUN pip install --upgrade pip
RUN pip install --upgrade virtualenv && pip install --upgrade boto  && pip install --upgrade ansible

USER root

# VOLUME /var/jenkins_home - bind this in via -v if you want to make this persistent.
ENV JENKINS_HOME /var/jenkins_home
EXPOSE 8080

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
