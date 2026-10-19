{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Define shorthand for admittedly long namespaces
  finitPackages = config.environment.corePackages.finit;
  initrdPackages = config.environment.corePackages.initrd;
  busybox = pkgs.busybox.override {
    enableStatic = true;
    useMusl = true;
  };
in
{
  # finit.path = lib.mkForce [
  #   # Just point things where they need to be
  #   config.programs.coreutils.package
  #   finitPackages.find
  #   finitPackages.grep
  #   finitPackages.sed
  #   config.finit.package
  #
  #   # required by finit on shutdown
  #   pkgs.util-linux.mount
  #
  #   # for finit log rotation
  #   finitPackages.gzip
  # ];
  #
  # boot.initrd.path = lib.mkForce [
  #   # Busybox modifcations in initrd are easier now for the user
  #   initrdPackages.busybox
  #   pkgs.util-linux
  #   (lib.hiPrio pkgs.kmod)
  #   (lib.hiPrio pkgs.util-linux.mount)
  # ];

  # Written explicitly but inherits can very easily be used;
  environment.corePackages = {
    global = {
      # Define a global set of packages.
      # This should likely be default and an expected value
      busybox = busybox;
      sed = busybox;
      grep = busybox;
      gzip = busybox;
      find = busybox;
    };
    # assign values to the global variant
    # finit = {
    #   sed = config.environment.corePackages.global.sed;
    #   grep = config.environment.corePackages.global.grep;
    #   gzip = config.environment.corePackages.global.gzip;
    #   find = config.environment.corePackages.global.find;
    # };
    # initrd = {
    #   # initrd may not want your booted systems busybox because of option changes
    #   busybox = pkgs.busybox;
    # };
  };
}
