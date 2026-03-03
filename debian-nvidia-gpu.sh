#!/bin/bash
# maintainer: Willis Chen <misweyu2007@gmail.com>

# i18n Multilingual setup
export TEXTDOMAIN="linux_nvidia_gpu"
export TEXTDOMAINDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/locale"

# Allow language setting via parameter (supports zh_TW, en_US, ja)
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: sudo $0 [LANG]"
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo ""
    echo "Languages:"
    echo "  en, en_US     English (default)"
    echo "  zh_TW         Traditional Chinese"
    echo "  ja            Japanese"
    echo ""
    echo "Example:"
    echo "  sudo $0 zh_TW"
    exit 0
fi

if [ -n "$1" ]; then
    LANG_OPT="$1"
    # If input is en-US or en, automatically map to en_US
    [[ "$LANG_OPT" == "en-US" || "$LANG_OPT" == "en" ]] && LANG_OPT="en_US"
    
    export LANGUAGE="${LANG_OPT}"
    export LC_ALL="${LANG_OPT}.UTF-8"
    export LANG="${LANG_OPT}.UTF-8"
fi

# Translation function (Custom implementation for environment compatibility)
_() {
    local text="$1"
    local base_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
    local po_file="$base_dir/${LANGUAGE:-en_US}.po"
    
    # Check if translation exists in the .po file
    if [[ -f "$po_file" ]]; then
        # Handle cases where grep might return multiple lines or need trimming
        local trans=$(grep -A 1 "msgid \"$text\"" "$po_file" | grep "msgstr" | sed 's/msgstr "\(.*\)"/\1/')
        if [[ -n "$trans" && "$trans" != "" ]]; then
            echo -e "$trans"
            return
        fi
    fi
    # Fallback to original text if po_file doesn't exist or translation is missing
    echo -e "$text"
}

[[ $EUID -ne 0 ]] && echo "$(_ 'Please run with sudo')" && exit 1

# Auto-install dependencies if missing
REQUIRED_PKGS="gettext lm-sensors bc dmidecode"
NEED_INSTALL=false
for cmd in gettext sensors bc dmidecode nvidia-smi; do
    if ! command -v "$cmd" &> /dev/null; then
        NEED_INSTALL=true
        break
    fi
done

if [ "$NEED_INSTALL" = true ]; then
    echo "Required dependencies missing. Installing..."
    sudo apt-get update && sudo apt-get install -y $REQUIRED_PKGS
fi
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RED='\033[0;31m'; PURPLE='\033[0;35m'; BOLD='\033[1m'; WHITE='\033[1;37m'; NC='\033[0m'

# 1. Static hardware information collection
CPU_MODEL=$(lscpu | grep "Model name" | sed 's/Model name:[[:space:]]*//' | xargs | fold -s -w 55)
# Fix GPU model capture: ensure the header row is not captured
GPU_MODEL=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits | head -n 1)
MB_INFO=$(dmidecode -t baseboard | grep -E "Manufacturer|Product Name" | awk -F: '{print $2}' | xargs)

