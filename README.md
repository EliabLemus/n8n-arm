# n8n for Raspberry Pi (ARM64)

Minimal Docker image of [n8n](https://n8n.io) built for ARM64 (e.g., Raspberry Pi 4) without Puppeteer to reduce image size.

## Features

- Alpine-based
- No Puppeteer (~400 MB lighter)
- Basic auth enabled by default (`admin:admin123`)
- Docker buildx + GitHub Actions CI

## Usage

```bash
docker run -it --rm -p 5678:5678 yourdockerhubuser/n8n-arm64
