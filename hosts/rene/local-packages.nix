{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Herramientas de desarrollo
    gcc
    git
    curl
    wget
    
    # Utilidades
    neofetch
    htop
    lm_sensors
    
    # NTFS support
    ntfs3g
    
    # GPU tools (AMD)
    amdvlk
    rocmPackages.clr.icd
  ];
}
