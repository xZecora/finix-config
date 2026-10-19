{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.nfs-daemons;
in
{
  options = {
    services.nfs-daemons = {
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
        # {
        #   nfs-mount = {
        #     description = "Mount all NFS filesystems";
        #     command = "mount -a -t nfs";
        #     conditions = [
        #       "net/route/default"
        #       "service/nfs-rpc-idmapd/ready"
        #     ];
        #     log = false;
        #     runlevels = "12345789";
        #     path = [
        #       pkgs.nfs-utils
        #       pkgs.mount
        #     ];
        #   };
        # }
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
        # (lib.attrsets.mapAttrs' (
        #   n: _:
        #   lib.attrsets.nameValuePair "nfs-mount-${lib.lists.last (lib.strings.split "/" "${n}")}" {
        #     description = "nfs mounting task for ${n}";
        #     command = "mount -t nfs ${n}";
        #     # command = pkgs.writeShellScript "nfs-mount-${lib.lists.last (lib.strings.split "/" "${n}")}" ''
        #     # while [ "$(ip a show dev eth0 down)" != "" ]; do continue; done;
        #     # mount -t nfs ${n}
        #     # '';
        #     # post = "\"umount ${n}\"";
        #     # conditions = "task/nfs-timer/success";
        #     # conditions = "net/eth0/running";
        #     conditions = [
        #       "net/route/default"
        #       "task/iproute2-static/success"
        #       "run/nfs-rpc-idmapd/success"
        #     ];
        #     log = false;
        #     runlevels = "12345789";
        #     path = [
        #       pkgs.nfs-utils
        #       pkgs.mount
        #       config.programs.coreutils.package
        #     ];
        #   }
        # ) (lib.attrsets.filterAttrs (_: v: v.fsType == "nfs") config.fileSystems))
      ];

      services = lib.mkMerge [
        {
          nfs-rpc-idmapd = {
            description = "rpc.idmapd daemon for nfs client";
            command = "${pkgs.nfs-utils}/bin/rpc.idmapd -Cf";
            conditions = "run/nfs-rpc-nfsd/success";
            log = true;
            path = [ pkgs.nfs-utils ];
            runlevels = "12345789";
          };
        }
        {
          nfs-rpcbind = {
            # type = "forking";
            description = "rpcbind daemon for nfs client";
            command = "${pkgs.rpcbind}/bin/rpcbind -f";
            log = true;
            path = [ pkgs.rpcbind ];
            runlevels = "12345789";
          };
        }
        {
          nfs-rpc-statd = {
            type = "forking";
            pid = "/run/rpc.statd.pid";
            description = "rpc.statd daemon for nfs client";
            command = "${pkgs.nfs-utils}/bin/rpc.statd --no-notify";
            conditions = "service/nfs-rpcbind/ready";
            log = true;
            path = [ pkgs.nfs-utils ];
            runlevels = "12345789";
          };
        }
      ];
    };
  };
}
