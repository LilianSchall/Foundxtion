{config, lib, pkgs, ...}:
let
    cfg = config.fndx.authentication.ldap;
in
with lib;
{
    options = {
        fndx.authentication.ldap = {
            enable = mkEnableOption "Janus LDAP configuration";

            server = mkOption {
                example = "ldaps://ldap.example.org"; 
                type = types.str;
                description = mdDoc "Janus LDAP server url";
            };
            dn = mkOption {
                example = "dc=example,dc=org"; 
                type = types.str;
                description = mdDoc "Janus LDAP base search dn";
            };
        }; 
    };

    config = mkIf cfg.enable {
	environment.systemPackages = with pkgs; [
	    openldap
	];

        users.ldap = {
            enable = true;
            base = cfg.dn;
            server = cfg.server;
            nsswitch = false;
        };
    };
}
