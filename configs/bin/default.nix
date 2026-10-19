{
  lib,
  pkgs,
  config,
  ...
}:
let
  writeDashScript =
    name: text:
    pkgs.writeTextFile {
      inherit name;
      executable = true;
      text = ''
        #!${lib.getExe pkgs.dash}
        ${text}
      '';
    };
in
{
  hjem.users.vitrial.bin.files = {
    "screenshot".source = writeDashScript "screenshot" ''
      if [ $@ == ""]; then
        ${lib.getExe pkgs.maim} -suo | ${lib.getExe pkgs.xclip} -selection clipboard -t image/png
      else
        ${lib.getExe pkgs.maim} $@ | ${lib.getExe pkgs.xclip} -selection clipboard -t image/png
      fi
    '';

    "dmenu_command.sh".source = writeDashScript "dmenu_command" ''
      # Import the colors
      FG="$(xrdb -get foreground)"
      BG="$(xrdb -get background)"

      RED="$(xrdb -get color1)"
      GREEN="$(xrdb -get color2)"
      # YELLOW="$(xrdb -get color3)"
      BLUE="$(xrdb -get color4)"
      # MAGENTA="$(xrdb -get color5)"
      # ORANGE="$(xrdb -get color6)"
      # WHITE="$(xrdb -get color7)"

      ARG=""
      if [ "$1" = "-b" ]; then
        ARG="-bw $2"
        shift
        shift
      fi

      ${lib.getExe' config.programs.coreutils.package "cat"} | dmenu -vi 1 $ARG -l 20 -nb $BG -nf $FG -sb $BLUE -sf $BG -shb $GREEN -shf $RED -nhf $RED -nhb $BG -fn "FiraCode NerdFont:pixelsize=18" "$@"
    '';

    "greek.sh".source = writeDashScript "greek.sh" ''
      ARGS="-vi -c -bw 5"

      # Get user selection via dmenu from emoji file.
      chosen=$(${lib.getExe' config.programs.coreutils.package "cat"} ~/.local/share/greek | dmenu_command.sh $ARGS | sed "s/ .*//")

      # Exit if none chosen.
      [ -z "$chosen" ] && exit

      # If you run this command with an argument, it will automatically insert the
      # character. Otherwise, show a message that the emoji has been copied.
      if [ -n "$1" ]; then
      	${lib.getExe pkgs.xdotool} type "$chosen"
      else
      	printf "$chosen" | ${lib.getExe pkgs.xclip} -selection clipboard
      fi
    '';

    "emoji.sh".source = writeDashScript "emoji.sh" ''
      ARGS="-vi -c -bw 5"

      # Get user selection via dmenu from emoji file.
      chosen=$(${lib.getExe' config.programs.coreutils.package "cat"} ~/.local/share/emoji | dmenu_command.sh $ARGS | sed "s/ .*//")

      # Exit if none chosen.
      [ -z "$chosen" ] && exit

      # If you run this command with an argument, it will automatically insert the
      # character. Otherwise, show a message that the emoji has been copied.
      if [ -n "$1" ]; then
      	${lib.getExe pkgs.xdotool} type "$chosen"
      else
      	printf "$chosen" | ${lib.getExe pkgs.xclip} -selection clipboard
      fi
    '';
  };
}
