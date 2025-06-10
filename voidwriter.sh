#!/bin/bash

# === VOIDWRITER v1.0 - Safety edition ===
# Cyber-formatting utility for terminal sorcerers.
# No colors. Checks if partitions are mounted before wiping.

# --- Typewriter effect ---
type_out() {
    local text="$1"
    local delay="${2:-0.01}"
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

loading_bar() {
  for i in {1..20}; do
    printf "\r["
    for ((j=1;j<=i;j++)); do printf "#"; done
    for ((k=i;k<20;k++)); do printf "-"; done
    printf "] %d%%" $((i*5))
    sleep 0.07
  done
  echo ""
}

glitch_text() {
  local text1="$1"
  local text2="$2"
  for i in {1..5}; do
    printf "\r%s" "$text1"
    sleep 0.1
    printf "\r%s" "$text2"
    sleep 0.1
  done
  echo ""
}

# --- Root check ---
if [[ "$EUID" -ne 0 ]]; then
    type_out "[ERROR] VOIDWRITER requires root privileges. Relaunch with: sudo $0"
    exit 1
fi

export LC_ALL=C
trap "type_out 'ABORTED! System may be unstable. Please reboot before retrying.'; exit 1" SIGINT

clear
type_out "<< VOIDWRITER v1.0 >>" 0.01
sleep 0.3
type_out ">>> Boot sequence initiated..." 0.01
type_out "Decrypting the storage grid..." 0.01
loading_bar
sleep 0.5
clear
type_out ">>> Cybernodes detected:" 0.01

# --- Disk listing ---
disks=($(lsblk -d -e 7,11 -o NAME | tail -n +2))
models=($(lsblk -d -e 7,11 -o MODEL | tail -n +2))
sizes=($(lsblk -d -e 7,11 -o SIZE | tail -n +2))

echo ""
for i in "${!disks[@]}"; do
    type_out "  [$i] ${disks[$i]} - Size: ${sizes[$i]}, Model: ${models[$i]}" 0.005
done

echo ""
read -p "Select cybernode index to format: " index

if [[ -z "${disks[$index]}" ]]; then
    type_out ">>> ERROR: Invalid cybernode selection." 0.01
    glitch_text ">>> VOIDWRITER disengaged."
    exit 1
fi

device="/dev/${disks[$index]}"
clear

# --- Mounted partition check ---
mounted_partitions=$(lsblk -nr -o NAME,MOUNTPOINT "$device" | awk '$2!="" {print "/dev/"$1}')

if [[ -n "$mounted_partitions" ]]; then
    glitch_text "!!! WARNING: Mounted partitions detected!  " "!!! WARNING: UNMOUNT REQUIRED!      "
    type_out "Warning: The following partitions are plugged into cyberspace:"
    type_out "$mounted_partitions"
    read -p "Override and unmount them now? [y/N] " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        for part in $mounted_partitions; do
            type_out ">>> Unmounting $part..." 0.01
            sudo umount "$part" || { echo "!!! Failed to unmount $part"; exit 1; }
        done
        type_out ">>> All partitions unplugged from cyberspace." 0.01
    else
        type_out ">>> Unmount aborted. Manual unmount required before continuing." 0.01
        exit 1
    fi
else
    echo ">>> No mounted partitions detected on $device."
    sleep 0.5
fi

clear
echo ""
type_out "Choose target filesystem:" 0.01
type_out "  [1] ext4"
type_out "  [2] xfs"
type_out "  [3] btrfs"
read -p "Filesystem [1-3]: " fs_choice
loading_bar
case $fs_choice in
    1)
        fs_type="ext4"
        mkfs_cmd="mkfs.ext4"
        ;;
    2)
        fs_type="xfs"
        mkfs_cmd="mkfs.xfs"
        ;;
    3)
        fs_type="btrfs"
        mkfs_cmd="mkfs.btrfs"
        ;;
    *)
        type_out ">>> ERROR: Unknown sanctum format. VOIDWRITER aborted." 0.01
        exit 1
        ;;
esac

# --- Check mkfs tool for selected fs ---
if ! command -v "$mkfs_cmd" >/dev/null; then
    type_out ">>> Error: Required tool '$mkfs_cmd' not found. Install it to continue." 0.01
    glitch_text ">>> VOIDWRITER aborted."
    exit 1
fi

clear
echo ""
type_out "!!! WARNING: DATA OBLITERATION IMMINENT !!!" 0.01
type_out "Target cybernode: ${device}" 0.01
type_out "Filesystem sanctum: ${fs_type}" 0.01
type_out "All encrypted data will be destroyed. This action is irreversible." 0.01
read -p "Input override code: 'VOID' to commit purge: " confirm

if [[ "$confirm" != "VOID" ]]; then
    type_out ">>> VOIDWRITER disengaged. No changes made." 0.01
    exit 1
fi

clear
echo ""
type_out ">>> Engaging VOID Protocol - wiping digital essence..." 0.01
loading_bar
wipefs -a "$device"
sgdisk --zap-all "$device"
sleep 1
partprobe "$device"

clear
type_out ">>> Constructing fresh GPT partition table..." 0.01
parted -s "$device" mklabel gpt
parted -s "$device" mkpart primary $fs_type 1MiB 100%

sleep 1
if [[ "$device" == *"nvme"* ]]; then
    partition="${device}p1"
else
    partition="${device}1"
fi

clear
type_out ">>> Formatting ${partition} as ${fs_type}..." 0.01
mkfs."$fs_type" -F "$partition"

clear
echo ""
loading_bar
type_out ">>> VOID SUCCESS: ${partition} resurrected from the digital abyss." 0.01
type_out ">>> NOTE: Run 'sudo partprobe $device' or reboot to reload partition table." 0.01
type_out ">>> VOIDWRITER v1.0 — Session terminated." 0.01
