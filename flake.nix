{
  description = "Minimal finix flake";

  inputs = {
    # Nixpkgs input #
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # change this ASAP
    nixpkgs.url = "github:nixos/nixpkgs/4b3d28a42057784ce6513bdd37694f91857b2e6e";

    # Finix inputs #
    # finix.url = "github:finix-community/finix";
    # finix.url = "git+file:///home/vitrial/.local/src/nix/finix";
    finix.url = "github:chocoblocko9/finix/gardendevd-init";
    finix-local.url = "git+file:///home/vitrial/.local/src/nix/finix";
    community.url = "github:finix-community/community-modules";
    community-local.url = "git+file:///home/vitrial/.local/src/nix/community-modules";

    # Module inputs #
    nvf.url = "github:NotAShelf/nvf";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem-rum = {
      url = "github:snugnug/hjem-rum";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      finix,
      finix-local,
      nvf,
      hjem,
      hjem-rum,
      community,
      community-local,
      stylix,
      ...
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      flModules = finix-local.nixosModules;
      clModules = community-local.nixosModules;
      cModules = community.nixosModules;
    in
    {
      nixosConfigurations.finix = finix.lib.finixSystem {
        inherit (pkgs) lib;

        modules = with finix.nixosModules; [
          {
            nixpkgs.pkgs = nixpkgs.lib.mkDefault pkgs;
          }
          (./finix/configuration.nix)
          nix-daemon
          openssh
          sysklogd
          limine
          polkit
          getty
          # dhcpcd
          doas
          xserver
          zfs
          # fish

          cModules.pipewire

          # nvf env variables stub
          ./modules/environment

          nvf.nixosModules.default

          hjem.finixModules.default

          {
            hjem.extraModules = [
              ./modules/hjem/dinit
              ./modules/hjem/pointer
            ];
          }

          # stylix.nixosModules.stylix

          # Experimental #
          # ./modules/fish
          clModules.turnstile
          # ./modules/gamemode
          ./modules/console.nix

          ./modules/network.nix

          ./modules/nfs.nix
        ];

        specialArgs = {
          inherit inputs;
          modulesPath = toString nixpkgs + "/nixos/modules";
        };
      };
    };
}
