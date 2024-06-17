# Description

This repository allows for setting up multiple self-hosted Github actions runners on the same host (computer), natively without running things in docker.
This is useful if you want to improve your CI build times and pricing.

This is needed because 1 self-hosted runner only handles 1 job at the same time, therefore you need to setup several of them if you want to handle multiple jobs at a time.

As an example, here are the improvements we've seen after buying a Mac Mini M2 to run our CI/CD for testing, building and propagating our Android app:
Build time: ~26 minutes -> ~7 minutes

![image (1)](https://github.com/buildingcash/multi-self-hosted-runners/assets/867741/dcd993c4-00c3-43c5-8666-8708576ff657)  
![image](https://github.com/buildingcash/multi-self-hosted-runners/assets/867741/dbe16929-2553-48df-bbd4-74a5d10a21e5)


The cost of a Mac Mini will rapidly be reimbursed with this, especially if you're already using hosted MacOS runners, which are expensive.

# How to setup on Darwin machines (Mac)

- Install [Nix](https://nixos.org/download/#nix-install-macos)
- Get the **github runner token** and store it at the following path `/private/var/github-runner-token`
- Run `git clone https://github.com/buildingcash/multi-self-hosted-runners`
- Run `cd multi-self-hosted-runners`
- (optional) Edit the `flake.nix` file if needed to rename the machines
- Run `nix run nix-darwin -- switch --flake .mac-mini-1`

For each updates of nix files, you will need to re-run the `darwin-rebuild build --flake .mac-mini-1` command to apply changes.
