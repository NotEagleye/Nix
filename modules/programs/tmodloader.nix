{ self, ... }: {
  flake.nixosModules.tModLoader = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.tModLoader
    ];
  };

  perSystem = {
    pkgs,
    ...
  }: {
    packages.tModLoader = pkgs.makeDesktopItem {
        name = "tmodloader";
        desktopName = "tModLoader";
        comment = "Terraria Mod Loader";
        exec = "steam-run /home/lenovo/Games/Terraria/tModLoader/start-tModLoader.sh";
        icon = "terraria";
        categories = [ "Game" ];
        terminal = false;
      };
  };
}
