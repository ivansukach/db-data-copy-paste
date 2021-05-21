INSERT INTO {{.TenantID}}.classifier(
	classifier_name, classifier_id, instance_apikey)
	VALUES (?, '-', ?);
