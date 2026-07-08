{
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../configs/nvf/nvf.nix
    ../configs/ratpoison.nix

    ../configs/theming.nix

    ../configs/audio.nix

    ../configs/network.nix

    # ../configs/stylix.nix

    # Experimental #
    ../configs/gaming
    ../configs/hjem
    ../configs/music
  ];

  # Use latest kernel.

  boot = {
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    kernelParams = [
      # "loglevel=2"
      "amdgpu.ppfeaturemask=0xffffffff"
      "preempt=full"
    ];
  };

  # environment.etc.foo.text = "bar";

  # hardware.cpu.amd.updateMicrocode = true;

  finit = {
    runlevel = 3;

    cgroups.system.settings = {
      "cpu.weight" = 100;
    };

    services.nix-daemon = {
      environment.CURL_CA_BUNDLE = config.security.pki.caBundle;
    };

    package = pkgs.finit.overrideAttrs (o: {
      version = "5.0";
      src = pkgs.fetchFromGitHub {
        owner = "finit-project";
        repo = "finit";
        rev = "ad8ed05d64a4e274e39ac2d061fe8c3aa8a87c22";
        sha256 = "sha256-SJTnrcgRx/M07pOQAnm+LeiXSq9YGCON2yHLaKCMyJw=";
      };

      buildInputs = o.buildInputs ++ [ pkgs.util-linuxMinimal.dev ];

      postPatch = (o.postPatch or "") + ''
        substituteInPlace keventd/uevent.c \
          --replace-fail '"/sbin/modprobe", "modprobe"' '"${pkgs.kmod}/bin/modprobe", "modprobe"' \
          --replace-fail '"/usr/lib/firmware/' '"/run/current-system/firmware/lib/firmware/'

        substituteInPlace keventd/builtin.c \
          --replace-fail '"/lib/udev/hwdb.d"' '"/run/current-system/sw/lib/udev/hwdb.d"' \
          --replace-fail '"/usr/share/hwdata/usb.ids"' '"${pkgs.hwdata}/share/hwdata/usb.ids"'
      '';
    });
  };

  environment.binsh = "${pkgs.dash}/bin/dash";

  programs.coreutils.package = pkgs.busybox.overrideAttrs (
    _: prev: {
      postInstall = prev.postInstall + "rm $out/sbin/init";
    }
  );

  programs = {
    limine = {
      enable = true;
      settings.editor_enabled = true; # Disable on systems that need security
      extraEntries = ''
        /NixOS
          protocol: efi
          path: uuid(485bf836-0941-4267-b4ce-fbcbe2a19015):/EFI/limine/BOOTX64.EFI
      '';
      # maxGenerations = 5;
    };

    doas = {
      enable = true;
      persist = true;
      keepEnv = true;
      requirePassword = false;
    };

    # fish.enable = true;
  };

  services = {
    openssh.enable = true;

    polkit.enable = true;

    sysklogd.enable = true;

    dbus.enable = true;

    keventd.enable = true;

    # dhcpcd.enable = true;

    nix-daemon = {
      enable = true;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "root"
          "@wheel"
        ];
      };
    };

    zfs = {
      autoSnapshot.enable = false;
      autoScrub.enable = true;
    };

    turnstile = {
      enable = true;
      settings.manage_rundir = "yes";
    };

  };

  # providers.privileges.rules = [
  #   {
  #     command = "*";
  #     users = [ "vitrial" ];
  #     requirePassword = false;
  #     keepEnv = true;
  #   }
  # ];

  networking = {
    hostName = "finix"; # Define your hostname.
    hostId = "ab2eecd3";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vitrial = {
    isNormalUser = true;
    description = "test user";
    extraGroups = [
      "wheel"
      "video"
      "input"
      "audio"
      # "gamemode"
      "pipewire"
    ];
    shell = pkgs.fish;
    # packages = with pkgs; [ ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    nixos-rebuild-ng
    iputils
    iproute2
    ripgrep
    dash
    rsync
    vesktop
    pavucontrol
    nfs-utils
    fish
    xidlehook
    jujutsu
    ratty
    strawberry
    mpd
    mpd-mpris
    playerctl
    mpc
  ];

  security.pam.services = lib.mkMerge [
    {
      login.text = lib.mkAfter "session required pam_limits.so conf=/etc/security/limits.conf";
    }
  ];

  # xdg.mime.defaultApplications = {
  #   "text/html" = "org.qutebrowser.qutebrowser.desktop";
  #   "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
  #   "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
  #   "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
  #   "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
  # };
}
