{ pkgs, ... }:
{
  environment.etc."security/limits.conf".text = ''
    vitrial hard nofile 524288
    vitrial soft nofile 524288
  '';

  environment.systemPackages = with pkgs; [
    lutris
  ];
}
