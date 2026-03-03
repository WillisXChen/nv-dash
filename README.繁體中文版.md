# <p align="center">🚀 NV-Dash: Linux 系統監控儀表板</p>

<p align="center">
  <img src="nv-dash-banner.png" alt="NV-Dash Banner" width="800">
</p>

<p align="center">
  <strong>一個專為 Debian/Ubuntu 系統設計的輕量級即時監控工具，整合顯示 GPU、CPU 與記憶體狀態。</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/OS-Debian%20%2F%20Ubuntu-D70A53?style=flat-square&logo=debian&logoColor=white" alt="Debian">
  <img src="https://img.shields.io/badge/GPU-NVIDIA-76B900?style=flat-square&logo=nvidia&logoColor=white" alt="NVIDIA">
  <img src="https://img.shields.io/badge/Language-Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white" alt="Bash">
</p>

---

<p align="center">
  <a href="./README.md">
    <img src="https://img.shields.io/badge/Switch_Language-English-blue?style=for-the-badge" alt="English Version">
  </a>
</p>

## 📖 專案簡介

**NV-Dash** 是一個基於 Bash 開發的系統監測工具，旨在提供簡單、直觀的終端介面，讓使用者能同時掌握 CPU 各核心負載、NVIDIA GPU 運作情況及記憶體硬體資訊。

---

## 🖼️ 實際畫面

<p align="center">
  <img src="screenshots/dev-0.0.1/NV-DASH-zh_TW.webp" alt="NV-Dash 繁體中文截圖" width="800">
</p>

---

## ✨ 主要功能

*   **CPU 監控**：顯示處理器型號、各核心使用率、溫度以及即時功耗 (RAPL)。
*   **GPU 監控**：顯示 NVIDIA GPU 的運算、顯存、編解碼器負載，以及溫度、功耗與時脈。
*   **記憶體監控**：顯示系統記憶體使用量，並透過 `dmidecode` 讀取插槽硬體資訊（廠牌、容量、頻率）。
*   **自動化依賴檢查**：啟動時自動檢查並安裝缺失的工具（如 `bc`, `dmidecode` ）。
*   **多語系支持**：內建英文、繁體中文、日文切換功能。

---

## 🚀 使用說明

### 系統要求
*   基於 Debian 的 Linux 發行版 (如 Ubuntu)。
*   已安裝 NVIDIA 驅動程式。

### 執行方式

1.  **賦予執行權限**：
    ```bash
    chmod +x debian-nvidia-gpu.sh
    ```

2.  **查看說明參數**：
    ```bash
    ./debian-nvidia-gpu.sh -h
    ```

3.  **以 sudo 權限執行** (讀取硬體資訊所需)：
    ```bash
    sudo ./debian-nvidia-gpu.sh
    ```

### 語言切換
執行時可指定語系參數：
- 繁體中文：`sudo ./debian-nvidia-gpu.sh zh_TW`
- 英文：`sudo ./debian-nvidia-gpu.sh en`
- 日文：`sudo ./debian-nvidia-gpu.sh ja`

---

## 📩 維護資訊

- **維護者**：Willis Chen (misweyu2007@gmail.com)
- **退出方式**：在終端機按下 `CTRL+C` 即可停止監控。
