{
  services.iproute2-static = {
    enable = true;
    interface = "eth0";
    localInfo = "192.168.0.113/24 brd +";
    routerIP = "192.168.0.1";
  };

  # finit.tasks = {
  #   static-network = {
  #     description = "static network configuration service";
  #     command = pkgs.writeShellScript "static-network" ''
  #       ip link set eth0 up
  #       ip address add 192.168.0.113/24 brd + dev eth0
  #       ip route add 192.168.0.1 dev eth0
  #       ip route add default via 192.168.0.1 dev eth0
  #     '';
  #     conditions = "net/eth0/exist";
  #     log = true;
  #     path = [
  #       pkgs.iproute2
  #     ];
  #   };
  # };
}
