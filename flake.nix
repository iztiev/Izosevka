{
  description = "Izosevka — a custom Iosevka font build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems f;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          izosevka = pkgs.iosevka.override {
            set = "Izosevka";
            privateBuildPlan = builtins.readFile ./private-build-plans.toml;
          };
        in
        {
          default = izosevka;
          izosevka = izosevka;
        });

      nixosModules.default = { pkgs, ... }: {
        fonts.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.default ];
      };
    };
}
