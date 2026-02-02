#!/bin/bash

# KasmVNC Startup Script
# Configures user/password authentication based on ENV variables

set -e

# Default values
DEFAULT_USER="kasm_user"
DEFAULT_PASSWORD="password"

# Get values from ENV or use defaults
KASM_USER="${KASM_USER:-$DEFAULT_USER}"
KASM_PASSWORD="${KASM_PASSWORD:-$DEFAULT_PASSWORD}"

echo "============================================"
echo "KasmVNC Startup Configuration"
echo "============================================"
echo "User: $KASM_USER"
echo "Password: [hidden]"
echo "============================================"

# Create user if it doesn't exist
if ! id "$KASM_USER" &>/dev/null; then
    echo "Creating user: $KASM_USER"
    useradd -m -s /bin/bash "$KASM_USER"
    # Add user to necessary groups
    usermod -a -G audio,video,render "$KASM_USER"
fi

# Setup KasmVNC password using vncpasswd
KASM_PASSWORD_FILE="/home/$KASM_USER/.kasmpasswd"

if [ ! -f "$KASM_PASSWORD_FILE" ]; then
    echo "Setting up VNC password for $KASM_USER..."
    echo "$KASM_PASSWORD" | vncpasswd -u "$KASM_USER" -w "$KASM_PASSWORD_FILE"
    chown "$KASM_USER:$KASM_USER" "$KASM_PASSWORD_FILE"
    chmod 600 "$KASM_PASSWORD_FILE"
    echo "VNC password configured successfully"
else
    echo "VNC password already configured, skipping..."
fi

# Start KasmVNC server as the user
echo "Starting KasmVNC server..."
su - "$KASM_USER" -c "vncserver :1 -geometry 1920x1080 -depth 24" || echo "VNC server might already be running"

# Get the VNC display number and show access URLs
echo ""
echo "============================================"
echo "KasmVNC is now running!"
echo "============================================"
echo "Access URLs:"
echo "  HTTP:  http://localhost:6901"
echo "  HTTPS: https://localhost:6902"
echo "  VNC:   vnc://localhost:5901"
echo ""
echo "Login credentials:"
echo "  Username: $KASM_USER"
echo "  Password: $KASM_PASSWORD"
echo "============================================"
