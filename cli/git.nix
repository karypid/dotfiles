{ config, pkgs, userSettings, ... }:

{
  home.packages = [
    pkgs.riffdiff
    pkgs.git
    pkgs.mgitstatus
  ];
  programs.git = {
    enable = true;
    userName = userSettings.name;
    userEmail = userSettings.email;
    ignores = import ./gitignore_global.nix;
    extraConfig = {
      init.defaultBranch = "main";
    };
    #riff.enable = true;
  };
}
