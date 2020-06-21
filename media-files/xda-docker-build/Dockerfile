FROM openjdk:8u252-jdk
ENV XDA_HOME /opt
WORKDIR ${XDA_HOME}
ADD . $XDA_HOME
EXPOSE 7000/tcp
ENTRYPOINT /opt/xda/bin/xda.sh
