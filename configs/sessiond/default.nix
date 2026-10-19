{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.sessiond.finixModules.default
    inputs.sessiond-hooks.finixModules.default
    inputs.sessiond-uaccess.finixModules.default
  ];

  environment.systemPackages = [
    pkgs.dinit
  ];

  services = {
    sessiond-uaccess = {
      enable = true;
      package = pkgs.sessiond-uaccess.override {
        udev = pkgs.libudev-garden;
      };
      logLevel = "debug";
      extraRules = { };
    };
    sessiond-hooks = {
      package = inputs.sessiond-hooks.packages.${pkgs.stdenv.hostPlatform.system}.default;
      logLevel = "debug";
      hooks.dinit = {
        configFile = pkgs.writeText "sessiond-hooks-config.dhall" ''
          let Hooks = env:SESSIOND_HOOKS

          in \(ctx : Hooks.Context) ->
            { init = "${lib.getExe' pkgs.dinit "dinit"}"
            , args =
                [ "--user"
                , "--services-dir"
                , "''${ctx.home}/.config/dinit.d"
                , "--services-dir"
                , "/etc/dinit.d/user"
                ]
            , restart = Hooks.restart.always
            }
        '';
      };
    };
    sessiond = {
      enable = true;
      # package = pkgs.callPackage ./package.nix { };
      package = pkgs.sessiond;
      logLevel = "debug";
      settings = {
        power = {
          reboot = [ "${pkgs.finit}/bin/reboot" ];
          poweroff = [ "${pkgs.finit}/bin/poweroff" ];
        };
      };
    };
  };
}
