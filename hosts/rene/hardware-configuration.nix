# Hardware configuration — Gigabyte Z790 AORUS ELITE AX DDR4
# CPU  : Intel Core i7-14700F (20 cores / 28 threads)
# GPU  : AMD Radeon RX 6600 XT
# RAM  : 32 GB DDR4 Kingston 3200 MHz
# Disk : WDC WDS240G2G0A-00JH30 240 GB SATA SSD (NixOS)
#        SHPP41-2000GM 2 TB NVMe               (Windows — no tocar)
#        Lexar 240 GB SATA SSD                 (data/backup)
# Net  : Realtek Gaming 2.5 GbE (r8169) + Intel AX211 Wi-Fi 6E
#
# NOTA: Los UUID se generan automáticamente con disko
#       Si necesitas regenerar: nixos-generate-config --root /mnt
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ── Kernel modules ────────────────────────────────────────────────────────
  boot.initrd.availableKernelModules = [
    "nvme"        # NVMe
    "xhci_pci"    # USB 3.x
    "ahci"        # SATA
    "usb_storage" # USB mass storage
    "sd_mod"      # SCSI disk driver
  ];

  # amdgpu en initrd → KMS temprano
  boot.initrd.kernelModules = [ "amdgpu" ];

  # kvm-intel: virtualización hardware (Intel VT-x)
  boot.kernelModules = [ "kvm-intel" ];

  boot.extraModulePackages = [ ];

  # ── Filesystems ───────────────────────────────────────────────────────────
  # Los UUID se configuran automáticamente con disko
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
    fsType = "ext4";
    options = [ "noatime" "nodiratime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/XXXX-XXXX";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  # Opcional: montar SSD WDC o Lexar como /data
  # fileSystems."/data" = {
  #   device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
  #   fsType = "ext4";
  #   options = [ "noatime" ];
  # };

  # Sin swap en disco — usamos ZRAM
  swapDevices = [ ];

  # ── Red ───────────────────────────────────────────────────────────────────
  networking.useDHCP = lib.mkDefault true;

  # ── CPU y firmware ────────────────────────────────────────────────────────
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Microcode Intel
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Firmware redistributable
  hardware.enableRedistributableFirmware = true;
}
