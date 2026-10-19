{
  lib,
  writeDashBin,
  maim,
  xclip,
}:
writeDashBin "screenshot" ''
  ${lib.getExe maim} -so | ${lib.getExe xclip} -selection clipboard -t image/png
''
