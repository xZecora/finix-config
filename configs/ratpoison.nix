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

  environment.etc = {
    "X11/xorg.conf.d/90-vrr.conf".text = ''
      Section "OutputClass"
        Identifier "AMD"
        MatchDriver "amdgpu"
        Driver "amdgpu"
        Option "TearFree" "false"
        Option "VariableRefresh" "true"
        Option "AsyncFlipSecondaries" "false"
      EndSection
    '';
    "X11/xorg.conf.d/99-logitech.conf".text = ''
      Section "InputClass"
        Identifier "pointer:Logitech G502"
        Driver "libinput"
        Option "HighResolutionWheelScrolling" "0"
      EndSection
    '';
  };

  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ../packages/ratpoison.nix { })
    dzen2
    picom
    dunst
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
