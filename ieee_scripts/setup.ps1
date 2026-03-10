# GaitDeepfake-13 Setup Script (Windows PowerShell)
# Run from the dataset root directory (the folder containing 'data/')

$ErrorActionPreference = "Stop"

Write-Host "=== GaitDeepfake-13 Setup ===" -ForegroundColor Cyan

# Verify correct working directory
if (-not (Test-Path "data")) {
    Write-Host "ERROR: 'data/' not found. Run this from the dataset root:" -ForegroundColor Red
    Write-Host "  cd GaitDeepfake-13; .\ieee_scripts\setup.ps1" -ForegroundColor Yellow
    exit 1
}

# Check Python
$pythonVersion = python --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Python not found. Install Python 3.9+ from https://www.python.org" -ForegroundColor Red
    exit 1
}
Write-Host "Python: $pythonVersion" -ForegroundColor Green

# Create and activate virtual environment
if (-not (Test-Path "venv")) {
    Write-Host "Creating virtual environment..."
    python -m venv venv
}
& .\venv\Scripts\Activate.ps1
Write-Host "Virtual environment activated." -ForegroundColor Green

# Upgrade pip
python -m pip install --upgrade pip --quiet

# Install PyTorch with CUDA 12.4
# No GPU? Replace with: pip install torch torchvision torchaudio
Write-Host "Installing PyTorch (CUDA 12.4)..." -ForegroundColor Cyan
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# Install all other dependencies
Write-Host "Installing remaining dependencies..." -ForegroundColor Cyan
pip install "mediapipe==0.10.32" opencv-python numpy pandas scikit-learn matplotlib seaborn tqdm tensorboard albumentations

Write-Host "
Dependencies installed." -ForegroundColor Green

# Verify dataset loads correctly
Write-Host "
Running quickstart verification..." -ForegroundColor Cyan
python ieee_scripts\quickstart.py

if ($LASTEXITCODE -eq 0) {
    Write-Host "
Setup complete! The dataset is ready to use." -ForegroundColor Green
} else {
    Write-Host "
Setup finished but quickstart check failed." -ForegroundColor Yellow
}
