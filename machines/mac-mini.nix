# Mac mini setup configuration
{ pkgs, ... }: {

  # specific packages for mac-mini:
  environment.systemPackages = [];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Enable flakes
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  system.stateVersion = 4;
  system.activationScripts.postActivation.text = ''
    echo "Disabling autosleep..."
    pmset -a disablesleep 1
  '';

  nixpkgs.hostPlatform = "aarch64-darwin";
}