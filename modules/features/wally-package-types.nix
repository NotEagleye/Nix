{self, ...}: {
  flake.nixosModules.wally-package-types = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.wally-package-types
    ];
  };

  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    packages.wally-package-types = pkgs.rustPlatform.buildRustPackage rec {
      pname = "wally-package-types";
      version = "1.6.2";

      src = pkgs.fetchFromGitHub {
        owner = "JohnnyMorganz";
        repo = "wally-package-types";
        rev = "/v${version}";
        hash = "sha256-ynd5z2pbhGnPTKuJQG4EJL/Zy/X9lTCjSi8Cd6nRSsA=";
      };

      cargoHash = "sha256-LjtnArnv46GzbHnpT3wFNrjCv78stfFc6Kx9RefK+U8=";

      doCheck = false;

      nativeBuildInputs = [pkgs.rustPlatform.cargoSetupHook pkgs.rustc pkgs.cargo];
    };
  };
}
