{ inputs, pkgs, ... }:
{
  hjem = {
    extraModules = [
      inputs.hjem-rum.hjemModules.default
    ];

    users.vitrial = {
      enable = true;
      directory = "/home/vitrial";
      user = "vitrial";
      packages = with pkgs; [
        bat
        fastfetch
        eza
        file
        hexyl
        chafa
        fd
        procs
        broot
        fzf
        man
        floorp-bin
      ];
    };

    clobberByDefault = true;
  };

  imports = [
    ./fish.nix
    ./dinit.nix
  ];
}
