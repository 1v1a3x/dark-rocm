# RocM Base Image with KasmVNC

This Dockerfile extends base RocM image with KasmVNC for browser-based desktop access.

**Note**: This is a base image (`rocm-kasm:base`) used by Dockerfile.rocm to build vLLM with desktop access.

## Features

- **Desktop Environment**: GNOME with Ubuntu desktop
- **Browser Access**: KasmVNC on port 6901 (HTTP) and 6902 (HTTPS)
- **Audio Support**: PulseAudio for browser-based audio
- **Authentication**: Configurable user/password via environment variables

## Default Credentials

- **Username**: `kasm_user`
- **Password**: `password`

## Environment Variables

### Override Default Credentials

```bash
-e KASM_USER=myuser
-e KASM_PASSWORD=mypassword
```

### Enable KasmVNC on Container Start

```bash
-e START_KASMVNC=1
```

When `START_KASMVNC=0` (default), the container starts with `/bin/bash` shell.

## Usage Examples

### RunPod Example

```bash
# Enable KasmVNC with custom credentials
docker run -d \
  -p 6901:6901 \
  -p 6902:6902 \
  -p 5901:5901 \
  -e START_KASMVNC=1 \
  -e KASM_USER=admin \
  -e KASM_PASSWORD=securepass \
  rocm-kasm:base
```

### Access the Desktop

After starting the container:

1. Open browser and navigate to: `http://<host-ip>:6901`
2. Login with credentials:
   - Username: `kasm_user` (or custom `KASM_USER`)
   - Password: `password` (or custom `KASM_PASSWORD`)

### Local Testing

```bash
# Build image
docker build -f Dockerfile.rocm_base -t rocm-kasm:base .

# Run with KasmVNC enabled
docker run -it --rm \
  -p 6901:6901 \
  -p 6902:6902 \
  -p 5901:5901 \
  -e START_KASMVNC=1 \
  rocm-kasm:base
```

## Ports

- `6901` - HTTP access to KasmVNC
- `6902` - HTTPS access to KasmVNC
- `5901` - VNC protocol access

## Notes

- The image includes minimal GNOME desktop (ubuntu-desktop-minimal) to reduce image size
- Audio support is enabled via PulseAudio
- User is automatically added to necessary groups (audio, video, render)
- KasmVNC server starts on display :1 with resolution 1920x1080

## Security

⚠️ **Warning**: When exposing KasmVNC to the internet, ensure proper authentication and consider using a reverse proxy with SSL termination. The default credentials should be changed for production use.
