{ config, pkgs, ... }:
let
  busybox = pkgs.busybox.overrideAttrs (
    _: prev: {
      postInstall = prev.postInstall + "rm $out/sbin/init";
    }
  );
in
{
  programs = {
    coreutils.package = busybox.override {
      enableStatic = true;
      useMusl = true;
    };

    # sed.package = config.programs.coreutils.package;
    # grep.package = config.programs.coreutils.package;
    # tar.package = config.programs.coreutils.package;
    # findUtils.package = config.programs.coreutils.package;
    # modprobe.package = config.programs.coreutils.package.override {
    #   extraConfig = ''
    #     CONFIG_DEFAULT_MODULES_DIR "/run/booted-system/kernel-modules/lib/modules"
    #   '';
    # };
  };

  # boot.initrd.finit.run.switch-root = {
  #  command = "/bin/sh";
  # };
}
