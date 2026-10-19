{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./morrowind.nix
    ./lutris.nix
  ];

  services.polkit.enable = true;

  programs.gamemode = {
    enable = true;
    settings = {
      general.renice = 10;
      gpu = {
        apply_gpu_optimizations = "accept-responsibility";
        amd_performance_level = "high";
      };
      custom = {
        start = "''${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "''${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  hjem.users.vitrial.dinit.services.gamemoded = {
    type = "process";
    command = "/run/wrappers/bin/gamemoded";
    depends-ms = [ "dbus-session-address" ];
    restart = true;
  };

  environment.systemPackages = with pkgs; [
    (inputs.millennium.packages."${pkgs.stdenv.hostPlatform.system}".millennium-steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          gamemode
        ];
    })
    wineWow64Packages.base
    winetricks
    libstrangle
    r2modman
    gamescope
    mangohud
  ];
}
