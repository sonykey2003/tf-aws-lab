# OpenVPN installation
#apt update && apt -y install ca-certificates wget net-tools gnupg
#wget -qO - https://as-repository.openvpn.net/as-repo-public.gpg | apt-key add -
#echo "deb http://as-repository.openvpn.net/as/debian jammy main">/etc/apt/sources.list.d/openvpn-as-repo.list
#apt update && apt -y install openvpn-as


# Maximum number of attempts for each operation
max_attempts=2

# Function to execute a command with retry logic
execute_with_retry() {
    local attempt=1
    local command=$1
    while [ $attempt -le $max_attempts ]; do
        echo "Attempt $attempt: $command"
        eval $command && return || let "attempt++"
        echo "Command failed, retrying in 10 seconds..."
        sleep 10
    done
    echo "Command failed after $max_attempts attempts."
    exit 1
}

# Update and install prerequisites
execute_with_retry "apt update && apt -y install ca-certificates wget net-tools gnupg"

# Add the OpenVPN repository GPG key
execute_with_retry "wget -qO - https://as-repository.openvpn.net/as-repo-public.gpg | apt-key add -"

# Check for the existence of the sources.list.d directory
if [ ! -d /etc/apt/sources.list.d ]; then
    echo "The directory /etc/apt/sources.list.d does not exist. Creating it..."
    mkdir -p /etc/apt/sources.list.d
    if [ $? -ne 0 ]; then
        echo "Failed to create /etc/apt/sources.list.d. Exiting."
        exit 1
    fi
fi

# Add the OpenVPN repository
echo "deb http://as-repository.openvpn.net/as/debian jammy main" >/etc/apt/sources.list.d/openvpn-as-repo.list
if [ $? -ne 0 ]; then
    echo "Failed to add the OpenVPN repository. Exiting."
    exit 1
fi

# Update and install OpenVPN Access Server
execute_with_retry "apt update && apt -y install openvpn-as"


sleep 30
# Displaying the Cred
log_file="/usr/local/openvpn_as/init.log"
username=$(grep -oP 'use the "\K[^"]+' "$log_file")
password=$(grep -oP 'with "\K[^"]+(?=" password)' "$log_file")

echo "Username: $username"
echo "Password: $password"