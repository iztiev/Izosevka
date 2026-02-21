{
  description = "Izosevka – custom Iosevka font based on SS14 variant (JetBrains Mono Style) with adjusted individual symbols";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          # Build the base Izosevka font using the local build plan.
          # Note: Iosevka builds are slow (can take 10–30 min on first build).
          izosevka = pkgs.iosevka.override {
            set = "Izosevka";
            privateBuildPlan = builtins.readFile ./private-build-plans.toml;
          };

        in
        {
          inherit izosevka;
          default = izosevka;
        });

      # NixOS module – import this in your configuration to install the font.
      nixosModules.default = { pkgs, ... }: {
        fonts.packages = [
          self.packages.${pkgs.stdenv.hostPlatform.system}.izosevka
        ];
      };
    };
}
