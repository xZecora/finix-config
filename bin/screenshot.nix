{
  lib,
  writeShellScriptBin,
  maim,
  xclip,
}:
writeShellScriptBin "screenshot" ''
  ${lib.getExe maim} -so | ${lib.getExe xclip} -selection clipboard -t image/png
''
