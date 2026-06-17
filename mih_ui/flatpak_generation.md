To generate the flatpak version of MIH use the following commands in this folder.

## <gpg-sign-key>
dev-gpg-sign=B9F8044E4AE3D8AD

## Generate new yml file in generated folder
flutpak generate --tag <tag version>

## Build flatpak and push to repo folder
flatpak-builder --repo=repo --gpg-sign=<gpg-sign-key>
 --force-clean --user --install build-dir flatpak/generated/za.co.mzansiinnovationhub.mih.yml

## Download optimisation
flatpak build-update-repo --gpg-sign=<gpg-sign-key> --generate-static-deltas repo
