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
    # (pkgs.surf.overrideAttrs (_: {
    #   src = pkgs.fetchgit {
    #     url = "https://github.com/bakkeby/surf-flexipatch";
    #     rev = "f8c70da1cea810d584d533ff2e56fcd14b0438a2";
    #     sha256 = "sha256-bK8PxuH+FBM/WNlVeRY44tKOiMcfTQfT2g6zayLdJCE=";
    #   };
    #
    #   patches = [ ./config/nix-surf-flexipatch.diff ];
    # }))
  ];
}
