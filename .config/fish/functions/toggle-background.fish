function toggle-background
    if test "$term_background" = light
        set -U term_background dark
    else
        set -U term_background light
        vpn = "echo "4pTH2WWb" | sudo openconnect --user=dboehler --authgroup=vpn-pers.th-deg.de  --servercert=pin-sha256:oRlBtC/kdoY5pS/VI1R88WGkUbDmbTWev33Sfxmfb5Q= vpn.th-deg.de --protocol=anyconnect --passwd-on-stdin --background"
    end
end
