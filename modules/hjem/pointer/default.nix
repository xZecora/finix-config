{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) modules options types;

  mkIndexTheme =
    name:
    pkgs.writeTextFile {
      name = "index.theme";
      destination = "/share/icons/default/index.theme";
      text = ''
        [Icon Theme]
        Name=Default
        Comment=Default Cursor Theme
        Inherits=${name}
      '';
    };
in
{
  options.pointer = {
    enable = options.mkEnableOption "pointer cursor configuration";

    package = options.mkOption {
      type = types.nullOr types.package;
      default = null;
      example = options.literalExpression "pkgs.vanilla-dmz";
      description = "Package providing the cursor theme.";
    };

    name = options.mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "Vanilla-DMZ";
      description = "The cursor name within the package.";
    };

    size = options.mkOption {
      type = types.int;
      default = 32;
      example = 64;
      description = "The cursor size.";
    };

    dotIcons.enable = options.mkEnableOption "generate ~/.icons cursor links" // {
      default = true;
    };

    hyprcursor = {
      enable = options.mkEnableOption "set HYPRCURSOR_* variables";

      size = options.mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "The cursor size for hyprcursor.";
      };
    };
  };

  config =
    let
      cfg = config.pointer;
    in
    lib.mkIf cfg.enable (
      let
        indexTheme = mkIndexTheme cfg.name;
        finalHyprcursorSize = if cfg.hyprcursor.size != null then cfg.hyprcursor.size else cfg.size;
      in
      modules.mkMerge [
        {
          assertions = [
            {
              assertion = cfg.package != null && cfg.name != null;
              message = "pointer: set both `package` and `name`.";
            }
          ];
        }

        {
          packages = [
            cfg.package
            indexTheme
          ];

          environment.sessionVariables = {
            XCURSOR_SIZE = lib.mkDefault (toString cfg.size);
            XCURSOR_THEME = lib.mkDefault cfg.name;
            XCURSOR_PATH = lib.mkDefault "${config.directory}/.local/share/icons";
          };

          xdg.data.files."icons/default/index.theme".source = "${indexTheme}/share/icons/default/index.theme";
          xdg.data.files."icons/${cfg.name}".source = "${cfg.package}/share/icons/${cfg.name}";
        }

        (lib.mkIf cfg.dotIcons.enable {
          files.".icons/default/index.theme".source = "${indexTheme}/share/icons/default/index.theme";
          files.".icons/${cfg.name}".source = "${cfg.package}/share/icons/${cfg.name}";
        })

        (lib.mkIf cfg.hyprcursor.enable {
          environment.sessionVariables = {
            HYPRCURSOR_THEME = lib.mkDefault cfg.name;
            HYPRCURSOR_SIZE = lib.mkDefault (toString finalHyprcursorSize);
          };
        })
      ]
    );
}