# Get RAM hardware list (no limit on quantity)
RAM_HW_LIST=$(sudo dmidecode -t memory | awk '
    /Size: [0-9]+ GB/ {s=$0} 
    /Manufacturer:/ {m=$0} 
    /Configured Memory Speed: [0-9]+/ {
        if (s != "" && m != "") {
            print m "|" s "|" $0
            s=""; m=""
        }
    }' | sed 's/Manufacturer: //g; s/Size: //g; s/Configured Memory Speed: //g')

# Clear screen
clear
prev_total=(); prev_idle=()
prev_all_total=0; prev_all_idle=0

while true; do
    # --- Data Collection ---
    # GPU data (Graphics, Memory, Encoder, Decoder, Temp, Power, Used, Total, Clock)
    read gpu_u mem_u enc_u dec_u gpu_t gpu_w vram_u vram_t vram_s < <(nvidia-smi --query-gpu=utilization.gpu,utilization.memory,utilization.encoder,utilization.decoder,temperature.gpu,power.draw,memory.used,memory.total,clocks.mem --format=csv,noheader,nounits | tr ',' ' ')
    
    # CPU Power (RAPL)
    cpu_w=$(if [ -f /sys/class/powercap/intel-rapl:0/energy_uj ]; then
        e1=$(cat /sys/class/powercap/intel-rapl:0/energy_uj); sleep 0.1; e2=$(cat /sys/class/powercap/intel-rapl:0/energy_uj)
        echo "scale=2; ($e2 - $e1) / 100000" | bc
    else echo "N/A"; fi)
    
    # RAM Usage
    ram_raw=$(free -m | awk '/Mem:/ {printf "%d,%d,%.1f", $3, $2, ($3/$2)*100}')
    ram_u=$(echo $ram_raw | cut -d',' -f1); ram_t=$(echo $ram_raw | cut -d',' -f2); ram_p=$(echo $ram_raw | cut -d',' -f3)
    
    # CPU Temp
    cpu_temp=$(sensors 2>/dev/null | grep -E 'Package id 0|Core 0' | awk '{print $4}' | head -n 1 | tr -d '+')

    # Hacker Rabbit Animation Logic (Switching frames based on seconds counter)
    sec=$(date +%s)
    frame=$((sec % 10))
    
    case $frame in
        0)
            P_L1='             '
            P_L2='             '
            P_L3='   (\__/)    '
            P_L4='   (>.< ) 💦 '
            P_L5='  c(")_(")   '
            P_L6=' [========]  '
            P_L7='             '
            ;;
        1)
            P_L1='             '
            P_L2='   ⚡️       '
            P_L3='   (\__/)    '
            P_L4='   (0_0 )    '
            P_L5='   / / / /   '
            P_L6=' [========]  '
            P_L7='             '
            ;;
        2)
            P_L1='             '
            P_L2='             '
            P_L3='   (\__/)    '
            P_L4='   (+_+) 💢 '
            P_L5='  c(")_(")   '
            P_L6=' [========]  '
            P_L7='             '
            ;;
        3)
            P_L1='    ✨       '
            P_L2='             '
            P_L3='   (\__/)    '
            P_L4='   (O_O )    '
            P_L5='  \ \ \ \    '
            P_L6=' [========]  '
            P_L7='             '
            ;;
        4)
            P_L1='             '
            P_L2='   😄       '
            P_L3='   (\__/)    '
            P_L4='   ( ^v^)    '
            P_L5='  c(")_(")   '
            P_L6=' [========]  '
            P_L7='             '
            ;;
        5)
            P_L1='    🎶       '
            P_L2='             '
            P_L3='   (\__/)    '
            P_L4='   (^o^ )    '
            P_L5='   / / / /   '
            P_L6=' [========]  '
            P_L7='             '
            ;;
        6)
            P_L1='             '
            P_L2='             '
            P_L3='   (\__/)    '
            P_L4='   (-_- ) ☕️ '
            P_L5='  c(")_(")   '
            P_L6=' [========]  '
            P_L7='             '
            ;;
        7)
            P_L1='             '
            P_L2='   🚀       '
            P_L3='   (\__/)    '
            P_L4='   ($_$ )    '
            P_L5='  \ \ \ \    '
            P_L6=' [========]  '
            P_L7='             '
            ;;
        8)
            P_L1='             '
            P_L2='             '
            P_L3='   (\__/)    '
            P_L4='   (T_T ) 🐛 '
            P_L5='  c(")_(")   '
            P_L6=' [========]  '
            P_L7='             '
            ;;
        9)
            P_L1='             '
            P_L2='   🔥       '
            P_L3='   (\__/)    '
            P_L4='   (ಠ_ಠ )    '
            P_L5='   / / / /   '
            P_L6=' [========]  '
            P_L7='             '
            ;;
    esac

    # --- Interface Rendering ---
    tput cup 0 0
    CE='\033[K'
    echo -e "${BOLD}${CYAN}    _   ___    __   ____             __  ${NC}   ${BOLD}${WHITE}${P_L1}${NC}${CE}"
    echo -e "${BOLD}${CYAN}   / | / / |  / /  / __ \____ ______/ /_ ${NC}   ${BOLD}${WHITE}${P_L2}${NC}${CE}"
    echo -e "${BOLD}${CYAN}  /  |/ /| | / /  / / / / __ \`/ ___/ __ \x5C${NC}   ${BOLD}${YELLOW}${P_L3}${NC}${CE}"
    echo -e "${BOLD}${CYAN} / /|  / | |/ /  / /_/ / /_/ (__  ) / / /${NC}   ${BOLD}${WHITE}${P_L4}${NC}${CE}"
    echo -e "${BOLD}${CYAN}/_/ |_/  |___/  /_____/\__,_/____/_/ /_/ ${NC}   ${BOLD}${WHITE}${P_L5}${NC}${CE}"
    echo -e "                                            ${BOLD}${WHITE}${P_L6}${NC}${CE}"
    echo -e "                                            ${BOLD}${YELLOW}${P_L7}${NC}${CE}"
    echo -e "${BOLD}${YELLOW}$(_ '=== SYSTEM MONITORING DASHBOARD ===')${NC}${CE}"
    echo -e "${CYAN}$(_ 'Motherboard:')${NC} $MB_INFO${CE}"
    
    # --- Section 1: CPU Section ---
    echo -e "${CE}"
    echo -e "${BOLD}${WHITE}[ $(_ 'CPU') ]${NC} ${CE}"
    echo -e " $(_ 'Model:'):${CE}"
    while IFS= read -r c_line; do
        [[ -n "$c_line" ]] && echo -e "   ${CYAN}${c_line}${NC}${CE}"
    done <<< "$CPU_MODEL"
    
    all_cpu=$(grep '^cpu ' /proc/stat)
    read -ra all_stats <<< "$all_cpu"
    all_idle=${all_stats[4]}; all_total=0
    for val in "${all_stats[@]:1}"; do all_total=$((all_total + val)); done
    diff_all_total=$((all_total - prev_all_total))
    diff_all_idle=$((all_idle - prev_all_idle))
    cpu_all_pct=$(echo "scale=1; 100 * ($diff_all_total - $diff_all_idle) / $diff_all_total" | bc 2>/dev/null || echo "0.0")
    prev_all_total=$all_total; prev_all_idle=$all_idle

    printf " $(_ 'Power:'): ${YELLOW}%6s W${NC} | $(_ 'Temp:'): ${RED}%-8s${NC} | $(_ 'Total Usage:'): ${GREEN}%s%%${NC}${CE}\n" "$cpu_w" "$cpu_temp" "$cpu_all_pct"
    
    cpu_info=$(grep '^cpu[0-9]' /proc/stat)
    i=0
    while read -r line; do
        read -ra st <<< "$line"; idle=${st[4]}; total=0
        for v in "${st[@]:1}"; do total=$((total + v)); done
        diff_t=$((total - ${prev_total[$i]:-0})); diff_i=$((idle - ${prev_idle[$i]:-0}))
        cpu_pct=$(echo "scale=1; 100 * ($diff_t - $diff_i) / $diff_t" | bc 2>/dev/null || echo "0.0")
        prev_total[$i]=$total; prev_idle[$i]=$idle
        printf " $(_ 'C')%02d: ${GREEN}%5s%%${NC} " "$i" "$cpu_pct"
        [[ $(( (i + 1) % 4 )) -eq 0 ]] && echo -e "${CE}"
        ((i++))
    done <<< "$cpu_info"
    [[ $(( i % 4 )) -ne 0 ]] && echo -e "${CE}"

    # --- Section 2: GPU Section ---
    echo -e "${CE}"
    echo -e "${BOLD}${WHITE}[ $(_ 'GPU') ]${NC} ${CE}"
    echo -e " $(_ 'Model:'): ${CYAN}$GPU_MODEL${NC}${CE}"
    vram_p_val=$(echo "scale=1; if ($vram_t > 0) 100 * $vram_u / $vram_t else 0" | bc 2>/dev/null || echo "0.0")
    printf " $(_ 'Power:'): ${YELLOW}%6s W${NC} | $(_ 'Temp:'): ${RED}%s°C${NC} | $(_ 'Clock:'): ${YELLOW}%s MHz${NC}${CE}\n" "$gpu_w" "$gpu_t" "$vram_s"
    printf " $(_ 'Load (G/D/E):') ${GREEN}%s%% / %s%% / %s%%${NC}${CE}\n" "$gpu_u" "$dec_u" "$enc_u"
    printf " $(_ 'VRAM Usage  :') ${CYAN}%s / %s MB (${vram_p_val}%%)${NC}${CE}\n" "$vram_u" "$vram_t"

    # --- Section 3: RAM Section ---
    echo -e "${CE}"
    echo -e "${BOLD}${WHITE}[ $(_ 'RAM') ]${NC} ${CE}"
    ram_p_clean=$(echo "scale=1; if ($ram_t > 0) 100 * $ram_u / $ram_t else 0" | bc 2>/dev/null || echo "0.0")
    printf " $(_ 'Usage Total :') ${CYAN}%s / %s MB (${ram_p_clean}%%)${NC}${CE}\n" "$ram_u" "$ram_t"
    echo -e " $(_ 'Hardware Info:')${CE}"
    idx=0
    while read -r line; do
        [[ -z "$line" ]] && continue
        brand=$(echo "$line" | awk -F'|' '{print $1}' | xargs)
        size=$(echo "$line" | awk -F'|' '{print $2}' | xargs)
        speed=$(echo "$line" | awk -F'|' '{print $3}' | xargs)
        printf "  $(_ 'Slot') %d: ${PURPLE}%-10s${NC} ${CYAN}%-6s${NC} ${YELLOW}(%s)${NC}${CE}\n" "$idx" "$brand" "$size" "$speed"
        ((idx++))
    done <<< "$RAM_HW_LIST"

    echo -e "---------------------------------------------------${CE}"
    echo -e "${YELLOW}$(_ 'Press [CTRL+C] to exit monitoring')${NC}${CE}"
    tput ed
done