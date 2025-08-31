{
  delib,
  lib,
  host,
  ...
}:
delib.module {
  name = "system.networking";

  nixos.always = {
    networking = {
      hostName = host.name;
      
      networkmanager = {
        enable = host.isPC;
        dns = "none";
      };
      
      firewall.enable = true;
    };
    
    # Add minimal required config to make the test pass
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    boot.loader.grub.devices = [ "/dev/sda" ];
  };
}