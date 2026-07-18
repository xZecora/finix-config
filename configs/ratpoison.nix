{
  pkgs,
  ...
}:
{
  imports = [
    ./suckless/suckless.nix
  ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  programs.xorg = {
    enable = true;
    modules = [
      pkgs.xf86-video-amdgpu
    ];
  };

  hjem.users.vitrial.xdg.config.files = {
    "ratpoison/ratpoisonrc".source = ./dotfiles/ratpoisonrc;
    "Xresources".source = ./dotfiles/Xresources;
    "Xinitrc".source = ./dotfiles/Xinitrc;
    "picom.conf".source = ./dotfiles/picom.conf;
  };

  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ../packages/ratpoison.nix { })
    dzen2
    picom
    dunst
    nitrogen
    feh
    xxhash
    xdotool
    perl
    xrdb
    xrandr
    xset
    xsetroot
  ];
}
