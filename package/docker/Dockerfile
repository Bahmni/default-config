FROM alpine:3.18.3

COPY openmrs /etc/bahmni_config/openmrs
COPY masterdata /etc/bahmni_config/masterdata
COPY openelis /etc/bahmni_config/openelis
COPY offline /etc/bahmni_config/offline

COPY package/docker/start.sh start.sh
RUN chmod +x start.sh
CMD ["./start.sh"]