{config, lib, pkgs, ...}:
let
    cfg = config.fndx.janus;
    dnBuilder = with lib.strings; (server_name: concatMapStringsSep "," (x: "dc=" + x) (splitString "." (toLower server_name)));
    server = "ldap://ldap.${lib.strings.toLower cfg.realm}";
in
with lib;
{
    imports = [
        ./ldap.nix
        ./krb5.nix
    ];

    options = {
        fndx.janus = {
            enable = mkEnableOption "Foundxtion network authentication";
            realm = mkOption {
                example = "EXAMPLE.ORG";
                type = types.str;
                description = mdDoc "Janus realm";
            };
        };
    };

    config = mkIf cfg.enable {
        fndx.authentication.ldap = {
            enable = true;
            server = server;
            dn = dnBuilder cfg.realm;
        };
	fndx.authentication.krb5 = {
	    enable = true;
	    realm = cfg.realm;
	};

        services.sssd = {
            enable = true;
            config = ''
                [sssd]
                config_file_version = 2
                domains = ${lib.strings.toLower cfg.realm}

                [nss]
                override_shell = ${config.users.defaultUserShell}/bin/zsh

                [domain/${lib.strings.toLower cfg.realm}]
                id_provider = ldap
                auth_provider = ldap

                ldap_uri = ${server}
                ldap_search_base = ${cfg.dn}
		auth_provider = krb5;
		krb5_server = ${lib.strings.toLower cfg.realm}
		krb5_kpasswd = ${lib.strings.toLower cfg.realm}
		krb5_realm = ${lib.strings.toUpper cfg.realm}

                entry_cache_timeout = 600
                ldap_network_timeout = 2
		cache_credentials = True
            '';
        };
    };
}
