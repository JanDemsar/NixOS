{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ fzf zsh-completions xclip exa fd ripgrep ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      command_timeout = 50; # It's very noticable and anoying beyond this
      add_newline = false;
      character = {
        success_symbol = "[»](bold green)";
        error_symbol = "[»](bold green)";
        vicmd_symbol = "[«](bold green)";
      };
      username = {
        disabled = false;
        show_always = true;
        style_root = "bold red";
        style_user = "blue yellow";
        format = "[$user]($style)";
      };
      hostname = {
        disabled = false;
        ssh_only = false;
        style = "bold dimmed green";
        format = "[@$hostname]($style)";
      };
      directory = {
        truncation_length = 10;
        disabled = false;
        truncate_to_repo = false;
        style = "bold cyan";
        format = "[:$path]($style)";
      };
      git_branch = {
        style = "bold purple";
        format = "[ $symbol$branch]($style)";
      };
      git_commit = {
        only_detached = false;
        tag_disabled = false;
        tag_symbol = ":";
        format = "[\\($hash$tag\\)]($style)";
      };
      git_status = {
        disabled = false;
        conflicted = "🏳";
        untracked = "🤷";
        stashed = "📦";
        modified = "📝";
        staged = "[++\($count\)](green)";
        up_to_date = "✓";
        ahead = "⇡\($count\)";
        diverged = "⇕⇡\($ahead_count\)⇣\($behind_count\)";
        behind = "⇣\($count\)";
        style = " bold yellow";
        format = "[\\[$all_status$ahead_behind\\]]($style)";
      };
      nix_shell = {
        symbol = "❄️";
        style = "bold blue";
        format = "[ $symbol  $name ]($style)";
      };
      cmake.disabled = true;
      python.disabled = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    shellAliases = {
      ls = "exa --group-directories-first --color=always --icons";
      l = "ls -la";
      ll = "ls -l";
      xclip = "xclip -selection clipboard";

      # System
      reboot = "read -s \\?\"Reboot? [ENTER]: \" && if [ -z \"$REPLY\" ];then env reboot;else echo \"Canceled\";fi";
      poweroff = "read -s \\?\"Poweroff? [ENTER]: \" && if [ -z \"$REPLY\" ];then env poweroff;else echo \"Canceled\";fi";
      udevreload = "sudo udevadm control --reload-rules && sudo udevadm trigger";
    };

    history = {
      size = 10000;
      ignoreDups = true;
      expireDuplicatesFirst = true;
      share = false;
      path = "$HOME/.cache/zsh/history";
    };

    initExtra = ''
      autoload -U colors && colors
      autoload -U compinit && compinit
      
      zstyle ':completion:*' menu select
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      _comp_options+=(globdots)


      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh


      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/lib/zsh-ls-colors/ls-colors.zsh


      # Add history command complete
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      bindkey "^[[A" history-substring-search-up
      bindkey "^[[B" history-substring-search-down      

      # F$cked keys, give them back
      bindkey "^[[3~" delete-char
      bindkey "^[[3;5~" delete-char
      bindkey '^H' backward-kill-word
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word
      bindkey '\e[11~' "urxvt &\n"

      # Add paths that can be missing sometimes (non-nixos)
      export PATH=$PATH:/usr/sbin:/usr/local/sbin
    '';
  };

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = 1;
    TERM = "xterm-256color";
  };
}

