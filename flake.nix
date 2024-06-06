{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    mkGithubRunners = { prefix, tokenFile, runnerGroup, user, group, extraLabels, n } : { pkgs, ... } :{
      services.github-runners = builtins.listToAttrs (
          builtins.map (i: {
          name = "${prefix}-runner-${toString i}";
          value = {
            inherit tokenFile runnerGroup user group extraLabels;

            enable = true;
            name = "${prefix}-runner-${toString i}";
            url = "https://github.com/buildingcash";
            extraPackages = with pkgs; [ coreutils ];
            extraEnvironment = {
              ACTIONS_RUNNER_HOOK_JOB_COMPLETED = "${./scripts/github-job-cleanup.sh}";
            };
          };
        }) (builtins.genList (i: i + 1) n)
      );

    };
  in
  {
    # $ darwin-rebuild switch --flake .#mac-mini-1
    darwinConfigurations."mac-mini-1" = nix-darwin.lib.darwinSystem {
      modules = [
        ./machines/mac-mini.nix

        (mkGithubRunners {
          prefix = "mac-mini-1";
          n = 8;
          tokenFile = "/private/var/github-runner-token";
          runnerGroup = "Boosted CI Self Hosted";
          user = "jasp";
          group = "staff";
          extraLabels = [ "m2" "self-hosted" "self-hosted-macos" ];
        })
      ];
    };

    # Add more configurations here
  };
}
