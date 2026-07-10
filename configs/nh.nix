{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nh
  ];

  security.pam.environment = {
    NH_FLAKE.default = "/home/vitrial/.config/system";
    NH_ELEVATION_STRATEGY.default = "doas";
  };
}
