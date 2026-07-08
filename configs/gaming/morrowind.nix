{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (openmw.overrideAttrs (finalAttrs: {
      version = "0.51.0";
      src = fetchFromGitLab {
        owner = "OpenMW";
        repo = "openmw";
        tag = "openmw-${finalAttrs.version}";
        hash = "sha256-D+2nEQRkAjmDvRoas9bYPmdygQYT3MAv46n73OonE0o=";
      };
    }))
  ];
}
