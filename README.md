# <p align="center">🚀 NV-Dash: Linux System Monitoring Dashboard</p>

<p align="center">
  <img src="nv-dash-banner.png" alt="NV-Dash Banner" width="800">
</p>

<p align="center">
  <strong>A lightweight real-time monitoring tool for Debian/Ubuntu, integrating GPU, CPU, and Memory status.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/OS-Debian%20%2F%20Ubuntu-D70A53?style=flat-square&logo=debian&logoColor=white" alt="Debian">
  <img src="https://img.shields.io/badge/GPU-NVIDIA-76B900?style=flat-square&logo=nvidia&logoColor=white" alt="NVIDIA">
  <img src="https://img.shields.io/badge/Language-Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white" alt="Bash">
</p>

---

<p align="center">
  <a href="./README.zh_TW.md">
    <img src="https://img.shields.io/badge/切換語言-繁體中文-red?style=for-the-badge" alt="繁體中文版">
  </a>
</p>

## 📖 Introduction

**NV-Dash** is a Bash-based system monitoring tool designed to provide a simple, intuitive terminal interface that allows users to monitor CPU per-core load, NVIDIA GPU status, and RAM hardware information simultaneously.

---

## 🖼️ Screenshots

<p align="center">
  <img src="screenshots/dev-0.0.1/NV-DASH-en_US.webp" alt="NV-Dash English Screenshot" width="800">
</p>

---

## ✨ Key Features

*   **CPU Monitoring**: Displays processor model, per-core utilization, temperature, and real-time power draw (RAPL).
*   **GPU Monitoring**: Displays NVIDIA GPU compute, VRAM, and encoder/decoder loads, as well as temperature, power, and clock speeds.
*   **Memory Monitoring**: Displays system memory usage and uses `dmidecode` to read slot hardware info (Brand, Capacity, Frequency).
*   **Auto Dependency Check**: Automatically checks and installs missing tools (such as `bc`, `dmidecode`) on startup.
*   **Multilingual Support**: Built-in switching for English, Traditional Chinese, and Japanese.

---

## 🚀 Usage

### System Requirements
*   Debian-based Linux distribution (e.g., Ubuntu).
*   NVIDIA drivers installed.

### Execution

1.  **Grant Execution Permissions**:
    ```bash
    chmod +x nv-dash.sh
    ```

2.  **View Help Options**:
    ```bash
    ./nv-dash.sh -h
    ```

3.  **Run with sudo** (Required for hardware info):
    ```bash
    sudo ./nv-dash.sh
    ```

### Language Selection
Specify the language parameter during execution:
- English: `sudo ./nv-dash.sh en`
- Traditional Chinese: `sudo ./nv-dash.sh zh_TW`
- Japanese: `sudo ./nv-dash.sh ja`

---

## 📩 Maintenance

- **Maintainer**: Willis Chen (misweyu2007@gmail.com)
- **Exit**: Press `CTRL+C` in the terminal to stop monitoring.
