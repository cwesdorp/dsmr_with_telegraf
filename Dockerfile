FROM debian:bookworm-20230202-slim AS builder

RUN apt-get update && \
    apt-get install -y python3=3.11.\*  python3-pip=23.\* wget pgp && \
    # see https://github.com/influxdata/telegraf#package-repository
    # prepare installation of telegraf
    wget -q https://repos.influxdata.com/influxdata-archive_compat.key && \
    echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null && \
    # add user
    groupadd telegraf && \
    useradd -g telegraf -m -s /bin/false telegraf

USER telegraf

RUN cd /home/telegraf && \
    pip install --user dsmr_parser==0.33

FROM debian:bookworm-20230202-slim

# Copy the influxdata file create in builder
COPY --from=builder /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg

RUN apt-get update && \
    apt-get install -y ca-certificates && \
    echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | tee /etc/apt/sources.list.d/influxdata.list && \
    apt-get update && \
    apt-get install -y python3=3.11.\* telegraf=1.25.\* && \
    usermod -d /home/telegraf telegraf

# copy the telegraf config file
COPY --chown=root:root telegraf.conf /etc/telegraf/telegraf.conf
COPY --chown=root:root output_stdout.conf /etc/telegraf/telegraf.d/

# copy the dsmr dependencies and the script for telegraf
COPY --from=builder /home/telegraf/.local /home/telegraf/.local
COPY dsmr.py /home/telegraf

USER telegraf

CMD ["/usr/bin/telegraf", "--config", "/etc/telegraf/telegraf.conf", "--config-directory", "/etc/telegraf/telegraf.d"]
