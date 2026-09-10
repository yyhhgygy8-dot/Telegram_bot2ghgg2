#!/bin/sh
set -eu

PORT="${APP_PORT:-3000}"
SECRET="${FLASK_SECRET_KEY:-}"

mkdir -p /etc/wireguard /app/src/db /app/src/backups

# Generate a per-deployment secret if Orbit did not provide one.
if [ -n "$SECRET" ]; then
  sed -i "s#secret_key: .*#secret_key: \"$SECRET\"#" /app/src/config.yaml
elif grep -q 'change-me-in-orbit' /app/src/config.yaml; then
  GENERATED="$(python - <<'PY'
import secrets
print(secrets.token_urlsafe(32))
PY
)"
  sed -i "s#change-me-in-orbit#$GENERATED#" /app/src/config.yaml
fi

# Orbit exposes the web application port through APP_PORT.
sed -i "s/^  port: .*/  port: ${PORT}/" /app/src/config.yaml

# Redis is required by Flask-Limiter/cache.
redis-server --daemonize yes --bind 127.0.0.1 --protected-mode yes

# The original project expects a full Linux host for WireGuard/systemd.
# Orbit mode keeps the web panel running; actual WG interface management
# requires a host/container runtime with NET_ADMIN and WireGuard support.
export ORBIT_MODE="true"
exec python /app/src/app.py
