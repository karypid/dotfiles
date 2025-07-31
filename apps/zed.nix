{ config, pkgs, userSettings, ... }:

{
  home.packages = with pkgs; [
    #wayland
    #libdrm
    mesa
    #mesa.drivers
    # vulkan-tools
    zed-editor
  ];
}

