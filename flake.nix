{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.11";

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];
      homebrew = {
       enable = true;
       casks = ["ghostty"];
      };
      users.users.a0w0rh1 = {home=/Users/a0w0rh1;};
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;
      environment.shells = [pkgs.fish];
      users.users.a0w0rh1.shell = pkgs.fish;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#m-m7n9k3dgmc
    darwinConfigurations."m-m7n9k3dgmc" = nix-darwin.lib.darwinSystem {
      modules = [ configuration 
		./modules/system.nix 
		home-manager.darwinModules.home-manager {
			home-manager.users.a0w0rh1 = import ./modules/home.nix;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;}
];
    };
  };
}
