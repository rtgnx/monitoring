FROM rg.nl-ams.scw.cloud/funcscwunixdh2hnob5c/octopus:release as ocp

FROM rg.nl-ams.scw.cloud/rtgnx/void:release

COPY --from=ocp /ocp /usr/local/bin/ocp


RUN xbps-install -Sy go git gettext loki prometheus tailscale
RUN git clone https://github.com/czerwonk/ping_exporter /tmp/ping_exporter
RUN cd /tmp/ping_exporter && go build -o /usr/local/bin/ping_exporter

COPY ./sv /etc/sv/
RUN find /etc/sv -type f -name 'run' | xargs chmod +x
# remove nanoklogd
RUN rm -f /var/service/nanoklogd

COPY ./etc /etc/

RUN ln -sf /etc/sv/startup /var/service/

