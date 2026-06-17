To generate the flatpak version of MIH use the following commands in this folder.

## Generate new yml file in generated folder
flutpak generate --tag <tag version>

## Build flatpak and push to repo folder
flatpak-builder --repo=repo --gpg-sign=B9F8044E4AE3D8AD --force-clean build-dir flatpak/generated/za.co.mzansiinnovationhub.mih.yml
