#!/data/data/com.termux/files/usr/bin/bash

# BitNet-Termux Auto-Installer
# Optimized for ARM64 Android Devices

echo -e "\e[1;34m[*] Starting BitNet-Termux Installation...\e[0m"

# 1. Update and Install Dependencies
echo -e "\e[1;32m[1/5] Installing system packages...\e[0m"
pkg update && pkg upgrade -y
pkg install git cmake ninja python clang binutils libandroid-spawn curl -y

# 2. Clone Repository
if [ ! -d "BitNet" ]; then
    echo -e "\e[1;32m[2/5] Cloning Microsoft BitNet repository...\e[0m"
    git clone --recursive https://github.com/microsoft/BitNet.git
fi
cd BitNet

# 3. Setup Python Environment
echo -e "\e[1;32m[3/5] Setting up Python virtual environment...\e[0m"
python -m venv venv
source venv/bin/activate
pip install --upgrade pip
# Install minimal requirements (ignoring broken packages like sentencepiece on Termux)
pip install numpy tqdm pyyaml

# 4. Build the Engine
echo -e "\e[1;32m[4/5] Compiling BitNet engine (this takes 2-5 mins)...\e[0m"
# Manually trigger codegen for ARM64 compatibility
python utils/codegen_tl1.py --model Llama3-8B-1.58-100B-tokens --BM 256,128,256,128 --BK 128,64,128,64 --bm 32,64,32,64
cmake -B build -DBITNET_ARM_TL1=OFF -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
cmake --build build --config Release -j $(nproc)

# 5. Model Downloader Menu
echo -e "\e[1;32m[5/5] Installation Complete! Choose a model to download:\e[0m"
echo "---------------------------------------------------------"
echo "1) 0.7B Large (Fastest, ~400MB)"
echo "2) 2.0B Microsoft Official (Recommended, ~1.2GB)"
echo "3) 3.0B Falcon3 Instruct (Great for Chat, ~2.1GB)"
echo "4) 8.0B Llama3 (Smartest, ~4.8GB - Needs 8GB+ RAM)"
echo "5) Skip for now"
echo "---------------------------------------------------------"
read -p "Enter choice [1-5]: " choice

mkdir -p models

case $choice in
    1)
        mkdir -p models/bitnet_b1_58-large
        echo "Downloading 0.7B model..."
        curl -L "https://huggingface.co/1bitLLM/bitnet_b1_58-large/resolve/main/ggml-model-i2_s.gguf?download=true" -o models/bitnet_b1_58-large/ggml-model-i2_s.gguf
        MODEL_PATH="models/bitnet_b1_58-large/ggml-model-i2_s.gguf"
        ;;
    2)
        mkdir -p models/BitNet-b1.58-2B-4T
        echo "Downloading 2.0B model..."
        curl -L "https://huggingface.co/microsoft/bitnet-b1.58-2B-4T-gguf/resolve/main/ggml-model-i2_s.gguf?download=true" -o models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf
        MODEL_PATH="models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf"
        ;;
    3)
        mkdir -p models/Falcon3-3B-Instruct-1.58bit
        echo "Downloading 3.0B model..."
        curl -L "https://huggingface.co/tiiuae/Falcon3-3B-Instruct-1.58bit-GGUF/resolve/main/ggml-model-i2_s.gguf?download=true" -o models/Falcon3-3B-Instruct-1.58bit/ggml-model-i2_s.gguf
        MODEL_PATH="models/Falcon3-3B-Instruct-1.58bit/ggml-model-i2_s.gguf"
        ;;
    4)
        mkdir -p models/Llama3-8B-1.58-100B-tokens
        echo "Downloading 8.0B model..."
        curl -L "https://huggingface.co/HF1BitLLM/Llama3-8B-1.58-100B-tokens/resolve/main/ggml-model-i2_s.gguf?download=true" -o models/Llama3-8B-1.58-100B-tokens/ggml-model-i2_s.gguf
        MODEL_PATH="models/Llama3-8B-1.58-100B-tokens/ggml-model-i2_s.gguf"
        ;;
    *)
        echo "Exiting. You can download models later manually."
        exit 0
        ;;
esac

echo -e "\e[1;34m[*] Setup Successful!\e[0m"
echo -e "To start chatting, run these commands:"
echo -e "cd ~/BitNet"
echo -e "source venv/bin/activate"
echo -e "python run_inference.py -m $MODEL_PATH -p 'Hello!' -cnv"
