# Esquema de particionado — SHPP41-2000GM 2 TB NVMe
#
# ⚠  ANTES DE USAR: verifica que el disco correcto es /dev/nvme0n1 con:
#      lsblk -o NAME,SIZE,MODEL,SERIAL
#    Busca "SHPP41" o serial equivalente
#    Si es /dev/nvme1n1, cambia "device" abajo.
#
# Uso (desde NixOS live ISO):
#   nix run github:nix-community/disko -- --mode destroy,format,mount ./disko.nix
#   nixos-install --flake .#rene
{
  disko.devices = {
    disk = {
      main = {
        type   = "disk";
        device = "/dev/nvme0n1";  # SHPP41-2000GM 2TB NVMe — verificar con lsblk

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

            # Root (resto del disco ~1991 GB)
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
