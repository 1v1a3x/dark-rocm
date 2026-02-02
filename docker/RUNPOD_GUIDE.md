# RunPod Deployment Guide

## Quick Start

1. **Build the base image:**
```bash
docker build -f Dockerfile.rocm_base -t rocm-kasm:base .
```

2. **Push to RunPod registry** (after building)
```bash
docker tag rocm-kasm:base <your-runpod-registry>/rocm-kasm:base
docker push <your-runpod-registry>/rocm-kasm:base
```

3. **Deploy on RunPod** with KasmVNC enabled:
   - Image: `<your-runpod-registry>/rocm-kasm:base`
   - Environment Variables:
     - `START_KASMVNC=1`
     - `KASM_USER=your_username` (optional, default: kasm_user)
     - `KASM_PASSWORD=your_password` (optional, default: password)
   - Exposed Ports: `6901`, `6902`, `5901`
   - Volume Mounts: Add any persistent storage if needed

## RunPod Configuration

### Container Image
Use your pushed image: `<your-runpod-registry>/rocm-kasm:base`

### Environment Variables
```yaml
START_KASMVNC: "1"
KASM_USER: "admin"      # Optional: default is "kasm_user"
KASM_PASSWORD: "secure123"  # Optional: default is "password"
```

### Exposed Ports
- `6901/tcp` - HTTP KasmVNC access
- `6902/tcp` - HTTPS KasmVNC access
- `5901/tcp` - VNC protocol access

### Volume Mounts (Optional)
If you need persistent storage:
```yaml
/data: /app/data  # Mount persistent storage
```

## Accessing the Desktop

After your pod starts:

1. Find the pod's public URL/IP in RunPod dashboard
2. Open browser: `http://<pod-ip>:6901`
3. Login with your credentials
4. You'll have full GNOME desktop access in your browser!

## GPU Usage

This image includes full RocM support for AMD GPUs:
- PyTorch for RocM
- Triton for custom kernels
- Flash Attention optimized for AMD GPUs

Note: vLLM is built separately in Dockerfile.rocm using this base image.

## Audio Support

Browser audio is enabled via PulseAudio. You can:
- Play system sounds
- Use web browsers with audio
- Record audio if microphone is passed through

## Troubleshooting

### KasmVNC not starting
- Ensure `START_KASMVNC=1` is set
- Check logs in RunPod dashboard
- Verify ports 6901/6902/5901 are exposed

### Login fails
- Check `KASM_USER` and `KASM_PASSWORD` environment variables
- Try default credentials: `kasm_user` / `password`

### GPU not detected
- Ensure you selected an AMD GPU instance on RunPod
- Check `rocm-smi` command works in container
- Verify RocM drivers are loaded on the host

## Local Testing

Before deploying to RunPod, test locally:

```bash
# Build and test
docker build -f Dockerfile.rocm_base -t test-rocm .

# Run with KasmVNC
docker run -it --rm \
  -p 6901:6901 \
  -p 6902:6902 \
  -p 5901:5901 \
  --device=/dev/kfd --device=/dev/dri \
  -e START_KASMVNC=1 \
  -e KASM_USER=admin \
  -e KASM_PASSWORD=test123 \
  test-rocm

# Access at http://localhost:6901
```

Note: GPU features won't work without actual AMD GPU hardware, but you can test the desktop environment.
