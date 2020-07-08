{ pkgs ? import <nixpkgs> {} }:

let
  disableSteamPatch = pkgs.writeText "disable-steam" ''
    diff --git a/main.lua b/main.lua
    index 9a4e005..b3b82ca 100644
    --- a/main.lua
    +++ b/main.lua
    @@ -1,5 +1,5 @@
    -Steam = require 'libraries/steamworks'
    -if type(Steam) == 'boolean' then Steam = nil end
    +-- Steam = require 'libraries/steamworks'
    +-- if type(Steam) == 'boolean' then Steam = nil end
     
     Object = require 'libraries/classic/classic'
     Timer = require 'libraries/enhanced_timer/EnhancedTimer'
  '';
in pkgs.stdenv.mkDerivation {
  name = "BYTEPATH";

  src = ./.;

  buildInputs = [ pkgs.makeWrapper ];

  patches = [ "${disableSteamPatch}" ];

  installPhase = ''
    mkdir -p $out/{gamelib,bin}
    cp -a * $out/gamelib
    makeWrapper ${pkgs.love_0_10}/bin/love $out/bin/BYTEPATH --add-flags $out/gamelib
  '';
}
