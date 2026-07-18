{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.iproute2-static;
in
{
  options.services.iproute2-static = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.iproute2;
    };

    interface = lib.mkOption {
      type = lib.types.str;
      default = "eth0";
    };

    localInfo = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = ''
        192.168.0.255/24 brd +
      '';
    };

    routerIP = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = ''
        192.168.0.1
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    finit.tasks = {
      iproute2-static = {
        description = "static network configuration service";
        command = pkgs.writeShellScript "static-network" ''
          ip link set ${cfg.interface} up
          ip address add ${cfg.localInfo} dev ${cfg.interface}
          ip route add ${cfg.routerIP} dev ${cfg.interface}
          ip route add default via ${cfg.routerIP} dev ${cfg.interface}
        '';
        conditions = "net/${cfg.interface}/exist";
        log = true;
        runlevels = "12345789";
        path = [
          cfg.package
        ];
      };
    };
  };
}
