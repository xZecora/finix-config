{ pkgs, ... }:
{
  # nixpkgs.config.qt6 = {
  #   enable = true;
  #   platformTheme = "qt6ct";
  #   style = {
  #     package = pkgs.utterly-nord-plasma;
  #     name = "Utterly Nord Plasma";
  #   };
  # };

  security.pam.environment = {
    QT_QPA_PLATFORMTHEME.default = "qt6ct";
  };

  environment.systemPackages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
    kdePackages.qt6ct
    kdePackages.breeze-gtk
    kdePackages.breeze
    kdePackages.breeze-icons
    everforest-cursors
    everforest-gtk-theme
    lxappearance
  ];

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.meslo-lg
      fira-code
      fira-code-symbols
      liberation_ttf
      noto-fonts
      # noto-fonts-cjk-serif
      noto-fonts-color-emoji
      wqy_zenhei
    ];

    fontconfig = {
      defaultFonts.monospace = [ "FiraCode Nerd Font Mono" ];
      enable = true;
    };
  };

  hjem.users.vitrial.pointer = {
    enable = true;
    package = pkgs.everforest-cursors;
    name = "everforest-cursors-light";
  };

  hardware.console = {
    # earlySetup = true;
    # font = "${pkgs.terminus_font}/share/consolefonts/ter-118b.psf.gz";
    # packages = with pkgs; [ terminus_font ];
    colors = [
      "1E2127"
      "E06C75"
      "98C379"
      "D19A66"
      "5B9BB3"
      "C678DD"
      "56B6C2"
      "ABB2BF"
      "5C6370"
      "E06C75"
      "98C379"
      "D19A66"
      "5B9BB3"
      "C678DD"
      "56B6C2"
      "FFFFFF"
    ];
  };
}
