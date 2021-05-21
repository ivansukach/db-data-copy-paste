CREATE DOMAIN {{.TenantID}}."nps score"
    AS smallint
    NOT NULL;

ALTER DOMAIN {{.TenantID}}."nps score" OWNER TO {{.DBAdmin}};

ALTER DOMAIN {{.TenantID}}."nps score"
    ADD CONSTRAINT "nps score_check" CHECK (VALUE >= 0 AND VALUE <= 10);
