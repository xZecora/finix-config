{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (pkgs.dmenu.overrideAttrs (_: {
      src = pkgs.fetchFromGitHub {
        owner = "bakkeby";
        repo = "dmenu-flexipatch";
        rev = "ce504573d0fba602678c79a650830ee74e9e35ca";
        sha256 = "sha256-1PN/71sfu1LoFDxyDzG3JzSTqusbt18zrMG6Qbgucaw=";
      };
      #buildInputs = with pkgs; [ xorg.libX11 xorg.libXinerama libxft cmake ];

      patches = [ ./config/nix-dmenu.diff ];
    }))
    (pkgs.st.overrideAttrs (_: {
      src = pkgs.fetchgit {
        url = "https://github.com/bakkeby/st-flexipatch";
        rev = "9edb8d86fb5a5c3fa3141edb811bf4b444468e5e";
        sha256 = "sha256-bK8PxuH+FBM/WNlVeRY44tKOiMcfTQfT2g6zayLdJCE=";
      };
      patches = [ ./config/nix-st-flexipatch.diff ];
      buildInputs = [
        harfbuzz
        freetype
        libxft
      ];
    }))
    #(pkgs.st.overrideAttrs (_: {
    #  src = pkgs.fetchgit {
    #    url = "https://git.suckless.org/st";
    #    rev = "688f70add0d1da8a416bf7df763328d694a24a3a";
    #    sha256 = "sha256-PUMhcvPy63G9qQ3S8kTBLXf4RmPlPDRA61c35tspBu4=";
    #  };
    #  patches = [ ./config/nix-st.diff ];
    #  buildInputs = [ harfbuzz freetype libxft ];
    #}))
  ];
}
