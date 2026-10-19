{
  description = "Minimal finix flake";

  inputs = {
    # Nixpkgs input #
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # change this ASAP
    # nixpkgs.url = "github:nixos/nixpkgs/ee8b23cf07c1d80f28656c20222d2c29aa44f06d";
    # nixpkgs.url = "git+file:///home/vitrial/.local/src/nix/nixpkgs";

    # Finix inputs #
    finix.url = "github:finix-community/finix";
    # finix.url = "github:parzivale/finix/generic-services";
    # finix.url = "github:FixeQD/finix/d83589c";
    # finix.url = "git+file:///home/vitrial/.local/src/nix/finix";
    # finix.url = "git+file:///home/vitrial/.local/src/nix/finix?ref=autofs";
    finix-local.url = "git+file:///home/vitrial/.local/src/nix/finix";
    finix-autofs.url = "git+file:///home/vitrial/.local/src/nix/finix?ref=autofs";
    community.url = "github:finix-community/community-modules";
    # community.url = "git+file:///home/vitrial/.local/src/nix/cmUpstream";
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

    rust-overlay.url = "github:oxalica/rust-overlay";

    sessiond = {
      url = "git+https://tangled.org/r0chd.pl/sessiond";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    sessiond-uaccess = {
      url = "git+https://tangled.org/r0chd.pl/sessiond-uaccess";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    sessiond-hooks = {
      url = "git+https://tangled.org/r0chd.pl/sessiond-hooks";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";

    concord.url = "github:chojs23/concord";
    # oxicord.url = "github:linuxmobile/oxicord";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      finix,
      finix-local,
      finix-autofs,
      nvf,
      hjem,
      hjem-rum,
      community,
      community-local,
      concord,
      # oxicord,
      ...
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [
          # (final: prev: { pipewire = (pkgs.callPackage ./packages/pipewire/package.nix { }); })
          inputs.millennium.overlays.default
          (final: prev: {
            inherit (prev.lixPackageSets.stable)
              nixpkgs-review
              nix-eval-jobs
              nix-fast-build
              colmena
              ;
          })
        ];
      };
      flModules = finix-local.nixosModules;
      autofs = finix-autofs.nixosModules;
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
          polkit
          # fish

          acpid
          chronyd

          pipewire
          wireplumber

          gamemode

          autofs.autofs

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
          clModules.turnstile
          # cModules.bootchart

          # ./modules/gamemode
          # ./modules/console.nix

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
