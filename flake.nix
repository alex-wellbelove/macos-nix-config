{
  description = "My work Mac Darwin flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.11";

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
    let

      configuration = { pkgs, ... }: {

        environment.systemPackages = [
          pkgs.vim
          pkgs.emacs
          # pkgs.vscode
          pkgs.just
          pkgs.google-cloud-sdk
          pkgs.tmux
          pkgs.solargraph
          pkgs.elan
          pkgs.ruby
          pkgs.spotify
          pkgs.cowsay
          pkgs.python3
          pkgs.bundler
          # pkgs.podman
          pkgs.logseq
          pkgs.mitmproxy
          pkgs.nixfmt-classic
          pkgs.minikube
          pkgs.kubectl
          pkgs.k9s
          pkgs.openai-whisper
          pkgs.wakatime
          pkgs.uv
          pkgs.pandoc
          pkgs.keychain
          pkgs.privoxy
          pkgs.pass
          pkgs.gnused
          pkgs.sqlcmd
          pkgs.maestral
          pkgs.jupyter
          pkgs.ripgrep
          pkgs.zulu8
          # pkgs.jujutsu
          pkgs.pyright
          pkgs.autossh
          (pkgs.rWrapper.override {
            packages = with pkgs.rPackages; [ dplyr ggplot2 multcompView emmeans multcomp car lme4 ARTool robustlmm reshape2 viridis ordinal];
          })

          pkgs.zoxide
        ];
        security.pam.enableSudoTouchIdAuth = true;

        homebrew = {
          enable = true;
          brews = [ "mysql" "zstd" "pkg-config" "gpg" ];
          casks = [ "ghostty" "cursor" "activitywatch"  ];
        };
        users.users.a0w0rh1 = { home = /Users/a0w0rh1; };
        # Necessary for using flakes on this system.
        nix.settings = { experimental-features = "nix-command flakes"; };
        # For nix-daemon
        nix.envVars = {
          http_proxy = "http://127.0.0.1:8118";
          https_proxy = "http://127.0.0.1:8118";
        };

        # Enable alternative shell support in nix-darwin.
        programs.fish.enable = true;
        environment.shells = [ pkgs.fish ];
        users.users.a0w0rh1.shell = pkgs.fish;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 5;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

      };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#m-m7n9k3dgmc
      darwinConfigurations."m-m7n9k3dgmc" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          ./modules/system.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.users.a0w0rh1 = import ./modules/home.nix;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };
}
