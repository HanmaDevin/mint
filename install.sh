#!/usr/bin/env bash
#    ____           __        ____   _____           _       __
#    /  _/___  _____/ /_____ _/ / /  / ___/__________(_)___  / /_
#    / // __ \/ ___/ __/ __ `/ / /   \__ \/ ___/ ___/ / __ \/ __/
#  _/ // / / (__  ) /_/ /_/ / / /   ___/ / /__/ /  / / /_/ / /_
# /___/_/ /_/____/\__/\__,_/_/_/   /____/\___/_/  /_/ .___/\__/
#                                                  /_/
clear

repo="${HOME}/popos"
cfgPath="${repo}/.config"

install_helix_utils() {
  pipx install beautysh
  sudo npm install -g bash-language-server
  go install golang.org/x/tools/gopls@latest
  uv tool install basedpyright
  uv tool install black
}

install_packages() {
  echo ">>> Adding Repositories..."
  sudo add-apt-repository ppa:maveonair/helix-editor
  sudo apt update
  sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
  sudo apt update
  sudo add-apt-repository ppa:3v1n0/gamescope
  sudo apt update

  local packages=("nala" "wl-clipboard" "golang" "dkms" "python3-pip" "pipx" "ffmpegthumbnailer" "libreoffice" "steam" "mpv" "mpv-mpris" "ntfs-3g" "ufw" "zsh" "helix" "gamemode" "playerctl" "tealdeer" "fastfetch" "bat" "openjdk-21-jdk" "unrar" "containerd" "docker-compose" "node" "rustup" "fd-find" "gamescope" "wine" "openssh" "pamu2fcfg" "libfido2-1" "xdg-desktop-portal-gtk" "xdg-desktop-portal-wlr" "texlive-full" "jq" "btop" "bzip2" "autoconf" "guile-cairo-dev" "fontconfig" "gcc" "libev-dev" "automake" "uv" "libjpeg-turbo8-dev" "libxkbcommon-dev" "libxkbcommon-x11-dev" "automake" "git-delta" "librust-pam-dev" "zsh" "pkgconf" "shellcheck" "shfmt")
  for pkg in "${packages[@]}"; do
    sudo apt install -y "${pkg}"
  done


  # Download and install fnm:
  curl -o- https://fnm.vercel.app/install | bash
  # Download and install Node.js:
  fnm install 24

  pipx install beautysh

  # install ghostty
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"

  read -r -p ">>> Do you want to install Zed? (y/n): " ans
  if [[ "${ans}" =~ [yY] ]]; then
    curl -f https://zed.dev/install.sh | sh
  fi

  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
  rm -rf ~/.fzf

  sudo apt remove firefox -y

  rustup default stable

  ~/.cargo/bin/cargo install starship
  ~/.cargo/bin/cargo install eza
  ~/.cargo/bin/cargo install zoxide
  ~/.cargo/bin/cargo install ripgrep

  install_helix_utils
}

install_signal() {
  read -r -p ">>> Do you want to install Signal Messenger? (y/n): " ans
  if [[ "${ans}" =~ [yY] ]]; then
    wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg;
    cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
    wget -O signal-desktop.sources https://updates.signal.org/static/desktop/apt/signal-desktop.sources;
    cat signal-desktop.sources | sudo tee /etc/apt/sources.list.d/signal-desktop.sources > /dev/null
    sudo apt update && sudo apt install signal-desktop
  fi
}

get_wallpaper() {
  read -r -p ">>> Do you want to download cool wallpaper? (y/n): " ans
  if [[ "${ans}" =~ [yY] ]]; then
    git clone "https://github.com/HanmaDevin/Wallpapes.git" "${HOME}/Wallpapes"
    cp -r "${HOME}/Wallpapes/" "${HOME}/Pictures/Wallpaper/"
    rm -rf "${HOME}/Wallpapes/"
  fi
}

install_spotify() {
  read -r -p ">>> Do you want to install Spotify? (y/n): " ans
  if [[ "${ans}" =~ [yY] ]]; then
    curl -sS https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update
    sudo apt install spotify-client
  fi
}

