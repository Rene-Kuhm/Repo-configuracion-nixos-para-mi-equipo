{ pkgs, inputs, ... }: {
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

    # AI Coding Assistants
    opencode
    codex
  ] ++ [
    # Claude Code (del flake externo)
    inputs.claude-code.packages.${pkgs.system}.claude-code
  ];
}
