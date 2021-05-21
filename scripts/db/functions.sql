CREATE OR REPLACE FUNCTION {{.TenantID}}.get_addressed_by(
	watson_suggestion character varying,
	admin_choice character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$BEGIN
    IF admin_choice IS NULL THEN
        RETURN 'none';
    END IF;
    IF admin_choice = watson_suggestion THEN
        RETURN 'watson';
    END IF;
    RETURN 'admin';
END
$BODY$;

ALTER FUNCTION {{.TenantID}}.get_addressed_by(character varying, character varying)
    OWNER TO {{.DBAdmin}};

CREATE OR REPLACE FUNCTION {{.TenantID}}.get_nps_category_by_score(
	score integer)
    RETURNS character varying
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$BEGIN
    IF score <= 6 THEN
        RETURN 'Detractor';
    END IF;
    IF score <= 8 THEN
        RETURN 'Passive';
    END IF;
    IF score <= 10 THEN
        RETURN 'Promoter';
    END IF;
END$BODY$;

ALTER FUNCTION {{.TenantID}}.get_nps_category_by_score(integer)
    OWNER TO {{.DBAdmin}};

CREATE OR REPLACE FUNCTION {{.TenantID}}.to_char_iso(
	_date timestamp with time zone)
    RETURNS text
    LANGUAGE 'sql'

    COST 100
    VOLATILE
AS $BODY$
     SELECT to_char(_date, 'YYYY-MM-DD"T"HH24:MI:SS"Z"');
$BODY$;

ALTER FUNCTION {{.TenantID}}.to_char_iso(timestamp with time zone)
    OWNER TO {{.DBAdmin}};
