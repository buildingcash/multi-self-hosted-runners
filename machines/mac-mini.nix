# Mac mini setup configuration
{ pkgs, ... }: {

  # specific packages for mac-mini:
  environment.systemPackages = [];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Enable flakes
  nix.settings.experimental-features = "nix-command flakes";

  nix.optimise.automatic = true;

  nix.gc = {
    automatic = true;
    interval = { Hour = 0; Minute = 0; }; # Run everyday at 00h
    options = "--delete-older-than 7d";
  };

  time.timeZone = "Europe/Paris";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  system.stateVersion = 4;
  system.activationScripts.postActivation.text = ''
    echo "Disabling autosleep..."
    pmset -a disablesleep 1
  '';

  system.activationScripts.postUserActivation.text = ''
    echo "Enabling docker..."
    ${pkgs.colima}/bin/colima start --cpu 8 --memory 6 --disk 80 --mount /private/var/run/github-runners
    sudo ln -sf $HOME/.colima/default/docker.sock /var/run/docker.sock
  '';

  nixpkgs.hostPlatform = "aarch64-darwin";
}
