{self, ...}: {
  flake.nixosModules.youtui = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.youtui
    ];
  };

  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    packages.youtui = pkgs.rustPlatform.buildRustPackage {
      pname = "youtui";
      version = "0.0.37";

      src = pkgs.fetchFromGitHub {
        owner = "nick42d";
        repo = "youtui";
        rev = "youtui/v0.0.37";
        hash = "sha256-amn8Eh9LitW8oDTqMkqcuO5bLCjdwjUS5at+B3oYe+Q=";
      };

      cargoHash = "sha256-u7uhsiq0PK9P6uvbe1M3VfvT+zK0CCsQN4fvKEITRJQ=";

      doCheck = false;

      buildInputs = [pkgs.alsa-lib];
      nativeBuildInputs = [pkgs.pkg-config];
    };
  };
}
