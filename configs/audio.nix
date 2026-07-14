{ pkgs, ... }:
{
  programs.pipewire = {
    enable = true;
    alsa.enable = true;
    # package = pkgs.callPackage ../packages/pipewire/package.nix { };
  };

  programs.wireplumber.enable = true;
}
