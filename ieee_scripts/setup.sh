#!/bin/bash
# GaitDeepfake-13 Setup Script (Linux / macOS)
# Run from the dataset root directory (the folder containing 'data/')

set -e

echo "=== GaitDeepfake-13 Setup ==="

# Verify correct working directory
if [ ! -d "data" ]; then
    echo "ERROR: 'data/' not found. Run this from the dataset root:"
    echo "  cd GaitDeepfake-13 && bash ieee_scripts/setup.sh"
    exit 1
fi

# Check Python 3
if ! command -v python3 &>/dev/null; then
    echo "ERROR: Python 3 not found. Install Python 3.9+ from https://www.python.org"
    exit 1
fi
echo "Python: $(python3 --version)"

# Create and activate virtual environment
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi
source venv/bin/activate
echo "Virtual environment activated."

# Upgrade pip
pip install --upgrade pip --quiet

# Install PyTorch (CPU by default)
# For CUDA on Linux: pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
echo "Installing PyTorch..."
pip install torch torchvision torchaudio

# Install all other dependencies
echo "Installing remaining dependencies..."
pip install "mediapipe==0.10.32" opencv-python numpy pandas scikit-learn matplotlib seaborn tqdm tensorboard albumentations

echo "
Dependencies installed."

# Verify dataset loads correctly
echo "
Running quickstart verification..."
python ieee_scripts/quickstart.py

if [ $? -eq 0 ]; then
    echo "
Setup complete! The dataset is ready to use."
else
    echo "
Setup finished but quickstart check failed."
fi
