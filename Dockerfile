FROM docker

COPY run.sh /


RUN apk add --no-cache jq

ENTRYPOINT  ["/run.sh"]

CMD ["--help"]
