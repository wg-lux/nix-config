{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    easyrsa
  ];
}