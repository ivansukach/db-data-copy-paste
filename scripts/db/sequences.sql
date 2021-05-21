CREATE SEQUENCE {{.TenantID}}.entity_entity_id_seq
    INCREMENT 1
    START 1300
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE {{.TenantID}}.entity_entity_id_seq
    OWNER TO {{.DBAdmin}};

GRANT ALL ON SEQUENCE {{.TenantID}}.entity_entity_id_seq TO {{.DBAdmin}};

GRANT ALL ON SEQUENCE {{.TenantID}}.entity_entity_id_seq TO {{.DBUser}};

CREATE SEQUENCE {{.TenantID}}.watchlist_watchlist_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE {{.TenantID}}.watchlist_watchlist_id_seq
    OWNER TO {{.DBAdmin}};

GRANT ALL ON SEQUENCE {{.TenantID}}.watchlist_watchlist_id_seq TO {{.DBAdmin}};

GRANT ALL ON SEQUENCE {{.TenantID}}.watchlist_watchlist_id_seq TO {{.DBUser}};
