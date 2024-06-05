# Description

JASP nix configuration to setup github runners

## How to setup on Darwin machines (Mac)

- Install [Nix](https://nixos.org/download/#nix-install-macos)
- Get the **github runner token** and store it at the following path `/private/var/github-runner-token`
- Run `git clone https://github.com/buildingcash/multi-self-hosted-runners`
- Run `cd multi-self-hosted-runners`
- Run `nix run nix-darwin -- switch --flake .#YOUR-DARWIN-CONFIUGRATION-NAME`

For each updates of nix files, you will need to re-run the `darwin-rebuild build --flake .#YOUR-DARWIN-CONFIUGRATION-NAME` command to apply changes.