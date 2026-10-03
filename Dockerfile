FROM pasarguard/panel:latest

# openssl برای ساخت خودکار گواهی SSL لازمه (بدونش پنل فقط روی localhost بایند میشه)
RUN apt-get update && apt-get install -y --no-install-recommends openssl \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV UVICORN_HOST=0.0.0.0 \
    UVICORN_PORT=8000 \
    UVICORN_SSL_CERTFILE=/var/lib/pasarguard/certs/ssl_cert.pem \
    UVICORN_SSL_KEYFILE=/var/lib/pasarguard/certs/ssl_key.pem \
    UVICORN_SSL_CA_TYPE=private \
    ALLOWED_ORIGINS=* \
    ENABLE_RECORDING_NODES_STATS=True

ENTRYPOINT ["/entrypoint.sh"]
