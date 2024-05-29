{lib, ...}: {
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    colors = lib.mkOverride 500 {
      bright = {
        black = "#575656";
        blue = "#82aaff";
        cyan = "#7fdbca";
        green = "#22da6e";
        magenta = "#c792ea";
        red = "#ef5350";
        white = "#ffffff";
        yellow = "#ffeb95";
      };
      cursor = {
        cursor = "#d6deeb";
        text = "#011627";
      };
      normal = {
        black = "#011627";
        blue = "#82aaff";
        cyan = "#21c7a8";
        green = "#22da6e";
        magenta = "#c792ea";
        red = "#ef5350";
        white = "#ffffff";
        yellow = "#c5e478";
      };
      primary = {
        background = "#011627";
        foreground = "#d6deeb";
      };
      selection = {
        background = "#1b90dd";
      };
    };
    keyboard.bindings = [
      {
        action = "SpawnNewInstance";
        key = "Return";
        mods = "Control|Shift";
      }
    ];
    window = {
      dynamic_title = true;
      opacity = 0.8;
    };
    window.padding = {
      x = 4;
      y = 0;
    };
  };
}
