# Esquema de particionado — WDC WDS240G2G0A-00JH30 240 GB SATA SSD
#
# ⚠  ANTES DE USAR: verifica que el disco correcto es /dev/sda con:
#      lsblk -o NAME,SIZE,MODEL,SERIAL
#    Busca "WDC" o "WDS240G2G0A"
#    Si es /dev/sdb, cambia "device" abajo.
#
# Uso (desde NixOS live ISO):
#   nix run github:nix-community/disko -- --mode destroy,format,mount ./disko.nix
#   nixos-install --flake .#rene
{
  disko.devices = {
    disk = {
      main = {
        type   = "disk";
        device = "/dev/sda";  # WDC 240 GB SATA — verificar con lsblk

        content = {
          type = "gpt";
          partitions = {

            # EFI System Partition (512 MB)
            ESP = {
              size    = "512M";
              type    = "EF00";
              content = {
                type       = "filesystem";
                format     = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "fmask=0022" "dmask=0022" ];
              };
            };

            # Root (resto del disco ~239 GB)
            root = {
              size    = "100%";
              content = {
                type       = "filesystem";
                format     = "ext4";
                mountpoint = "/";
                mountOptions = [ "noatime" "nodiratime" ];
              };
            };

          };
        };
      };

    };
  };
}
