{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.direnv
    pkgs.duf
    pkgs.fortune
    pkgs.gum
    pkgs.lolcat
  ];
}
