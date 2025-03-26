{ pkgs, ... }:

let
  myAliases = {
    ll = "ls -l";
    fastfetch = "/usr/libexec/ublue-fastfetch";
  };
  sourceShD = "
    source ~/.sh.d/*
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
    initExtra = sourceShD;

#    initExtra = ''
#    PROMPT=" ◉ %U%F{magenta}%n%f%u@%U%F{blue}%m%f%u:%F{yellow}%~%f
#     %F{green}→%f "
#    RPROMPT="%F{red}▂%f%F{yellow}▄%f%F{green}▆%f%F{cyan}█%f%F{blue}▆%f%F{magenta}▄%f%F{white}▂%f"
#    [ $TERM = "dumb" ] && unsetopt zle && PS1='$ '
#    bindkey '^P' history-beginning-search-backward
#    bindkey '^N' history-beginning-search-forward
#    '';

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      # theme = "robbyrussell";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    direnv nix-direnv
  ];
}

