{ lib, stdenv, fetchurl }:

# Note: this package is used for bootstrapping fetchurl, and thus
# cannot use fetchpatch! All mutable patches (generated by GitHub or
# cgit) that are needed here should be included directly in Nixpkgs as
# files.

let
  rev = "63acb96f92473ceb5e21d873d7c0aee266b3d6d3";

  # Don't use fetchgit as this is needed during Aarch64 bootstrapping
  configGuess = fetchurl {
    name = "config.guess-${builtins.substring 0 7 rev}";
    url = "https://git.savannah.gnu.org/cgit/config.git/plain/config.guess?id=${rev}";
    sha256 = "049qgfh4xjd4fxd7ygm1phd5faqphfvhfcv8dsdldprsp86lf55v";
  };
  configSub = fetchurl {
    name = "config.sub-${builtins.substring 0 7 rev}";
    url = "https://git.savannah.gnu.org/cgit/config.git/plain/config.sub?id=${rev}";
    sha256 = "1rk30y27mzls49wyfdb5jhzjr08hkxl7xqhnxmhcmkvqlmpsjnxl";
  };
in stdenv.mkDerivation {
  pname = "gnu-config";
  version = "2023-01-21";

  buildCommand = ''
    mkdir -p $out
    cp ${configGuess} $out/config.guess
    cp ${configSub} $out/config.sub

    chmod +x $out/config.*
  '';

  meta = with lib; {
    description = "Attempt to guess a canonical system name";
    homepage = "https://savannah.gnu.org/projects/config";
    license = licenses.gpl3;
    # In addition to GPLv3:
    #   As a special exception to the GNU General Public License, if you
    #   distribute this file as part of a program that contains a
    #   configuration script generated by Autoconf, you may include it under
    #   the same distribution terms that you use for the rest of that
    #   program.
    maintainers = with maintainers; [ dezgeg emilytrau ];
    platforms = platforms.all;
  };
}
