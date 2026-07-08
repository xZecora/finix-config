{ pkgs, ... }:
{
  imports = [
    ./morrowind.nix
    ./lutris.nix
  ];

  # programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    steam
    wineWow64Packages.base
    winetricks
    libstrangle
    r2modman
    gamescope
  ];
}
