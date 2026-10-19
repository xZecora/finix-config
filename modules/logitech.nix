{
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = [
    pkgs.libratbag
    pkgs.piper

  ];

  services.udev.packages = [ pkgs.logitech-udev-rules ];

  finit.services.ratbagd = {
    command = "${lib.getExe' pkgs.libratbag "ratbagd"}";
    runlevels = "S12345789";
    conditions = "service/dbus/ready";
  };
}
