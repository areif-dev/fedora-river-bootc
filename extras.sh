#!/usr/bin/env bash 

# Install Starship prompt
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
