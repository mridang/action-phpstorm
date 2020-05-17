FROM mridang/intellijidea:2020.1
RUN apt-get update -y
RUN apt-get install -y xsltproc
COPY problems.xslt /problems.xslt
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
