{
  lib,
  pkgs,
  config,
  ...
}:
let
  bus_socket = "unix:path=$XDG_RUNTIME_DIR/bus";
in
{
  hjem.users.vitrial.dinit.services = {
    pipewire = {
      type = "process";
      command = "${lib.getExe' config.programs.pipewire.package "pipewire"}";
      restart = true;
      depends-ms = [ "login.target" ];
    };
    pipewire-pulse = {
      type = "process";
      command = "${lib.getExe' config.programs.pipewire.package "pipewire-pulse"}";
      restart = true;
      prepared-by = [ "pipewire" ];
    };
    wireplumber = {
      type = "process";
      command = "${lib.getExe' config.programs.wireplumber.package "wireplumber"}";
      restart = true;
      prepared-by = [ "pipewire-pulse" ];
    };

    dbus-session = {
      type = "process";
      command = "${lib.getExe' pkgs.dbus "dbus-daemon"} --session --address=${bus_socket}";
      restart = true;
      before = [ "login.target" ];
    };

    dbus-session-address = {
      type = "scripted";
      command = "${lib.getExe' pkgs.dinit "dinitctl"} setenv DBUS_SESSION_BUS_ADDRESS=${bus_socket}";
      depends-on = [ "dbus-session" ];
    };
  };
}
