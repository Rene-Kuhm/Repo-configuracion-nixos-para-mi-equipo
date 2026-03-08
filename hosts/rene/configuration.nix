{ pkgs, stateVersion, hostname, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ./monitors.nix
    ../../nixos/modules
  ];

  # Timezone Argentina
  time.timeZone = "America/Argentina/Buenos_Aires";

  # Locale español
  i18n.defaultLocale = "es_AR.UTF-8";

  # home-manager ya disponible en PATH
  environment.systemPackages = [ pkgs.home-manager ];

  networking.hostName = hostname;

  system.stateVersion = stateVersion;

  # ── Overrides específicos de esta máquina ─────────────────────────────────

  # NTFS para acceder al SSD Windows (NVMe 2 TB)
  boot.supportedFilesystems = [ "ntfs" ];

  # Unfree global (AMD drivers binarios, Steam, etc.)
  nixpkgs.config.allowUnfree = true;

  # Kernel params para Z790 — estabilidad y performance
  boot.kernelParams = [
    "intel_iommu=on"    # IOMMU habilitado (para VM GPU passthrough si se necesita)
    "iommu=pt"          # passthrough mode — no penaliza rendimiento si no hay passthrough
    "nowatchdog"        # desactiva watchdog → menos latencia
    "mitigations=auto"  # mitigaciones Intel (auto = seguro por defecto)
  ];

  # Scheduler de I/O: mq-deadline para SSDs
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="0", \
      ATTR{queue/scheduler}="mq-deadline"
    ACTION=="add|change", KERNEL=="nvme*", ATTR{queue/scheduler}="none"
  '';
}
