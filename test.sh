#!/bin/sh
# License: CC0
# OpenWrt >= 19.07

# インターネット接続設定スクリプトのダウンロード
download_internet_script() {
  echo -e "\033[1;34mDownload scripts for Internet connection\033[0;39m"
  wget --no-check-certificate -O /etc/config-software/internet-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/internet-config.sh
  if [ $? -eq 0 ]; then
    sh /etc/config-software/internet-config.sh
  else
    echo "Download failed!"
  fi
}

# システム設定スクリプトのダウンロード
download_system_script() {
  echo -e "\033[1;33mDownload scripts for initial system setup\033[0;39m"
  wget --no-check-certificate -O /etc/config-software/system-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/system-config.sh
  if [ $? -eq 0 ]; then
    sh /etc/config-software/system-config.sh
  else
    echo "Download failed!"
  fi
}

# パッケージ設定スクリプトのダウンロード
download_package_script() {
  echo -e "\033[1;32mDownload script for package setup\033[0;39m"
  wget --no-check-certificate -O /etc/config-software/package-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-config.sh
  if [ $? -eq 0 ]; then
    sh /etc/config-software/package-config.sh
  else
    echo "Download failed!"
  fi
}

# その他の設定スクリプト
download_other_script() {
  echo -e "\033[1;37mDownload other scripts\033[0;39m"
  wget --no-check-certificate -O /etc/config-software/etc-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/etc-config.sh
  if [ $? -eq 0 ]; then
    sh /etc/config-software/etc-config.sh
  else
    echo "Download failed!"
  fi
}

# 終了処理
quit_script() {
  echo -e "Deleting this script and related files."
  rm -rf /etc/config-software
  rm -rf /usr/bin/confsoft
  exit
}

# バージョンチェック
check_version() {
  OPENWRT_RELEASE=$(grep 'DISTRIB_RELEASE' /etc/openwrt_release | cut -d"'" -f2 | cut -c 1-2)
  if [ "${OPENWRT_RELEASE}" =~ ^(19|20|21|22|23|24|SN)$ ]; then
    echo -e "The version of this device is \033[1;33m$OPENWRT_RELEASE\033[0;39m"
    echo -e "Version Check: \033[1;36mOK\033[0;39m"
  else
    echo -e "Incompatible version."
    exit
  fi
}

# メモリとフラッシュの空き容量確認
check_memory() {
  AVAILABLE_MEMORY=$(free | fgrep 'Mem:' | awk '{ print $4 }')
  AVAILABLE_FLASH=$(df | fgrep 'overlayfs:/overlay' | awk '{ print $4 }')
  echo -e "Available Memory: $((AVAILABLE_MEMORY / 1024)) MB"
  echo -e "Available Flash: $((AVAILABLE_FLASH / 1024)) MB"
}

# メインメニュー
main_menu() {
  while :; do
    echo -e "Please select an option:"
    echo -e "[i] Internet Setup"
    echo -e "[s] System Setup"
    echo -e "[p] Package Setup"
    echo -e "[e] Other Configurations"
    echo -e "[q] Quit"

    read -p "Select option: " option
    case "$option" in
      "i") download_internet_script ;;
      "s") download_system_script ;;
      "p") download_package_script ;;
      "e") download_other_script ;;
      "q") quit_script ;;
      *) echo "Invalid option!" ;;
    esac
  done
}

# 初期処理
check_version
check_memory
main_menu
