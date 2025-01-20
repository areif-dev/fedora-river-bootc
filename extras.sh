#!/usr/bin/env bash 

# Install Starship prompt
echo "Attempting to install Starship Prompt"
STARSHIP_VERSION=$(curl -s "https://api.github.com/repos/starship/starship/releases/latest" | jq -r '.tag_name' | sed 's/v//')
curl -L -o "/tmp/extras/starship-x86_64-unknown-linux-gnu.tar.gz" "https://github.com/starship/starship/releases/download/v${STARSHIP_VERSION}/starship-x86_64-unknown-linux-gnu.tar.gz"
curl -L -o "/tmp/extras/starship-x86_64-unknown-linux-gnu.tar.gz.sha256" "https://github.com/starship/starship/releases/download/v${STARSHIP_VERSION}/starship-x86_64-unknown-linux-gnu.tar.gz.sha256"
EXPECTED_STARSHIP_SUM=$(cat /tmp/extras/starship-x86_64-unknown-linux-gnu.tar.gz.sha256)
ACTUAL_STARSHIP_SUM=$(sha256sum /tmp/extras/starship-x86_64-unknown-linux-gnu.tar.gz | awk '{print $1}')
if [ "$EXPECTED_STARSHIP_SUM" == "$ACTUAL_STARSHIP_SUM" ]; then
    echo "Starship checksum matches"
    tar -xzf "/tmp/extras/starship-x86_64-unknown-linux-gnu.tar.gz" -C "/tmp/extras"
    mv /tmp/extras/starship /usr/bin
else 
    echo "Starship checksums do not match"
    exit 1
fi

# Install nwg-look 
echo "Attempting to install NWG-Look"
mkdir -p /tmp/extras/nwg-look
# NWG_LOOK_VERSION=$(curl -s "https://api.github.com/repos/nwg-piotr/nwg-look/releases/latest" | jq -r '.tag_name' | sed 's/v//')
NWG_LOOK_VERSION="0.2.7"
curl -Lo "/tmp/extras/nwg-look.tar.gz" "https://github.com/nwg-piotr/nwg-look/releases/download/v${NWG_LOOK_VERSION}/nwg-look-v${NWG_LOOK_VERSION}_x86_64.tar.gz"
tar -xzf "/tmp/extras/nwg-look.tar.gz" -C "/tmp/extras/nwg-look"
mkdir -p /usr/share/nwg-look/langs
mkdir -p /usr/share/applications
cp /tmp/extras/nwg-look/stuff/main.glade /usr/share/nwg-look/
cp /tmp/extras/nwg-look/langs/* /usr/share/nwg-look/langs/
cp /tmp/extras/nwg-look/stuff/nwg-look.desktop /usr/share/applications/
cp /tmp/extras/nwg-look/stuff/nwg-look.svg /usr/share/pixmaps/
cp /tmp/extras/nwg-look/nwg-look /usr/bin
