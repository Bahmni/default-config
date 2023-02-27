FROM alpine

COPY openmrs /etc/bahmni_config/openmrs
COPY openelis /etc/bahmni_config/openelis
COPY offline /etc/bahmni_config/offline
COPY configuration /etc/bahmni_config/masterdata/configuration

COPY package/docker/start.sh start.sh
RUN chmod +x start.sh
CMD ["./start.sh"]