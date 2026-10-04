{ self, ... }: {
  flake.nixosModules.SKLauncher = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.SKLauncher
    ];
  };

  perSystem = {
    pkgs,
    ...
  }: {
    packages.SKLauncher = let
      pname = "sklauncher";
      version = "3.2.18";

      jar = pkgs.fetchurl {
        url = "https://github.com/NotEagleye/sklauncher-java/releases/download/v${version}/SKlauncher-${version}.jar";
        sha256 = "sha256-Jac+N3Ch2NFLzlPokg4uiTqsw8cV0Psi+HjvIJDQOGM=";
      };
    in
      pkgs.buildFHSEnv {
        name = pname;

        targetPkgs = pkgs: with pkgs; [
          jdk21

          libGL
          libglvnd
          mesa

          libx11
          libxext
          libxcursor
          libxrandr
          libxxf86vm
          libxinerama
          libxi
          libxtst
          libxrender
          wayland

          glib
          gtk3
          gdk-pixbuf
          pango
          cairo
          atk
          alsa-lib
          libpulseaudio
          udev
          zlib
          freetype
          fontconfig
          libogg
          libvorbis
          flac
        ];

        runScript = "${pkgs.jdk21}/bin/java -jar ${jar}";
      };
  };
}
