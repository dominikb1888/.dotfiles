# mosh
# Autogenerated from man page /nix/store/wzlf72nqp8aifmhq7nz4ip5yigabwc2i-mosh-1.4.0/share/man/man1/mosh.1.gz
complete -c mosh -l client -d 'path to client helper on local machine (default: "mosh-client")'
complete -c mosh -l server -d 'command to run server helper on remote machine (default: "mosh-server")  The …'
complete -c mosh -l ssh -d 'OpenSSH command to remotely execute mosh-server on remote machine (default: "…'
complete -c mosh -l ssh-pty -d '--no-ssh-pty Enable or disable ssh\'s use of a pty when connecting to a remote…'
complete -c mosh -l predict -d 'Controls use of speculative local echo'
complete -c mosh -s a -d 'Synonym for --predict=always'
complete -c mosh -s n -d 'Synonym for --predict=never'
complete -c mosh -l predict-overwrite -d 'When prediction is enabled, do not insert speculative local echo before exist…'
complete -c mosh -s o -d 'Synonym for --predict-overwrite'
complete -c mosh -l family -d 'Only use IPv4 for the SSH connection and Mosh session'
complete -c mosh -s 4 -d 'Synonym for --family=inet'
complete -c mosh -s 6 -d 'Synonym for --family=inet6'
complete -c mosh -s p -l port -d 'Use a particular server-side UDP port or port range, for example, if this is …'
complete -c mosh -l bind-server -d 'Control the IP address that the mosh-server binds to'
complete -c mosh -l no-init -d 'Do not send the smcup initialization string and rmcup deinitialization string…'
complete -c mosh -l local -d 'Invoke mosh-server locally, without using ssh'
complete -c mosh -l no-ssh-pty -d 'Enable or disable ssh\'s use of a pty when connecting to a remote host'
complete -c mosh -l experimental-remote-ip -d 'Select the method used to discover the IP address that the mosh-client connec…'
complete -c mosh -l ssh-proxy-command -d 'option to generate and report the exact address that ssh uses to connect to t…'
