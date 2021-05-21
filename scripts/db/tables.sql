CREATE TABLE {{.TenantID}}.capability
(
    provider_id character varying(3) COLLATE pg_catalog."default" NOT NULL,
    capability_id character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT capability_pkey PRIMARY KEY (capability_id, provider_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.capability
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.capability TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.capability TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.classifier
(
    classifier_name character varying(63) COLLATE pg_catalog."default" NOT NULL,
    created timestamp(6) with time zone NOT NULL DEFAULT now(),
    updated timestamp(6) with time zone NOT NULL DEFAULT now(),
    classifier_id character varying(30) COLLATE pg_catalog."default" NOT NULL,
    instance_apikey text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT classifier_pkey PRIMARY KEY (classifier_name)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.classifier
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.classifier TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.classifier TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.classifier_class
(
    class_id character varying(63) COLLATE pg_catalog."default" NOT NULL,
    classifier_name character varying(63) COLLATE pg_catalog."default" NOT NULL,
    subclassifier_name character varying(63) COLLATE pg_catalog."default",
    name character varying(63) COLLATE pg_catalog."default" NOT NULL,
    category character varying(15) COLLATE pg_catalog."default" NOT NULL,
    state character varying(15) COLLATE pg_catalog."default" NOT NULL,
    "order" integer NOT NULL DEFAULT 0,
    CONSTRAINT classifier_class_pkey PRIMARY KEY (class_id, classifier_name),
    CONSTRAINT classifier_class_subclassifier_name_key UNIQUE (subclassifier_name),
    CONSTRAINT classifier_class_category_check CHECK (category::text = ANY (ARRAY['Negative'::character varying::text, 'Neutral'::character varying::text, 'Positive'::character varying::text, 'Other'::character varying::text])) NOT VALID,
    CONSTRAINT classifier_class_flagged_as_check CHECK (state::text = ANY (ARRAY['deprecated'::character varying::text, 'current'::character varying::text, 'future'::character varying::text])) NOT VALID
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.classifier_class
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.classifier_class TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.classifier_class TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.classifier_instance
(
    created timestamp(6) with time zone NOT NULL DEFAULT now(),
    instance_apikey character(44) COLLATE pg_catalog."default" NOT NULL,
    account text COLLATE pg_catalog."default" NOT NULL DEFAULT 0,
    resource_group text COLLATE pg_catalog."default" NOT NULL,
    expected_api_calls integer NOT NULL DEFAULT 0,
    previous_api_calls integer NOT NULL DEFAULT 0,
    name text COLLATE pg_catalog."default",
    service_url text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT classifier_instance_pk PRIMARY KEY (instance_apikey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.classifier_instance
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.classifier_instance TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.classifier_instance TO {{.DBUser}};

CREATE UNIQUE INDEX classifier_instance_instance_apikey_uindex
    ON {{.TenantID}}.classifier_instance USING btree
    (instance_apikey COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE TABLE {{.TenantID}}.classifier_training_request
(
    request_id uuid NOT NULL DEFAULT public.uuid_generate_v1(),
    created timestamp with time zone NOT NULL DEFAULT now(),
    updated timestamp with time zone NOT NULL DEFAULT now(),
    classifier_name character varying(63) COLLATE pg_catalog."default" NOT NULL,
    classifier_id character varying(30) COLLATE pg_catalog."default",
    status character varying(15) COLLATE pg_catalog."default" NOT NULL DEFAULT 'NEW'::character varying,
    CONSTRAINT classifier_training_request_pkey PRIMARY KEY (request_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.classifier_training_request
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.classifier_training_request TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.classifier_training_request TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.classifier_training_request_data
(
    request_id uuid NOT NULL,
    data text COLLATE pg_catalog."default" NOT NULL,
    nlc_instance_name text COLLATE pg_catalog."default" NOT NULL,
    example_count integer NOT NULL DEFAULT 0,
    CONSTRAINT training_request_data_pkey PRIMARY KEY (request_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.classifier_training_request_data
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.classifier_training_request_data TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.classifier_training_request_data TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.classifier_training_request_status
(
    status character varying(15) COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    CONSTRAINT classifier_training_request_status_pkey PRIMARY KEY (status)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.classifier_training_request_status
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.classifier_training_request_status TO {{.DBAdmin}};

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE {{.TenantID}}.classifier_training_request_status TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.comment
(
    comment_id uuid NOT NULL DEFAULT public.uuid_generate_v1(),
    created timestamp with time zone NOT NULL DEFAULT now(),
    text text COLLATE pg_catalog."default" NOT NULL,
    date_posted timestamp with time zone NOT NULL,
    provider_id character varying(3) COLLATE pg_catalog."default" NOT NULL,
    source_id character varying(15) COLLATE pg_catalog."default" NOT NULL,
    is_deleted boolean NOT NULL DEFAULT false,
    CONSTRAINT comment_pkey PRIMARY KEY (comment_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.comment
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.comment TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.comment TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.comment_attr_yl
(
    comment_id uuid NOT NULL,
    created timestamp with time zone NOT NULL DEFAULT now(),
    activity_id character varying(127) COLLATE pg_catalog."default" NOT NULL,
    activity_owner_id character varying(63) COLLATE pg_catalog."default" NOT NULL,
    activity_title text COLLATE pg_catalog."default" NOT NULL,
    author_id character varying(63) COLLATE pg_catalog."default" NOT NULL,
    rating smallint,
    replies jsonb NOT NULL,
    trusted_source_id character varying(15) COLLATE pg_catalog."default" NOT NULL,
    yl_comment_id character varying(255) COLLATE pg_catalog."default" NOT NULL,
    tag_ids character varying[] COLLATE pg_catalog."default" NOT NULL DEFAULT '{}'::character varying[],
    activity_group_space_id integer,
    CONSTRAINT comment_attr_yl_pkey PRIMARY KEY (comment_id),
    CONSTRAINT comment_attr_yl_yl_comment_id_key UNIQUE (yl_comment_id),
    CONSTRAINT comment_attr_yl_rating_check CHECK (rating >= 1 AND rating <= 5)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.comment_attr_yl
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.comment_attr_yl TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.comment_attr_yl TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.configuration
(
    configuration_id character varying COLLATE pg_catalog."default" NOT NULL,
    configuration_doc jsonb NOT NULL,
    CONSTRAINT configuration_pkey PRIMARY KEY (configuration_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.configuration
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.configuration TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.configuration TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.entity
(
    entity_id integer NOT NULL DEFAULT nextval('entity_entity_id_seq'::regclass),
    type character varying COLLATE pg_catalog."default" NOT NULL,
    value character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT entity_pkey PRIMARY KEY (entity_id),
    CONSTRAINT entity_value_key UNIQUE (value),
    CONSTRAINT entity_type_check CHECK (type::text = ANY (ARRAY['activity'::character varying::text, 'tag'::character varying::text]))
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.entity
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.entity TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.entity TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.flag_inferred
(
    comment_id uuid NOT NULL,
    admin_choice character varying(31) COLLATE pg_catalog."default",
    admin_id character varying(63) COLLATE pg_catalog."default",
    watson_suggestion character varying(31) COLLATE pg_catalog."default",
    created timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT flag_inferred_pkey PRIMARY KEY (comment_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.flag_inferred
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.flag_inferred TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.flag_inferred TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.logs_contacted
(
    logs_contacted_id uuid NOT NULL DEFAULT public.uuid_generate_v1(),
    created timestamp with time zone NOT NULL DEFAULT now(),
    message_type character varying(50) COLLATE pg_catalog."default" NOT NULL,
    recipient_id text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT logs_sent_pkey PRIMARY KEY (logs_contacted_id),
    CONSTRAINT logs_contacted_message_type_check CHECK (message_type::text = ANY (ARRAY['Basic'::character varying::text, 'Reply'::character varying::text, 'Notification Owner'::character varying::text, 'Notification Trusted Source'::character varying::text, 'Notification Watchlist'::character varying::text, 'Watchlist Offer'::character varying::text])) NOT VALID
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.logs_contacted
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.logs_contacted TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.logs_contacted TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.logs_processed
(
    logs_processed_id uuid NOT NULL DEFAULT public.uuid_generate_v1(),
    created timestamp with time zone NOT NULL DEFAULT now(),
    action_taken character varying(31) COLLATE pg_catalog."default" NOT NULL,
    action_taken_by character varying(63) COLLATE pg_catalog."default" NOT NULL,
    activity_id character varying(127) COLLATE pg_catalog."default",
    activity_title text COLLATE pg_catalog."default",
    message text COLLATE pg_catalog."default",
    provider_id character varying(3) COLLATE pg_catalog."default" NOT NULL DEFAULT 'YL'::character varying,
    CONSTRAINT logs_processed_pkey PRIMARY KEY (logs_processed_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.logs_processed
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.logs_processed TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.logs_processed TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.nps_client
(
    client_id character varying(15) COLLATE pg_catalog."default" NOT NULL,
    provider_id character varying(3) COLLATE pg_catalog."default" NOT NULL DEFAULT 'NPS'::character varying,
    site_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    id uuid NOT NULL DEFAULT uuid_generate_v1(),
    CONSTRAINT nps_client_pkey PRIMARY KEY (client_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.nps_client
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.nps_client TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.nps_client TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.nps_response
(
    response_id uuid NOT NULL DEFAULT public.uuid_generate_v1(),
    created timestamp with time zone NOT NULL DEFAULT now(),
    score "nps score" NOT NULL,
    client_id character varying(15) COLLATE pg_catalog."default" NOT NULL,
    comment text COLLATE pg_catalog."default" NOT NULL,
    location text COLLATE pg_catalog."default",
    CONSTRAINT nps_response_pkey PRIMARY KEY (response_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.nps_response
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.nps_response TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.nps_response TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.process_result
(
    comment_id uuid NOT NULL,
    created timestamp with time zone NOT NULL DEFAULT now(),
    language character varying(7) COLLATE pg_catalog."default" NOT NULL,
    translation text COLLATE pg_catalog."default",
    nlc_confidence real NOT NULL,
    nlc_top_class character varying(63) COLLATE pg_catalog."default" NOT NULL,
    nlc_response json NOT NULL,
    classifier_name character varying(63) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT process_result_pkey PRIMARY KEY (comment_id),
    CONSTRAINT process_result_nlc_confidence_check CHECK (nlc_confidence >= 0::double precision AND nlc_confidence <= 1::double precision)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.process_result
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.process_result TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.process_result TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.provider
(
    provider_id character varying(3) COLLATE pg_catalog."default" NOT NULL,
    source_id character varying(15) COLLATE pg_catalog."default" NOT NULL,
    created timestamp with time zone NOT NULL DEFAULT now(),
    updated timestamp with time zone NOT NULL DEFAULT now(),
    date_last_loaded timestamp with time zone NOT NULL,
    date_last_processed timestamp with time zone NOT NULL,
    label character varying(63) COLLATE pg_catalog."default" NOT NULL,
    root_classifier_name character varying(31) COLLATE pg_catalog."default" NOT NULL,
    date_last_comment_posted timestamp with time zone NOT NULL,
    CONSTRAINT provider_pkey PRIMARY KEY (source_id, provider_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.provider
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.provider TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.provider TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.role
(
    role_id character varying(31) COLLATE pg_catalog."default" NOT NULL,
    created timestamp(6) with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated timestamp(6) with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    description text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT role_pkey PRIMARY KEY (role_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.role
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.role TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.role TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.role_capability
(
    role_id character varying(31) COLLATE pg_catalog."default" NOT NULL,
    provider_id character varying(3) COLLATE pg_catalog."default" NOT NULL,
    capability_id character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT role_capability_pkey PRIMARY KEY (role_id, provider_id, capability_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.role_capability
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.role_capability TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.role_capability TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.training_example
(
    comment_id uuid NOT NULL,
    classifier_name character varying(63) COLLATE pg_catalog."default" NOT NULL,
    class character varying(63) COLLATE pg_catalog."default" NOT NULL,
    trainer_email character varying(63) COLLATE pg_catalog."default",
    updated timestamp with time zone NOT NULL DEFAULT now(),
    created timestamp with time zone NOT NULL DEFAULT now()
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.training_example
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.training_example TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.training_example TO {{.DBUser}};

CREATE TABLE {{.TenantID}}."user"
(
    user_id character varying(63) COLLATE pg_catalog."default" NOT NULL,
    created timestamp(6) with time zone NOT NULL DEFAULT now(),
    updated timestamp(6) with time zone NOT NULL DEFAULT now(),
    name character varying(63) COLLATE pg_catalog."default" NOT NULL,
    notification_frequency_activity character varying(15) COLLATE pg_catalog."default" NOT NULL,
    cnum character varying(64) COLLATE pg_catalog."default" NOT NULL,
    date_last_visit timestamp with time zone,
    date_first_visit timestamp with time zone,
    date_nps_submitted timestamp with time zone,
    visits_number integer NOT NULL DEFAULT 0,
    CONSTRAINT user_pkey PRIMARY KEY (user_id),
    CONSTRAINT user_notification_frequency_activity_check CHECK (notification_frequency_activity::text = ANY (ARRAY['daily'::character varying::text, 'weekly'::character varying::text, 'monthly'::character varying::text])) NOT VALID,
    CONSTRAINT user_user_id_check CHECK (user_id::text = lower(user_id::text)) NOT VALID
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}."user"
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}."user" TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}."user" TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.user_role
(
    user_id character varying(63) COLLATE pg_catalog."default" NOT NULL,
    role_id character varying(31) COLLATE pg_catalog."default" NOT NULL,
    created timestamp(6) with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT user_role_pkey PRIMARY KEY (user_id, role_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.user_role
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.user_role TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.user_role TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.visitor_history
(
    user_id character varying(63) COLLATE pg_catalog."default" NOT NULL,
    session_id text COLLATE pg_catalog."default" NOT NULL,
    page_url text COLLATE pg_catalog."default" NOT NULL,
    page_view_label text COLLATE pg_catalog."default" NOT NULL,
    created timestamp with time zone NOT NULL DEFAULT now(),
    type text COLLATE pg_catalog."default" NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.visitor_history
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.visitor_history TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.visitor_history TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.watchlist
(
    watchlist_id integer NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character varying(128) COLLATE pg_catalog."default" NOT NULL,
    owner_id text COLLATE pg_catalog."default" NOT NULL,
    updated timestamp with time zone NOT NULL DEFAULT now(),
    created timestamp with time zone NOT NULL DEFAULT now(),
    description text COLLATE pg_catalog."default" NOT NULL DEFAULT ''::text,
    type text COLLATE pg_catalog."default" NOT NULL DEFAULT 'activity'::text,
    CONSTRAINT watchlist_pkey PRIMARY KEY (watchlist_id),
    CONSTRAINT watchlist_type_check CHECK (type = ANY (ARRAY['activity'::text, 'tag'::text])) NOT VALID
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.watchlist
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.watchlist TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.watchlist TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.watchlist_entity
(
    watchlist_id integer NOT NULL,
    entity_id integer NOT NULL,
    created timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT watchlist_entity_pkey PRIMARY KEY (watchlist_id, entity_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.watchlist_entity
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.watchlist_entity TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.watchlist_entity TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.watchlist_offer
(
    offer_id integer NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    status text COLLATE pg_catalog."default" NOT NULL DEFAULT 'pending'::text,
    watchlist_id integer,
    type text COLLATE pg_catalog."default" NOT NULL,
    created timestamp with time zone NOT NULL DEFAULT now(),
    updated timestamp with time zone NOT NULL DEFAULT now(),
    watchlist_snapshot json,
    is_notification_sent boolean NOT NULL DEFAULT false,
    message text COLLATE pg_catalog."default" NOT NULL DEFAULT ''::text,
    offered_by_email character varying COLLATE pg_catalog."default" NOT NULL,
    offered_by_name character varying COLLATE pg_catalog."default" NOT NULL,
    offered_to_email character varying COLLATE pg_catalog."default" NOT NULL,
    offered_to_name character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT watchlist_offer_pkey PRIMARY KEY (offer_id),
    CONSTRAINT watchlist_offer_status_check CHECK (status = ANY (ARRAY['accepted'::text, 'pending'::text, 'rejected'::text])),
    CONSTRAINT watchlist_offer_type_check CHECK (type = ANY (ARRAY['copy'::text, 'share'::text]))
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.watchlist_offer
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.watchlist_offer TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.watchlist_offer TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.watchlist_user
(
    watchlist_id integer NOT NULL,
    user_id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    created timestamp with time zone NOT NULL DEFAULT now(),
    updated timestamp with time zone NOT NULL DEFAULT now(),
    starred boolean NOT NULL DEFAULT false,
    notification_frequency character varying(7) COLLATE pg_catalog."default" NOT NULL DEFAULT 'opt-out'::character varying,
    offer_id integer,
    CONSTRAINT watchlist_user_pkey PRIMARY KEY (watchlist_id, user_id),
    CONSTRAINT watchlist_user_notification_frequency_check CHECK (notification_frequency::text = ANY (ARRAY['daily'::character varying::text, 'weekly'::character varying::text, 'monthly'::character varying::text, 'opt-out'::character varying::text]))
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.watchlist_user
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.watchlist_user TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.watchlist_user TO {{.DBUser}};

---
---
---

CREATE TABLE {{.TenantID}}.comment_attr_gm
(
    comment_id uuid NOT NULL,
    created timestamp with time zone NOT NULL DEFAULT now(),
    score "nps score" NOT NULL,
    band_level character varying(63) COLLATE pg_catalog."default" NOT NULL,
    business_unit character varying(15) COLLATE pg_catalog."default" NOT NULL,
    home_country character varying(31) COLLATE pg_catalog."default" NOT NULL,
    host_country character varying(31) COLLATE pg_catalog."default" NOT NULL,
    mobility_consultant character varying(127) COLLATE pg_catalog."default" NOT NULL,
    plan_type character varying(127) COLLATE pg_catalog."default" NOT NULL,
    question text COLLATE pg_catalog."default" NOT NULL,
    survey_id integer NOT NULL,
    phase character(3) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT comment_attr_gm_pkey PRIMARY KEY (comment_id),
    CONSTRAINT comment_attr_gm_nps_source_check CHECK (phase::text = ANY (ARRAY['SOA'::character varying::text, 'EOA'::character varying::text]))
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.comment_attr_gm
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.comment_attr_gm TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.comment_attr_gm TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.comment_attr_l1
(
    comment_id uuid NOT NULL,
    created timestamp with time zone NOT NULL DEFAULT now(),
    activity_id character varying(63) COLLATE pg_catalog."default" NOT NULL,
    score "nps score" NOT NULL,
    offering_location text COLLATE pg_catalog."default",
    offering_id text COLLATE pg_catalog."default",
    CONSTRAINT comment_attr_l1_pkey PRIMARY KEY (comment_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.comment_attr_l1
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.comment_attr_l1 TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.comment_attr_l1 TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.comment_attr_nps
(
    comment_id uuid NOT NULL,
    created timestamp with time zone NOT NULL DEFAULT now(),
    score "nps score" NOT NULL,
    referrer text COLLATE pg_catalog."default",
    CONSTRAINT comment_attr_nps_pkey PRIMARY KEY (comment_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.comment_attr_nps
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.comment_attr_nps TO {{.DBAdmin}};

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE {{.TenantID}}.comment_attr_nps TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.comment_attr_sg
(
    comment_id uuid NOT NULL,
    created timestamp with time zone NOT NULL DEFAULT now(),
    score "nps score" NOT NULL,
    referer text COLLATE pg_catalog."default",
    CONSTRAINT comment_attr_sg_pkey PRIMARY KEY (comment_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.comment_attr_sg
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.comment_attr_sg TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.comment_attr_sg TO {{.DBUser}};

CREATE TABLE {{.TenantID}}.nps_page_sg
(
    url_pattern character varying COLLATE pg_catalog."default" NOT NULL,
    title character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT nps_page_pkey PRIMARY KEY (url_pattern)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE {{.TenantID}}.nps_page_sg
    OWNER to {{.DBAdmin}};

GRANT ALL ON TABLE {{.TenantID}}.nps_page_sg TO {{.DBAdmin}};

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE {{.TenantID}}.nps_page_sg TO {{.DBUser}};
