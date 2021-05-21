CREATE SCHEMA {{.TenantID}}
    AUTHORIZATION {{.DBAdmin}};

GRANT ALL ON SCHEMA {{.TenantID}} TO {{.DBAdmin}};

GRANT USAGE ON SCHEMA {{.TenantID}} TO {{.DBUser}};

ALTER ROLE {{.DBUser}} SET search_path TO {{.TenantID}};

