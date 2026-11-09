{ pkgs, ... }: {
  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.symbols-only # icons for waybar
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
    fontconfig.defaultFonts = {
      serif = [
        "Noto Serif"
        "Source Han Serif"
      ];
      sansSerif = [
        "Noto Sans"
        "Source Han Sans"
      ];
    };
  };
}
