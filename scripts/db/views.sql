CREATE OR REPLACE VIEW {{.TenantID}}.yl_activities_with_new_comments
 AS
 SELECT DISTINCT comment_attr_yl.activity_id
   FROM comment_attr_yl
  WHERE comment_attr_yl.created > (( SELECT configuration.configuration_doc::character varying::timestamp without time zone AS configuration_doc
           FROM configuration
          WHERE configuration.configuration_id::text = 'DQALastRun'::text));

ALTER TABLE {{.TenantID}}.yl_activities_with_new_comments
    OWNER TO {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.yl_activities_with_new_comments TO {{.DBAdmin}};
GRANT SELECT ON TABLE {{.TenantID}}.yl_activities_with_new_comments TO {{.DBUser}};

CREATE OR REPLACE VIEW {{.TenantID}}.yl_classes
 AS
 SELECT classifier_class.class_id,
    classifier_class.category
   FROM classifier_class
  WHERE classifier_class.classifier_name::text ~~ 'NLC-YL-Activity%'::text AND classifier_class.state::text = 'current'::text;

ALTER TABLE {{.TenantID}}.yl_classes
    OWNER TO {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.yl_classes TO {{.DBAdmin}};
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.yl_classes TO {{.DBUser}};

CREATE OR REPLACE VIEW {{.TenantID}}.yl_classes
 AS
 SELECT classifier_class.class_id,
    classifier_class.category
   FROM classifier_class
  WHERE classifier_class.classifier_name::text ~~ 'NLC-YL-Activity%'::text AND classifier_class.state::text = 'current'::text;

ALTER TABLE {{.TenantID}}.yl_classes
    OWNER TO {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.yl_classes TO {{.DBAdmin}};
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.yl_classes TO {{.DBUser}};