install_brave() {
  read -r -p ">>> Do you want to install Brave Browser? (y/n): " ans
  if [[ "${ans}" =~ [yY] ]]; then
    flatpak install flathub com.brave.Browser
  fi
}

install_protonvpn() {
  read -r -p ">>> Do you want to install ProtonVPN? (y/n): " ans
  if [[ "${ans}" =~ [yY] ]]; then
    wget "https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.8_all.deb"
    sudo dpkg -i ./protonvpn-stable-release_1.0.8_all.deb && sudo apt update
    sudo apt install proton-vpn-gnome-desktop
  fi
}

install_protonmail() {
  read -r -p ">>> Do you want to install Proton Mail? (y/n): " ans
  if [[ "${ans}" =~ [yY] ]]; then
    wget -O ./mail.deb "https://proton.me/download/mail/linux/1.12.1/ProtonMail-desktop-beta.deb"
    sudo apt install ./mail.deb
    rm ./mail.deb
  fi
}

install_deepcool_driver() {
  read -r -p ">>> Do you want to install DeepCool CPU-Fan driver? (y/n): " ans
  if [[ "${ans}" =~ [yY] ]]; then
    sudo cp "${repo}/DeepCool/deepcool-digital-linux" "/usr/sbin"
    sudo cp "${repo}/DeepCool/deepcool-digital.service" "/etc/systemd/system/"
    sudo systemctl enable deepcool-digital
  fi
}

configure_git() {
  read -r -p ">>> Want to setup git? (y/n): " ans
  if [[ "${ans}" =~ [yY] ]]; then
    read -r -p ">>> What is your user name?: " username
    git config --global user.name "${username}"
    read -r -p ">>> What is your email?: " useremail
    git config --global user.email "${useremail}"
    git config --global pull.rebase true
  fi

  git config --global core.pager 'delta -n'
  git config --global interactive.diffFilter 'delta --color-only -n'
  git config --global delta.navigate true
  git config --global merge.conflictStyle zdiff3

  read -r -p ">>> Do you want to generate a SSH-Key? (y/n): " ans
  if [[ "${ans}" =~ [yY] ]]; then
    ssh-keygen -t ed25519 -C "${useremail}"
  fi
}

detect_nvidia() {
  gpu=$(lspci | grep -i '.* vga .* nvidia .*')

  shopt -s nocasematch

  if [[ ${gpu} == *' nvidia '* ]]; then
    echo ">>> Detected Nvidia GPU, installing driver now"
    sudo apt install -y system76-driver-nvidia
  fi
}

config_ufw() {
  echo ">>> Configuring Firewall..."
  # Allow ports for LocalSend
  sudo ufw allow 53317/udp
  sudo ufw allow 53317/tcp
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw --force enable
  # Enable UFW systemd service to start on boot
  sudo systemctl enable ufw
  sudo ufw status verbose
}

installExtensions() {
  if ! command -v codium >/dev/null 2>&1; then
    echo ">>> VS Codium not installed."
    return 1
  fi

  echo ">>> Installing VS Codium extensions..."
  while read -r x; do
    codium --install-extension "${x}"
  done <"${repo}/extensions.txt"
}

copy_config() {
  read -r -p ">>> Do you want to use my awesome configurations? (y/n): " ans
  if [[ "${ans}" =~ [yY] ]]; then
    if [[ ! -d "${HOME}/Pictures/Screenshots/" ]]; then
      mkdir -p "${HOME}/Pictures/Screenshots/"
    fi

    cp "${repo}/.zshrc" "${HOME}/"
    cp -r "${cfgPath}" "${HOME}/"

    sudo cp -r "${repo}/fonts/" "/usr/share"
    sudo usermod -aG docker "${USER}"

    installExtensions

    echo ">>> Changing Shell to Zsh"
    chsh -s /bin/zsh
  fi
}

install_ani-cli() {
  read -r -p ">>> Do you want to install ani-cli? (y/n): " ans
  if [[ "${ans}" =~ [yY] ]]; then
    git clone "https://github.com/pystardust/ani-cli.git"
    sudo cp ani-cli/ani-cli /usr/local/bin
    rm -rf ani-cli
    git clone "https://github.com/synacktraa/ani-skip.git"
    sudo cp ani-skip/ani-skip /usr/local/bin
    mkdir -p ~/.config/mpv/scripts && cp ani-skip/skip.lua ~/.config/mpv/scripts
    rm -rf ani-skip
  fi
}

