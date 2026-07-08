{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mpd
    mpd-mpris
    playerctl
  ];
}
