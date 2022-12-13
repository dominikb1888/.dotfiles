function vup
    read -p 'echo "Password: "' -ls pass
    echo $pass | sudo openconnect --user=dboehler --authgroup=vpn-pers.th-deg.de --servercert=pin-sha256:LNGrG5QDtA2WZ8TRTaZOTy7ZfE7H8HHSPprwHvvTOVc= vpn.th-deg.de --protocol=anyconnect --passwd-on-stdin --background
end
