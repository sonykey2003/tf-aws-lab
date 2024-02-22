
# Displaying the Cred
log_file="/usr/local/openvpn_as/init.log"
username=$(grep -oP 'use the "\K[^"]+' "$log_file")
password=$(grep -oP 'with "\K[^"]+(?=" password)' "$log_file")

echo "Username: $username"
echo "Password: $password"