{config, pkgs, ...} :
{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.fndx = import ../homeManagerConfig;
    users.root = import ../homeManagerConfig;
  };
}
