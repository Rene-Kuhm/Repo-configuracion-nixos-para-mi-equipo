{ lib, ... }:

{
  # Configuración del monitor Ultrawide 3440x1440
  wayland.windowManager.hyprland.settings = {
    monitor = [
      ",preferred,auto,1"
    ];

    exec-once = [
      "waybar"
    ];
  };
}
