#!/usr/bin/env bash

# === CONFIGURATION ===
QEMU_DIR="./pve-qemu/qemu" # <-- adapte si besoin
CORE_FILE="${QEMU_DIR}/hw/ide/core.c"
BACKUP_DIR="${QEMU_DIR}/.spoof_backup"

[[ ! -f "$CORE_FILE" ]] && { echo "❌ Fichier introuvable: $CORE_FILE"; exit 1; }

mkdir -p "$BACKUP_DIR"
cp "$CORE_FILE" "$BACKUP_DIR/core.c"

# === LISTES DE MODÈLES ===

ide_cd_models=(
  "HL-DT-ST BD-RE WH16NS60" "HL-DT-ST DVDRAM GH24NSC0"
  "HL-DT-ST BD-RE BH16NS40" "HL-DT-ST DVD+-RW GT80N"
  "HL-DT-ST DVD-RAM GH22NS30" "HL-DT-ST DVD+RW GCA-4040N"
  "Pioneer BDR-XD07B" "Pioneer DVR-221LBK" "Pioneer BDR-209DBK"
  "Pioneer DVR-S21WBK" "Pioneer BDR-XD05B" "ASUS BW-16D1HT"
  "ASUS DRW-24B1ST" "ASUS SDRW-08D2S-U" "ASUS BC-12D2HT"
  "ASUS SBW-06D2X-U" "Samsung SH-224FB" "Samsung SE-506BB"
  "Samsung SH-B123L" "Samsung SE-208GB" "Samsung SN-208DB"
  "Sony NEC Optiarc AD-5280S" "Sony DRU-870S" "Sony BWU-500S"
  "Sony NEC Optiarc AD-7261S" "Sony AD-7200S" "Lite-On iHAS124-14"
  "Lite-On iHBS112-04" "Lite-On eTAU108" "Lite-On iHAS324-17"
  "Lite-On eBAU108" "HP DVD1260i" "HP DVD640"
  "HP BD-RE BH30L" "HP DVD Writer 300n" "HP DVD Writer 1265i"
)

ide_cfata_models=(
  "SanDisk Ultra microSDXC UHS-I" "SanDisk Extreme microSDXC UHS-I"
  "SanDisk High Endurance microSDXC" "SanDisk Industrial microSD"
  "SanDisk Mobile Ultra microSDHC" "Samsung EVO Select microSDXC"
  "Samsung PRO Endurance microSDHC" "Samsung PRO Plus microSDXC"
  "Samsung EVO Plus microSDXC" "Samsung PRO Ultimate microSDHC"
  "Kingston Canvas React Plus microSD" "Kingston Canvas Go! Plus microSD"
  "Kingston Canvas Select Plus microSD" "Kingston Industrial microSD"
  "Kingston Endurance microSD" "Lexar Professional 1066x microSDXC"
  "Lexar High-Performance 633x microSDHC" "Lexar PLAY microSDXC"
  "Lexar Endurance microSD" "Lexar Professional 1000x microSDHC"
  "PNY Elite-X microSD" "PNY PRO Elite microSD"
  "PNY High Performance microSD" "PNY Turbo Performance microSD"
  "PNY Premier-X microSD" "Transcend High Endurance microSDXC"
  "Transcend Ultimate microSDXC" "Transcend Industrial Temp microSD"
  "Transcend Premium microSDHC" "Transcend Superior microSD"
  "ADATA Premier Pro microSDXC" "ADATA XPG microSDXC"
  "ADATA High Endurance microSDXC" "ADATA Premier microSDHC"
  "ADATA Industrial microSD" "Toshiba Exceria Pro microSDXC"
  "Toshiba Exceria microSDHC" "Toshiba M203 microSD"
  "Toshiba N203 microSD" "Toshiba High Endurance microSD"
)

default_models=(
  "Samsung SSD 970 EVO 1TB" "Samsung SSD 860 QVO 1TB"
  "Samsung SSD 850 PRO 1TB" "Samsung SSD T7 Touch 1TB"
  "Samsung SSD 840 EVO 1TB" "WD Blue SN570 NVMe SSD 1TB"
  "WD Black SN850 NVMe SSD 1TB" "WD Green 1TB SSD"
  "WD Blue 3D NAND 1TB SSD" "Crucial P3 1TB PCIe 3.0 3D NAND NVMe SSD"
  "Seagate BarraCuda SSD 1TB" "Seagate FireCuda 520 SSD 1TB"
  "Seagate IronWolf 110 SSD 1TB" "SanDisk Ultra 3D NAND SSD 1TB"
  "Seagate Fast SSD 1TB" "Crucial MX500 1TB 3D NAND SSD"
  "Crucial P5 Plus NVMe SSD 1TB" "Crucial BX500 1TB 3D NAND SSD"
  "Kingston A2000 NVMe SSD 1TB" "Kingston KC2500 NVMe SSD 1TB"
  "Kingston A400 SSD 1TB" "Kingston HyperX Savage SSD 1TB"
  "SanDisk SSD PLUS 1TB" "SanDisk Ultra 3D 1TB NAND SSD"
)

# === FONCTION UTILE ===
get_random_element() {
  local array=("$@")
  echo "${array[RANDOM % ${#array[@]}]}"
}

# === REMPLACEMENT ===
echo "🔧 Spoofing des modèles de disque..."

new_cd=$(get_random_element "${ide_cd_models[@]}")
new_cfata=$(get_random_element "${ide_cfata_models[@]}")
new_default=$(get_random_element "${default_models[@]}")

sed -i -E "s/\"HL-DT-ST BD-RE WH16NS60\"/\"$new_cd\"/" "$CORE_FILE"
sed -i -E "s/\"Hitachi HMS360404D5CF00\"/\"$new_cfata\"/" "$CORE_FILE"
sed -i -E "s/\"Samsung SSD 980 500GB\"/\"$new_default\"/" "$CORE_FILE"

echo "✅ Spoofing terminé. Nouveau modèle IDE CD: $new_cd"
echo "✅ Nouveau modèle IDE CFATA: $new_cfata"
echo "✅ Nouveau modèle SSD par défaut: $new_default"
