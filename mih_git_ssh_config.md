Add the following to your ~/.ssh/config file

Host git.mzansi-innovation-hub.co.za
    HostName git.mzansi-innovation-hub.co.za
    User git
    Port 222
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
    HostKeyAlgorithms +ssh-rsa
    PubkeyAcceptedKeyTypes +ssh-rsa
