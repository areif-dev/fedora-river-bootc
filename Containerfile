FROM quay.io/fedora/fedora-bootc:40

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
    dbus \
    dbus-daemon \
    dbus-tools \
    dunst \
    gnome-keyring \
    gvfs-mtp \
    grim \
    jmtpfs \
    lxpolkit \
    man-pages \
    nvtop \
    openssh \
    openssl \
    papirus-icon-theme \
    pipewire \
    plocate \
    polkit \
    river \
    river-bsp-layout \
    rofi-wayland \
    swaybg \
    swayidle \
    swaylock \
    tailscale \
    waybar \
    wl-clipboard \
    wlr-randr \
    wireplumber \
    xdg-desktop-portal-wlr \
    xdg-user-dirs \
    xorg-x11-server-Xwayland \
    zsh \
    zsh-autosuggestions 

# Applications 
RUN dnf install -y \
    alacritty \
    bc \
    distrobox \
    firefox \
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
    virt-install \
    libvirt \
    libvirt-daemon-config-network \
    libvirt-daemon-kvm \
    qemu-kvm \
    virt-manager \
    virt-viewer \
    libguestfs-tools \
    python3-libguestfs \
    virt-top 

# Enable services
RUN systemctl enable libvirtd && \
    systemctl enable cockpit.socket && \
    systemctl enable plocate-updatedb  && \
    mkdir -p /var/lib/plocate && \
    systemctl enable tailscaled 

# Update and clean up 
RUN dnf clean all && \
    dnf autoremove -y
