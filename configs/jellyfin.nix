{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    jellyfin-mpv-shim
    jellyfin-desktop
  ];

  hjem.users.vitrial.dinit.services.jellyfin-mpv-shim = {
    type = "process";
    command = "${lib.getExe pkgs.jellyfin-mpv-shim} --gui";
    restart = true;
    depends-ms = [ "graphical.target" ];
  };
}
