{
  description = "Minimal finix flake";

  inputs = {
    # Nixpkgs input #
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # change this ASAP
    nixpkgs.url = "github:nixos/nixpkgs/ee8b23cf07c1d80f28656c20222d2c29aa44f06d";

    # Finix inputs #
    # finix.url = "github:finix-community/finix";
    finix.url = "git+file:///home/vitrial/.local/src/nix/finix";
    # finix.url = "github:finix-community/finix/intrd";
    finix-local.url = "git+file:///home/vitrial/.local/src/nix/finix";
    # community.url = "github:finix-community/community-modules/turnstiled";
    community.url = "git+file:///home/vitrial/.local/src/nix/cmUpstream";
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
        # overlays = [
        #   (final: prev: { pipewire = (pkgs.callPackage ./packages/pipewire/package.nix { }); })
        # ];
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

          acpid

          pipewire
          wireplumber

          # nvf env variables stub
          # ./modules/environment

          nvf.nixosModules.default

          hjem.finixModules.default

          {
            hjem.extraModules = [
              community-local.hjemModules.dinit
              ./modules/hjem/pointer
              ./modules/hjem/bin
            ];
          }

          # Experimental #
          cModules.turnstile
          # ./modules/gamemode
          ./modules/console.nix

          ./modules/network.nix

          ./modules/nfs.nix

          ./modules/mullvad.nix
        ];

        specialArgs = {
          inherit inputs;
          modulesPath = toString nixpkgs + "/nixos/modules";
        };
      };
    };
}
