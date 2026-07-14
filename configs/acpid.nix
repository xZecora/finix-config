{ lib, config, ... }:
{
  services.acpid = {
    enable = true;
    handlers = {
      "power-button" = {
        event = "button/power.*";
        action = "${lib.getExe' config.finit.package "poweroff"}";
      };
    };
  };
}
