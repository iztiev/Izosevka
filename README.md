# Izosevka fonts

This is my customization variant for [Iosevka](https://github.com/be5invis/Iosevka) fonts that I use in my terminal and editors.

It is based on SS14 JetBrains Mono style, with some symbols replaced for minimalistic look. Only TTF fonts are built.

## NixOS

Add the flake as an input in your `flake.nix`:

```nix
inputs.izosevka.url = "github:iztiev/Izosevka";
```

Then import the NixOS module in your configuration:

```nix
nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
  modules = [
    ./configuration.nix
    inputs.izosevka.nixosModules.default
  ];
};
```

The module adds the font to `fonts.packages` automatically. No further configuration is needed — `fc-list | grep Izosevka` should show the font after rebuilding.

> **Note:** The first build compiles Iosevka from source and can take 10–30 minutes depending on your machine.
