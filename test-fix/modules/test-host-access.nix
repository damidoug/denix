{
  delib,
  host,
  ...
}:
delib.module {
  name = "test-host-access";

  options = delib.singleEnableOption (host.isPC or false);

  nixos.ifEnabled = {
    services.openssh.enable = true;
    
    # Add minimal required config
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    boot.loader.grub.devices = [ "/dev/sda" ];
  };
}