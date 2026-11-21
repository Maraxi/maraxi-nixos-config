{ mutableLink, ... }: {
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        insert_final_newline = true;
        trim_trailing_whitespace = true;
      };
      # Whitespace is significant: a context line of a hunk is " " + empty line.
      # This also covers `git add -p` -> `e`, which edits `addp-hunk-edit.diff`.
      "*.{diff,patch}" = {
        trim_trailing_whitespace = false;
      };
      "*.py" = {
        indent_size = 4;
        indent_style = "space";
      };
    };
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
  xdg.configFile."starship.toml" = mutableLink dotfiles/starship.toml;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [
      "--cmd"
      "cd"
    ];
  };

  programs.eza = {
    enable = true;
    icons = "auto";
    extraOptions = [ "--group-directories-first" ];
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    defaultOptions = [ "--bind ctrl-up:preview-half-page-up,ctrl-down:preview-half-page-down" ];
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--max-columns-preview"
      "--max-columns=225"
      "--heading"
      "--follow"
    ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    config = {
      global.strict_env = true;
    };
  };

  programs.lesspipe.enable = true;
  xdg.configFile."lesskey" = mutableLink dotfiles/lesskey;

  xdg.configFile."fd" = mutableLink dotfiles/fd;

  xdg.configFile."bat/config" = mutableLink dotfiles/bat;

  xdg.dataFile."ipython/profile_default/ipython_config.py".text = ''
    c = get_config()
    c.TerminalInteractiveShell.confirm_exit = False
  '';

}
