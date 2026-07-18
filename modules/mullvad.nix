{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.mullvad-vpn;
in
with lib;
{
  options.services.mullvad-vpn = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        This option enables Mullvad VPN daemon.
      '';
    };

    enableEarlyBootBlocking = mkOption {
      type = types.bool;
      default = false;
      description = ''
        This option activates an additional oneshot systemd service to ensure that the mullvad daemon
        will start and block traffic before any network configuration will be applied.
        This matches what upstream Mullvad distributes for their supported distros, but is disabled by
        default in NixOS as it may conflict with non-Mullvad network configuration.
      '';
    };

    package = mkPackageOption pkgs "mullvad" {
      example = "pkgs.mullvad-vpn";
      extraDescription = ''
        `pkgs.mullvad` only provides the CLI tool, `pkgs.mullvad-vpn` provides both the CLI and the GUI.
      '';
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "tun" ];

    environment.systemPackages = [ cfg.package ];

    finit = {
      run.mullvad-early-boot-blocking = mkIf cfg.enableEarlyBootBlocking {
        description = "Mullvad VPN Daemon";
        command = "${getExe' cfg.package "mullvad-daemon"} --initialize-early-boot-firewall";
        runlevels = "S12345789";
        log = true;
      };

      services = {
        mullvad-daemon = {
          # type = "forking";
          # pid = "/run/rpc.statd.pid";
          description = "Mullvad VPN Daemon";
          command = "${getExe' cfg.package "mullvad-daemon"} -v --disable-stdout-timestamps";
          conditions = [
            "service/syslogd/ready"
          ]
          ++ lib.optional cfg.enableEarlyBootBlocking "run/mullvad-early-boot-blocking/success";
          log = true;
        };
      };
    };
  };
}
