INSERT INTO {{.TenantID}}.classifier_training_request_status (status, description)
VALUES
    ('NEW', 'Newly created classifier training request. Training has not started yet'),
    ('IN_PROGRESS', 'Classifier training is in progress'),
    ('TRAINED', 'Classifier training had finished. Classifier is in Available status and is ready for evaluation.'),
    ('ACCEPTED', 'New classifier showed better results over the existing classifier and was accepted. Last state'),
    ('REJECTED', 'New classifier showed worse results over the existing classifier and was rejected. Last state');

INSERT INTO {{.TenantID}}.configuration(configuration_id, configuration_doc)
VALUES
    ('DQALastRun',           CONCAT('"',now()::text,'"')::jsonb),
    ('YLActivityLastSynced', CONCAT('"',now()::text,'"')::jsonb),
    ('OutageMessage', '{
    "message": ""
}');

INSERT INTO {{.TenantID}}.role(role_id, description)
VALUES
    ('AmplifyAdmin', 'Can view all areas in Amplify and perform all actions. Can create/edit users and roles.'),
    ('ActivitiesAdmin', 'Can view Flagged Activities view and take action (e.g. flagging) on YL comments and Currently Flagged/processed activities.'),
    ('ReportsViewer', 'Can view the Reporting area and run reports.');
