FROM alpine:3.15

RUN apk update && \
    apk add --no-cache python3 py3-pip 

RUN python3 -m pip install --no-cache dsmr_parser
COPY ./dsmr.py /root

CMD ["python3", "/root/dsmr.py"]