install_vesktop() {
  read -r -p ">>> Do you want to install vesktop? (y/n): " ans
  if [[ "${ans}" =~ [yY] ]]; then
    wget -O vesktop.deb "https://vencord.dev/download/vesktop/amd64/deb"
    sudo apt install -y ./vesktop.deb
    rm ./vesktop.deb
  fi
}

install_lazygit() {
  local LAZYGIT_VERSION
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/
  rm ./lazygit.tar.gz
}

install_localsend() {
  local version
  version=$(curl -s "https://api.github.com/repos/localsend/localsend/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo localsend.deb "https://github.com/localsend/localsend/releases/download/v${version}/lazygit_${version}_Linux_x86_64.tar.gz"
  sudo apt install ./localsend.deb
  rm ./localsend.deb
}

install_ghcli() {
  read -r -p ">>> Do you want to install Github CLI? (y/n): " ans
  if [[ "${ans}" =~ [yY] ]]; then
    (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) &&
    sudo mkdir -p -m 755 /etc/apt/keyrings &&
    out=$(mktemp) && wget -nv -O${out} https://cli.github.com/packages/githubcli-archive-keyring.gpg &&
    cat "${out}" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
    sudo mkdir -p -m 755 /etc/apt/sources.list.d &&
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
    sudo apt update &&
    sudo apt install gh -y
  fi
}

install_vscodium() {
  read -r -p ">>> Do you want to install VS Codium? (y/n): " ans
  if [[ "${ans}" =~ [yY] ]]; then
    wget -qO - "https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg" |
    gpg --dearmor |
    sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
    echo -e 'Types: deb\nURIs: https://download.vscodium.com/debs\nSuites: vscodium\nComponents: main\nArchitectures: amd64 arm64\nSigned-by: /usr/share/keyrings/vscodium-archive-keyring.gpg' |
    sudo tee /etc/apt/sources.list.d/vscodium.sources
    sudo apt update && sudo apt install codium
  fi
}

MAGENTA='\033[0;35m'
NONE='\033[0m'

# Header
echo -e "${MAGENTA}"
cat <<"EOF"
   ____         __       ____
  /  _/__  ___ / /____ _/ / /__ ____
 _/ // _ \(_-</ __/ _ `/ / / -_) __/
/___/_//_/___/\__/\_,_/_/_/\__/_/

EOF

echo "PopOS Setup"
echo -e "${NONE}"
while true; do
  read -r -p ">>> Do you want to start the installation now? (Yy/Nn): " yn
  case ${yn} in
    [Yy])
      echo ">>> Installation started."
      echo
      break
      ;;
    [Nn])
      echo ">>> Installation canceled."
      exit
      ;;
    *)
      echo ">>> Please answer yes or no."
      ;;
  esac
done

# Install required packages
install_packages
get_wallpaper
detect_nvidia
install_vesktop
install_lazygit
install_deepcool_driver
install_ghcli
install_vscodium
install_spotify
install_protonmail
install_protonvpn
install_signal
install_brave
install_ani-cli
copy_config
configure_git
config_ufw

echo -e "${MAGENTA}"
cat <<"EOF"
    ____       __                __  _                _   __
   / __ \___  / /_  ____  ____  / /_(_)___  ____ _   / | / /___ _      __
  / /_/ / _ \/ __ \/ __ \/ __ \/ __/ / __ \/ __ `/  /  |/ / __ \ | /| / /
 / _, _/  __/ /_/ / /_/ / /_/ / /_/ / / / / /_/ /  / /|  / /_/ / |/ |/ /
/_/ |_|\___/_.___/\____/\____/\__/_/_/ /_/\__, /  /_/ |_/\____/|__/|__/
                                         /____/
EOF
echo "and thank you for choosing my config :)"
echo -e "${NONE}"

read -r -p ">>> Ready to reboot now? (y/n): " ans
if [[ "${ans}" =~ [yY] ]]; then
  systemctl reboot
else
  exit 0
fi
