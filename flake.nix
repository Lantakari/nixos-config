# flake.nix
flake-overlays: {
  description = "System configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nix-ld.url = "github:Mic92/nix-ld";
    # this line assume that you also have nixpkgs as an input
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    # ...
  };

  outputs = { nix-ld, nixpkgs, self, ... }:
    let lib = nixpkgs.lib;

    in {
      nixosConfigurations = {
        seumas = nixpkgs.lib.nixosSystem {
          nixos = lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              import
              ./configuration.nix
              ./hardware-configuration.nix

              # ... add this line to the rest of your configuration modules
              nix-ld.nixosModules.nix-ld

              # The module in this repository defines a new module under (programs.nix-ld.dev) instead of (programs.nix-ld)
              # to not collide with the nixpkgs version.
              {
                programs.nix-ld.dev.enable = true;
                # nixpkgs.overlays = [
                # (final: prev:
                # {
                # Your own overlays...
                # })
                # ];

              }
            ];
          };
        };
      };
    };
}
