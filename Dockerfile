# Typesense 30.2, official image pinned by digest (multi-arch index).
FROM typesense/typesense:30.2@sha256:610f2d34b1f93d00762869da2c67736775e5798d19a2c8b91b014b8a0cc1e110

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh && mkdir -p /data

EXPOSE 8108
ENTRYPOINT ["/usr/local/bin/start.sh"]
