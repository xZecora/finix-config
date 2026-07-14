{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (openmw.overrideAttrs (finalAttrs: {
      version = "0.51.0";
      src = fetchFromGitLab {
        owner = "OpenMW";
        repo = "openmw";
        tag = "openmw-${finalAttrs.version}";
        hash = "sha256-mPwNyKKqPSZJtcIyx3IhLe3iHOpx6p4+l1wJZqyDMqg=";
      };
    }))
  ];
}
