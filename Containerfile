# Copyright 2024 AJ Reifsnyder
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM quay.io/fedora/fedora-bootc:41

COPY ./50-fedora-river-atomic.toml /usr/lib/bootc/install/50-fedora-river-atomic.toml

# Speed up DNF
RUN sed -i 's/.*max_parallel_downloads=.*//g' /etc/dnf/dnf.conf && \
    sed -i 's/.*fastestmirror=.*//g' /etc/dnf/dnf.conf && \
    echo 'max_parallel_downloads=15' | tee -a /etc/dnf/dnf.conf && \
    echo 'fastestmirror=True' | tee -a /etc/dnf/dnf.conf

RUN dnf upgrade -y

# Install extra repositories 
RUN dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    curl -Lo /etc/yum.repos.d/_copr_areif-dev-river-bsp-layout.repo https://copr.fedorainfracloud.org/coprs/areif-dev/river-bsp-layout/repo/fedora-"$(rpm -E %fedora)"/areif-dev-river-bsp-layout-fedora-"$(rpm -E %fedora)".repo && \
    curl -Lo /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo 

# System 
RUN dnf install -y \
    bluez \
    bluez-tools \
    cockpit \
    cockpit-machines \
    cockpit-podman \
    cockpit-system \
    cockpit-ws \
    cups \
    dbus \
    dbus-daemon \
    dbus-tools \
    dunst \
    fwupd \
    flatpak \
    git \
    gnome-keyring \
    gvfs-mtp \
    grim \
    hyprland \
    jmtpfs \
    lxpolkit \
    man-db \
    man-pages \
    openssh \
    openssl \
    papirus-icon-theme \
    pipewire \
    plocate \
    podman \
    podman-compose \
    polkit \
    river \
    river-bsp-layout \
    rofi-wayland \
    swaybg \
    swayidle \
    swaylock \
    syncthing \
    system-config-printer \
    tailscale \
    waybar \
    wl-clipboard \
    wlr-randr \
    wireplumber \
    xdg-desktop-portal-wlr \
    xdg-desktop-portal-hyprland \
    xdg-user-dirs \
    xorg-x11-server-Xwayland \
    zsh \
    zsh-autosuggestions

# Applications 
RUN dnf install -y \
    alacritty \
    bc \
    distrobox \
    ffmpeg \
    firefox \
    htop \
    keepassxc \
    neovim \
    nvtop \
    openvpn \
    pavucontrol \
    playerctl \
    ranger \
    ripgrep \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    thunderbird \
    unzip \
    vlc  \
    zip

# Fonts 
RUN dnf install -y \
    cascadia-code-fonts \
    fontawesome-fonts \
    google-noto-emoji-fonts  

# Virtualization packages 
RUN dnf install -y \
    libvirt \
    libvirt-daemon-config-network \
    libvirt-daemon-kvm \
    qemu-kvm \
    virt-manager \
    libguestfs-tools \
    python3-libguestfs 

# Wifi packages 
RUN dnf install -y \
    NetworkManager       \
    NetworkManager-tui   \
    NetworkManager-wifi  \
    atheros-firmware     \
    b43-fwcutter         \
    b43-openfwwf         \
    brcmfmac-firmware    \
    iwlegacy-firmware    \
    iwlwifi-dvm-firmware \
    iwlwifi-mvm-firmware \
    libertas-firmware    \
    mt7xxx-firmware      \
    nxpwireless-firmware \
    realtek-firmware     \
    tiwilink-firmware    \
    atmel-firmware       \
    zd1211-firmware   

# Install any extra third party packages or other configs
RUN mkdir -p /tmp/extras
COPY ./extras.sh /tmp/extras/extras.sh
RUN /tmp/extras/extras.sh && \
    rm -rf /tmp/extras 

# Enable services
RUN systemctl enable libvirtd && \
    systemctl enable cockpit.socket && \
    systemctl enable plocate-updatedb  && \
    mkdir -p /var/lib/plocate && \
    systemctl enable tailscaled && \
    systemctl disable bootc-fetch-apply-updates.timer

# Update and clean up 
RUN dnf clean all && \
    dnf autoremove -y
