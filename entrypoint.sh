#!/bin/sh
set -e

CERT_DIR=/var/lib/pasarguard/certs
CERT=$CERT_DIR/ssl_cert.pem
KEY=$CERT_DIR/ssl_key.pem
mkdir -p "$CERT_DIR"

if [ ! -f "$CERT" ] || [ ! -f "$KEY" ]; then
  echo ">> در حال ساخت گواهی SSL برای پنل (فقط یک بار)..."
  openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
    -keyout "$KEY" -out "$CERT" -subj "/CN=panel" 2>/dev/null
fi

echo ">> در حال آپدیت جدول‌های دیتابیس (migration)..."
python -m alembic upgrade head

echo ">> در حال ساخت کد ورود موقت مالک (فقط ۵ دقیقه اعتبار داره؛ توی همین Deploy Logs پیداش کن)..."
python pasarguard-cli.py generate-temp-key || true

echo ">> استارت پنل..."
exec python main.py
