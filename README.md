# BitNet-Termux 📱🤖

Run Microsoft's 1-bit Large Language Models (LLMs) natively on Android using Termux. 

BitNet is a revolutionary architecture that uses extremely low precision (1.58-bit) to achieve high-speed inference on mobile CPUs with minimal battery drain.

## 🚀 Quick Install

To install everything automatically, copy and paste this command into your Termux:

```bash
pkg install curl -y && curl -sL https://raw.githubusercontent.com/catamsp/Bitnet-Termux/refs/heads/main/install_bitnet.sh | bash
```

## 🛠️ Features
- **Zero-Dependency Inference:** Optimized for ARM64 (Android) CPUs.
- **Low RAM Usage:** Run 3B models comfortably on 4GB-8GB devices.
- **Fast Generation:** 1-bit kernels provide a 2x-4x speedup over standard models.
- **Interactive Chat:** Built-in support for conversational mode.

## 📦 Supported Models

| Model | Size | Description |
| :--- | :--- | :--- |
| **0.7B Large** | ~400MB | Ultra-fast, ideal for simple tasks. |
| **2.0B Official** | ~1.2GB | Microsoft's flagship 1-bit model. Stable & Balanced. |
| **3.0B Falcon3** | ~2.1GB | Best for creative writing and instruction following. |
| **8.0B Llama3** | ~4.8GB | Deep reasoning (Requires 8GB+ RAM). |

## 💬 Manual Usage Steps

If you have already installed BitNet and want to run it again later:

1. **Enter the directory:**
   ```bash
   cd ~/BitNet
   ```

2. **Activate the environment:**
   ```bash
   source venv/bin/activate
   ```

3. **Start Chatting:**
   ```bash
   # Replace the model path with the one you downloaded
   python run_inference.py -m models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf -p "Hi!" -cnv
   ```

### Command Options:
- `-t 4`: Set CPU threads (use more for speed, less for battery).
- `-n 256`: Set the maximum number of tokens to generate.
- `-temp 0.7`: Control creativity (0.1 = factual, 1.0 = creative).

## ⚠️ Requirements
- **Termux** (Version 0.118+ from F-Droid recommended).
- **Free Space:** 3GB to 8GB depending on the model.
- **RAM:** 4GB minimum (8GB recommended for Llama3).

## 📄 Credits
- [Microsoft BitNet](https://github.com/microsoft/BitNet) for the official implementation.
- [llama.cpp](https://github.com/ggerganov/llama.cpp) for the inference backend.
