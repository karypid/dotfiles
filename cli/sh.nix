{ pkgs, ... }:

let
  myAliases = {
    ll = "ls -l";
    fastfetch = "/usr/libexec/ublue-fastfetch";
    mgs = "rm ~/devroot/wc.git/.mgitstatus_last_check ; mgitstatus -d 3 ~/devroot/wc.git";
  };
  sourceShD = "
    for f in ~/.sh.d/* ; do source \"$f\" ; done
  ";
in
{
  home.file = {
    ".sh.d" = {
      source = ./sh.d;
      recursive = true;
    };
  };

  programs.bash = {
    shellAliases = myAliases;
    enable = true;
    enableCompletion = true;
    bashrcExtra = sourceShD;
  };

  programs.zsh = {
    shellAliases = myAliases;
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true; 
    initContent = sourceShD;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
  };

  home.packages = with pkgs; [
    direnv nix-direnv
    starship
  ];
}

