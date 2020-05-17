FROM mridang/jbstorm:latest
RUN apt-get update -y
RUN apt-get install -y xsltproc
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
