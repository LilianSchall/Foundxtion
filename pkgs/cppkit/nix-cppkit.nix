{config, lib, pkgs, ...}:
let
  cfg = config.fndx.packages.cppkit;
in
with lib;
{
    options = {
        fndx.packages.cppkit.enable = mkEnableOption "Cpp development kit for Foundxtion";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            clang
            clang-tools
            gcc
            gnumake
            jetbrains.clion
        ];
    };
}