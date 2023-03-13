{
  description = "A very basic flake, indeed";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-nvim.url = "github:nixos/nixpkgs/f994293d1eb8812f032e8919e10a594567cf6ef7";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    jlink-pack = {
      url = "github:prtzl/jlink-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      lib = inputs.nixpkgs-stable.lib;
      home-manager = inputs.home-manager;

      mkFree = drv: drv.overrideAttrs (attrs: { meta = attrs.meta // { license = ""; }; });

      stableOverlay = self: super: {
        # Nix stores
        unstable = pkgs-unstable;
        pkgs-nvim = pkgs-nvim;
        # Stable package overrides/additions
        jlink = mkFree inputs.jlink-pack.defaultPackage.${system};
      };

      pkgs = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
        overlays = [ stableOverlay ];
      };

      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      pkgs-nvim = import inputs.nixpkgs-nvim {
        inherit system;
        config.allowUnfree = true;
      };
    in
    rec {
      homeConfigurations = {
        fedtop = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./fedtop-home.nix ];
          extraSpecialArgs = {
            lib = import "${home-manager}/modules/lib/stdlib-extended.nix" pkgs.unstable.lib;
          };
        };
      };
      fedtop = homeConfigurations.fedtop.activationPackage;
      defaultPackage.${system} = fedtop;
    };
}
