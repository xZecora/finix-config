{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    mpd
    mpd-mpris
    playerctl
    mpc
  ];

  hjem.users.vitrial = {
    xdg.config.files = {
      "mpd/mpd.conf".text = ''
        music_directory "/server/music/music/"
        db_file         "~/.config/mpd/database"
        state_file      "~/.config/mpd/state"
        local_permissions "read,add,player,control,admin"
        audio_output {
          type            "pipewire"
          name            "PipeWire output"
        }
      '';
    };

    dinit.services = {
      mpd = {
        type = "process";
        command = "${lib.getExe' pkgs.mpd "mpd"} --no-daemon";
        restart = true;
        depends-ms = [ "login.target" ];
      };

      mpd-mpris = {
        type = "process";
        command = "${lib.getExe' pkgs.mpd-mpris "mpd-mpris"} -no-instance";
        restart = true;
        prepared-by = [ "mpd" ];
        depends-on = [ "mpd" ];
        after = [ "dbus-session-address" ];
      };

      playerctld = {
        type = "process";
        command = "${lib.getExe' pkgs.playerctl "playerctld"}";
        restart = true;
        after = [ "dbus-session-address" ];
      };
    };
  };
}
