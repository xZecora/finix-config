{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.boot.supportedFilesystems.nfs;
in
{
  options = {
    boot.supportedFilesystems.nfs = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      packages = lib.mkOption {
        type = with lib.types; listOf package;
        default = [ ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "nfs" ];

    boot.supportedFilesystems.nfs.packages = [
      pkgs.nfs-utils
      pkgs.rpcbind
    ];

    users.groups.rpc = { };

    users.users = {
      rpc = {
        createHome = false;
        isNormalUser = false;
        group = "rpc";
      };

      nobody = {
        createHome = false;
        isNormalUser = false;
      };
    };

    environment.etc."idmapd.conf".text = ''
      [Mapping]
      Nobody-User = nobody
      Nobody-Group = nogroup
    '';

    system.activation.scripts.makeNfsStateDir = lib.stringAfter [ "etc" ] ''
      mkdir -p /var/lib/nfs/sm
      mkdir -p /var/lib/nfs/sm.bak
      mkdir -p /var/lib/nfs/rpc_pipefs
    '';

    finit = {
      run = lib.mkMerge [
        (lib.attrsets.mapAttrs' (
          n: _:
          lib.attrsets.nameValuePair "nfs-mount-${lib.lists.last (lib.strings.split "/" "${n}")}" {
            description = "nfs mounting task for ${n}";
            command = pkgs.writeShellScript "nfs-mount-${lib.lists.last (lib.strings.split "/" "${n}")}" ''
              while [ "$(ip a show dev eth0 down)" != "" ]; do continue; done;
              mount -t nfs ${n}
            '';
            # post = "\"umount ${n}\"";
            # conditions = "task/nfs-timer/success";
            # conditions = "net/eth0/running";
            conditions = [
              "task/iproute2-static/success"
              "run/nfs-rpc-idmapd/success"
            ];
            log = false;
            runlevels = "12345789";
            path = [
              pkgs.nfs-utils
              pkgs.mount
              config.programs.coreutils.package
            ];
          }
        ) (lib.attrsets.filterAttrs (_: v: v.fsType == "nfs") config.fileSystems))

        {
          nfs-rpc-pipefs = {
            description = "rpc_pipefs daemon for nfs client";
            command = "mount -t rpc_pipefs rpc_pipefs /var/lib/nfs/rpc_pipefs";
            conditions = "service/nfs-rpc-statd/ready";
            log = true;
            path = [
              pkgs.nfs-utils
              pkgs.mount
            ];
            runlevels = "12345789";
          };
        }
        {
          nfs-rpc-nfsd = {
            description = "nfsd mounting daemon for nfs client";
            command = "mount -t nfsd nfsd /proc/fs/nfsd";
            conditions = "run/nfs-rpc-pipefs/success";
            log = true;
            path = [
              pkgs.nfs-utils
              pkgs.mount
            ];
            runlevels = "12345789";
          };
        }
        # {
        #   nfs-timer = {
        #     description = "nfsd mounting daemon for nfs client";
        #     command = "sleep 10";
        #     conditions = "task/nfs-rpc-idmapd/success";
        #     log = false;
        #   };
        # }
        {
          nfs-rpcbind = {
            # type = "forking";
            description = "rpcbind daemon for nfs client";
            command = "${pkgs.rpcbind}/bin/rpcbind";
            # conditions = "net/eth0/running";
            # conditions = "run/iproute2-static/success";
            log = true;
            path = [ pkgs.rpcbind ];
            runlevels = "12345789";
          };
        }
        {
          nfs-rpc-idmapd = {
            description = "rpc.idmapd daemon for nfs client";
            command = "${pkgs.nfs-utils}/bin/rpc.idmapd -C";
            conditions = "run/nfs-rpc-nfsd/success";
            log = true;
            path = [ pkgs.nfs-utils ];
            runlevels = "12345789";
          };
        }
      ];

      services = lib.mkMerge [
        # (lib.attrsets.mapAttrs' (
        #   n: _:
        #   lib.attrsets.nameValuePair "nfs-mount-${lib.lists.last (lib.strings.split "/" "${n}")}" {
        #     description = "nfs mounting task for ${n}";
        #     command = pkgs.writeShellScript "nfs-mount-${lib.lists.last (lib.strings.split "/" "${n}")}" ''
        #       while [ "$(ip a show dev eth0 down)" != "" ]; do continue; done;
        #       mount -t nfs ${n} && sleep infinity
        #     '';
        #     post = "\"umount ${n}\"";
        #     # conditions = "task/nfs-timer/success";
        #     # conditions = "net/eth0/running";
        #     conditions = "task/iproute2-static/success";
        #     log = false;
        #     runlevel = "12345789";
        #     path = [
        #       pkgs.nfs-utils
        #       pkgs.mount
        #       config.programs.coreutils.package
        #     ];
        #   }
        # ) (lib.attrsets.filterAttrs (_: v: v.fsType == "nfs") config.fileSystems))

        {
          nfs-rpc-statd = {
            type = "forking";
            pid = "/run/rpc.statd.pid";
            description = "rpc.statd daemon for nfs client";
            command = "${pkgs.nfs-utils}/bin/rpc.statd --no-notify";
            conditions = "run/nfs-rpcbind/success";
            log = true;
            path = [ pkgs.nfs-utils ];
            runlevels = "12345789";
          };
        }
      ];
    };
  };
}
