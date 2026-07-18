{
  lib,
  config,
  hjem-lib,
  name,
  ...
}:
let
  cfg = config;
  fileTypeRelativeTo' =
    rootDir:
    lib.types.attrsWith {
      elemType = hjem-lib.fileTypeRelativeTo {
        inherit rootDir;
        clobberDefault = cfg.clobberFiles;
        clobberDefaultText = lib.literalExpression "config.hjem.users.${name}.clobberFiles";
      };
      placeholder = "path";
    };
in
{
  options = {
    bin = {
      directory = lib.mkOption {
        type = lib.types.str;
        default = "${cfg.directory}.local/bin/";
      };
      files = lib.mkOption {
        default = { };
        type = fileTypeRelativeTo' cfg.bin.directory;
      };
    };
  };

  config = {
    files = lib.mkMerge [
      (lib.attrsets.mapAttrs' (
        n: v:
        lib.attrsets.nameValuePair (".local/bin/" + n) {
          inherit (v) text source;
          target = ".local/bin/" + n;
        }
        # lib.attrsets.filterAttrs (n: _: n != "source") v
        # )
      ) cfg.bin.files)
    ];
  };
}
