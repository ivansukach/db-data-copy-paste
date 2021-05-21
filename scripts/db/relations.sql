ALTER TABLE {{.TenantID}}.classifier
    ADD CONSTRAINT classifier_classifier_instance_instance_apikey_fk FOREIGN KEY (instance_apikey)
        REFERENCES {{.TenantID}}.classifier_instance (instance_apikey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

ALTER TABLE {{.TenantID}}.classifier_class
    ADD CONSTRAINT classifier_class_classifier_name_fkey FOREIGN KEY (classifier_name)
        REFERENCES {{.TenantID}}.classifier (classifier_name) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT;
ALTER TABLE {{.TenantID}}.classifier_class
    ADD CONSTRAINT classifier_class_subclassifier_name_fkey FOREIGN KEY (subclassifier_name)
        REFERENCES {{.TenantID}}.classifier (classifier_name) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT;

ALTER TABLE {{.TenantID}}.classifier_training_request
    ADD CONSTRAINT classifier_training_request_status_fkey FOREIGN KEY (status)
        REFERENCES {{.TenantID}}.classifier_training_request_status (status) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID;

ALTER TABLE {{.TenantID}}.classifier_training_request_data
    ADD CONSTRAINT training_request_data_request_id_fkey FOREIGN KEY (request_id)
        REFERENCES {{.TenantID}}.classifier_training_request (request_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

ALTER TABLE {{.TenantID}}.comment
    ADD CONSTRAINT comment_provider_id_fkey FOREIGN KEY (provider_id, source_id)
        REFERENCES {{.TenantID}}.provider (provider_id, source_id) MATCH FULL
        ON UPDATE RESTRICT
        ON DELETE RESTRICT;

ALTER TABLE {{.TenantID}}.comment_attr_yl
    ADD CONSTRAINT comment_attr_yl_comment_id_fkey FOREIGN KEY (comment_id)
        REFERENCES {{.TenantID}}.comment (comment_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE;

ALTER TABLE {{.TenantID}}.flag_inferred
    ADD CONSTRAINT flag_inferred_comment_id_fkey FOREIGN KEY (comment_id)
        REFERENCES {{.TenantID}}.comment (comment_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE;

ALTER TABLE {{.TenantID}}.logs_processed
    ADD CONSTRAINT logs_processed_provider_id_fkey FOREIGN KEY (action_taken, provider_id)
        REFERENCES {{.TenantID}}.capability (capability_id, provider_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID;

ALTER TABLE {{.TenantID}}.nps_client
    ADD CONSTRAINT nps_client_client_id_fkey FOREIGN KEY (provider_id, client_id)
        REFERENCES {{.TenantID}}.provider (provider_id, source_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

ALTER TABLE {{.TenantID}}.nps_response
    ADD CONSTRAINT nps_response_client_id_fkey FOREIGN KEY (client_id)
        REFERENCES {{.TenantID}}.nps_client (client_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

ALTER TABLE {{.TenantID}}.process_result
    ADD CONSTRAINT process_result_nlc_top_class_classifier_name_fkey FOREIGN KEY (classifier_name, nlc_top_class)
        REFERENCES {{.TenantID}}.classifier_class (classifier_name, class_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID;
ALTER TABLE {{.TenantID}}.process_result
    ADD CONSTRAINT process_result_process_id_fkey FOREIGN KEY (comment_id)
        REFERENCES {{.TenantID}}.comment (comment_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE;

ALTER TABLE {{.TenantID}}.provider
    ADD CONSTRAINT provider_root_classifier_name_fkey FOREIGN KEY (root_classifier_name)
        REFERENCES {{.TenantID}}.classifier (classifier_name) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID;

ALTER TABLE {{.TenantID}}.role_capability
    ADD CONSTRAINT role_capability_provider_id_capability_id_fkey FOREIGN KEY (capability_id, provider_id)
        REFERENCES {{.TenantID}}.capability (capability_id, provider_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;
ALTER TABLE {{.TenantID}}.role_capability
    ADD CONSTRAINT role_capability_role_id_fkey FOREIGN KEY (role_id)
        REFERENCES {{.TenantID}}.role (role_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

ALTER TABLE {{.TenantID}}.user_role
    ADD CONSTRAINT user_role_role_id_fkey FOREIGN KEY (role_id)
        REFERENCES {{.TenantID}}.role (role_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID;
ALTER TABLE {{.TenantID}}.user_role
    ADD CONSTRAINT user_role_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES {{.TenantID}}."user" (user_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID;

ALTER TABLE {{.TenantID}}.visitor_history
    ADD CONSTRAINT visitor_history_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES {{.TenantID}}."user" (user_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE;

ALTER TABLE {{.TenantID}}.watchlist
    ADD CONSTRAINT watchlist_owner_id_fkey FOREIGN KEY (owner_id)
        REFERENCES {{.TenantID}}."user" (user_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID;

ALTER TABLE {{.TenantID}}.watchlist_entity
    ADD CONSTRAINT watchlist_entity_entity_id_fkey FOREIGN KEY (entity_id)
        REFERENCES {{.TenantID}}.entity (entity_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT;
ALTER TABLE {{.TenantID}}.watchlist_entity
    ADD CONSTRAINT watchlist_entity_watchlist_id_fkey FOREIGN KEY (watchlist_id)
        REFERENCES {{.TenantID}}.watchlist (watchlist_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE;

ALTER TABLE {{.TenantID}}.watchlist_offer
    ADD CONSTRAINT watchlist_offer_watchlist_id_fkey FOREIGN KEY (watchlist_id)
        REFERENCES {{.TenantID}}.watchlist (watchlist_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE;

ALTER TABLE {{.TenantID}}.watchlist_user
    ADD CONSTRAINT watchlist_user_offer_id_fkey FOREIGN KEY (offer_id)
        REFERENCES {{.TenantID}}.watchlist_offer (offer_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE SET NULL;
ALTER TABLE {{.TenantID}}.watchlist_user
    ADD CONSTRAINT watchlist_user_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES {{.TenantID}}."user" (user_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE;
ALTER TABLE {{.TenantID}}.watchlist_user
    ADD CONSTRAINT watchlist_user_watchlist_id_fkey FOREIGN KEY (watchlist_id)
        REFERENCES {{.TenantID}}.watchlist (watchlist_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE;

---
---
---

ALTER TABLE {{.TenantID}}.comment_attr_gm
    ADD CONSTRAINT comment_attr_gm_comment_id_fkey FOREIGN KEY (comment_id)
        REFERENCES {{.TenantID}}.comment (comment_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE;

ALTER TABLE {{.TenantID}}.comment_attr_l1
    ADD CONSTRAINT comment_attr_l1_comment_id_fkey FOREIGN KEY (comment_id)
        REFERENCES {{.TenantID}}.comment (comment_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE;

ALTER TABLE {{.TenantID}}.comment_attr_nps
    ADD CONSTRAINT comment_attr_nps_comment_id_fkey FOREIGN KEY (comment_id)
        REFERENCES {{.TenantID}}.comment (comment_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE;

ALTER TABLE {{.TenantID}}.comment_attr_sg
    ADD CONSTRAINT comment_attr_sg_comment_id_fkey FOREIGN KEY (comment_id)
        REFERENCES {{.TenantID}}.comment (comment_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE;
