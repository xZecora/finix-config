{
  inputs,
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

    ../configs/bin

    ../configs/jellyfin.nix

    ../configs/coreutils.nix
    # ../configs/corepackages.nix

    # Experimental #
    ../configs/gaming
    ../configs/hjem
    ../configs/music
    ../configs/nh.nix
    ../configs/acpid.nix
    # ../configs/sessiond
    ../modules/logitech.nix
  ];

  # Use latest kernel.

  boot = {
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages;

    kernelParams = [
      # "loglevel=2"
      "amdgpu.ppfeaturemask=0xffffffff"
      "preempt=full"
    ];
  };

  hardware.cpu.amd.updateMicrocode = true;

  users.users.root.shell = lib.mkForce pkgs.dash;

  finit = {
    # enable = true;

    runlevel = 3;

    cgroups.system."cpu.weight" = 100;

    services.nix-daemon = {
      environment.CURL_CA_BUNDLE = config.security.pki.caBundle;
    };

    # package = pkgs.finit.overrideAttrs (o: {
    #   version = "5.0";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "finit-project";
    #     repo = "finit";
    #     rev = "ad8ed05d64a4e274e39ac2d061fe8c3aa8a87c22";
    #     sha256 = "sha256-SJTnrcgRx/M07pOQAnm+LeiXSq9YGCON2yHLaKCMyJw=";
    #   };
    #
    #   buildInputs = o.buildInputs ++ [ pkgs.util-linuxMinimal.dev ];
    #
    #   postPatch = (o.postPatch or "") + ''
    #     substituteInPlace keventd/uevent.c \
    #       --replace-fail '"/sbin/modprobe", "modprobe"' '"${pkgs.kmod}/bin/modprobe", "modprobe"' \
    #       --replace-fail '"/usr/lib/firmware/' '"/run/current-system/firmware/lib/firmware/'
    #
    #     substituteInPlace keventd/builtin.c \
    #       --replace-fail '"/lib/udev/hwdb.d"' '"/run/current-system/sw/lib/udev/hwdb.d"' \
    #       --replace-fail '"/usr/share/hwdata/usb.ids"' '"${pkgs.hwdata}/share/hwdata/usb.ids"'
    #   '';
    # });
  };

  # environment.binsh = "${pkgs.dash}/bin/dash";

  programs = {
    limine = {
      enable = true;
      settings.editor_enabled = true; # Disable on systems that need security
      extraEntries = ''
        /NixOS
          protocol: efi
          path: uuid(485bf836-0941-4267-b4ce-fbcbe2a19015):/EFI/limine/BOOTX64.EFI

        /Simple initrd
        protocol: linux
        comment: finix ramdisk testing
        kernel_path: boot():/limine/kernels/nmyhzfvkn5zagl7lc16w9m6d54v4696d-linux-6.18.41-bzImage#17e8208748585dbf5d170b75702e38dab2e703919e5dcb72a81e3e8d9aea95ebc7056ce2c22273766dfceac9e958daff7c2fe60cb9b38d1c8561974aca719762
        cmdline: vt.default_red=0x1E,0xE0,0x98,0xD1,0x5B,0xC6,0x56,0xAB,0x5C,0xE0,0x98,0xD1,0x5B,0xC6,0x56,0xFF vt.default_grn=0x21,0x6C,0xC3,0x9A,0x9B,0x78,0xB6,0xB2,0x63,0x6C,0xC3,0x9A,0x9B,0x78,0xB6,0xFF vt.default_blu=0x27,0x75,0x79,0x66,0xB3,0xDD,0xC2,0xBF,0x70,0x75,0x79,0x66,0xB3,0xDD,0xC2,0xFF
        module_path: boot():/limine/kernels/ramdisk.img
      '';
      # maxGenerations = 5;
    };

    doas = {
      enable = true;
      persist = true;
      keepEnv = true;
      requirePassword = false;
    };
  };

  boot.initrd.emergencyAccess = true;

  # boot.initrd.finit.run.mdevd-wait = {
  #   runlevels = "S";
  #   command = "sleep 1";
  #   conditions = "run/coldplug/success";
  # };

  services = {
    mullvad-vpn.enable = true;

    openssh.enable = true;

    nfs-daemons.enable = true;

    autofs = {
      enable = true;
      mountCollections = {
        # mnt = {
        #   rootMountPoint = "/mnt";
        #   extraArgs = [ "--timeout=60" ];
        #   mounts.games = {
        #     rules = [ ];
        #     source = ":/dev/sdd1";
        #     fsType = "ext4";
        #     user = "vitrial";
        #   };
        # };
        server = {
          rootMountPoint = "/server";
          extraArgs = [ "--timeout=60" ];
          mounts = {
            music = {
              source = "192.168.0.231:/export/music";
              rules = [
                "rw"
                "soft"
                "rsize=8192"
                "wsize=8192"
              ];
            };
            anime = {
              source = "192.168.0.231:/export/anime";
              rules = [
                "rw"
                "soft"
                "rsize=8192"
                "wsize=8192"
              ];
            };
            alt_anime = {
              source = "192.168.0.231:/export/alt_anime";
              rules = [
                "rw"
                "soft"
                "rsize=8192"
                "wsize=8192"
              ];
            };
            audiobooks = {
              source = "192.168.0.231:/export/audiobooks";
              rules = [
                "rw"
                "soft"
                "rsize=8192"
                "wsize=8192"
              ];
            };
            manga = {
              source = "192.168.0.231:/export/manga";
              rules = [
                "rw"
                "soft"
                "rsize=8192"
                "wsize=8192"
              ];
            };
            movies = {
              source = "192.168.0.231:/export/movies";
              rules = [
                "rw"
                "soft"
                "rsize=8192"
                "wsize=8192"
              ];
            };
            shows = {
              source = "192.168.0.231:/export/shows";
              rules = [
                "rw"
                "soft"
                "rsize=8192"
                "wsize=8192"
              ];
            };
            lightnovels = {
              source = "192.168.0.231:/export/lightnovels";
              rules = [
                "rw"
                "soft"
                "rsize=8192"
                "wsize=8192"
              ];
            };
            books = {
              source = "192.168.0.231:/export/books";
              rules = [
                "rw"
                "soft"
                "rsize=8192"
                "wsize=8192"
              ];
            };
            downloads = {
              source = "192.168.0.231:/export/downloads";
              rules = [
                "rw"
                "soft"
                "rsize=8192"
                "wsize=8192"
              ];
            };
          };
        };
      };
    };

    sysklogd.enable = true;

    dbus.enable = true;

    gardendevd.enable = true;

    chrony.enable = true;

    # bootchart = {
    #   enable = true;
    #   stop.conditions = [ "service/turnstiled/ready" ];
    # };

    nix-daemon = {
      enable = true;

      package = pkgs.lixPackageSets.stable.lix;

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

      settings = {
        manage_rundir = true;
        backend = "dinit";
      };

      dinit.enable = true;
      runit.enable = false;
    };

    getty = {
      enable = true;
      package = pkgs.busybox // {
        meta.mainProgram = "getty";
      };

      extraArgs = [
        "115200,38400,9600"
        "-l"
        "${lib.getExe' pkgs.util-linux "login"}"
      ];
    };
  };

  # providers.privileges.rules = [
  #   {
  #     command = "yes";
  #     users = [ "vitrial" ];
  #     requirePassword = false;
  #     args = [ "--help" ];
  #     # keepEnv = true;
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
      "gamemode"
      "pipewire"
    ];
    shell = pkgs.fish;
    # packages = with pkgs; [ ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nushell
    vim
    wget
    git
    (nixos-rebuild-ng.override { nix = pkgs.lixPackageSets.stable.lix; })
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
    htop
    xdg-utils
    maim
    tabbed
    mullvad
    man
    dwm
    curl
    kitty
    # (
    #   (concord-tui.overrideAttrs (final: {
    #     version = "v2.6.0";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "chojs23";
    #       repo = "concord";
    #       tag = "v2.6.0";
    #       hash = "sha256-5Zsznpg7kMPEl8Dpk9+al9J03eCKtfHbS9sYZOvJpjI=";
    #     };
    #     cargoHash = "sha256-1PrTXrOM+V1lbpRDoV+z4P2DuvVbnUsetMOAWyNicpY=";
    #     cargoLock = {
    #       lockFile = "${final.src}/Cargo.lock";
    #     };
    #   })).override
    #     { pipewire = config.programs.pipewire.package; }
    # )
    (inputs.concord.packages.x86_64-linux.concord.override {
      pipewire = config.programs.pipewire.package;
    })
    # inputs.oxicord.packages.x86_64-linux.default
    (callPackage ../packages/endcord.nix { })
    mpv
    easyeffects
  ];

  environment.pathsToLink = [ "/share/man" ];

  security.pam.services = lib.mkMerge [
    {
      login.text = lib.mkAfter "session required pam_limits.so conf=/etc/security/limits.conf";
    }
  ];

  security.pam.environment = {
    BROWSER.default = "floorp";
  };

  # hjem.users.vitrial.xdg.mime-apps.default-applications = {
  #   "text/html" = "userapp-Floorp-Q6EKR3.desktop";
  #   "www-browser" = "userapp-Floorp-Q6EKR3.desktop";
  #   "x-scheme-handler/http" = "userapp-Floorp-Q6EKR3.desktop";
  #   "x-scheme-handler/https" = "userapp-Floorp-Q6EKR3.desktop";
  #   "x-scheme-handler/about" = "userapp-Floorp-Q6EKR3.desktop";
  #   "x-scheme-handler/unknown" = "userapp-Floorp-Q6EKR3.desktop";
  # };
}
