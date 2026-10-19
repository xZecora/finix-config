{
  lib,
  writeDash,
  xclip,
}:
writeDash "greek.sh" ''
  ARGS="-vi -c -bw 5"

  # Get user selection via dmenu from emoji file.
  chosen=$(cat ~/.local/share/greek | dmenu_command.sh $ARGS | sed "s/ .*//")

  # Exit if none chosen.
  [ -z "$chosen" ] && exit

  # If you run this command with an argument, it will automatically insert the
  # character. Otherwise, show a message that the emoji has been copied.
  if [ -n "$1" ]; then
  	xdotool type "$chosen"
  else
  	printf "$chosen" | ${lib.getExe xclip} -b
  fi
''
