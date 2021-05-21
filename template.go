package main

import (
	"bytes"
	"text/template"
	"errors"
	"fmt"
)

type scriptTemplateConfig struct {
	TenantID string `json:"TenantID"`
	DBAdmin  string `json:"DBAdmin"`
	DBUser   string `json:"DBUser"`
}

func (c scriptTemplateConfig) validate() error {
	if c.TenantID == "" {
		return errors.New("tenant_id is empty")
	}
	if c.DBAdmin == "" {
		return errors.New("db_admin is empty")
	}
	if c.DBUser == "" {
		return errors.New("db_user is empty")
	}

	return nil
}

func getParsedScript(name string, filler scriptTemplateConfig) (string, error) {
	rawScript, err := getRawScript(name)
	if err != nil {
		return "", fmt.Errorf("failed to get raw script: %w", err)
	}

	return fillTemplate(rawScript, filler)
}

func fillTemplate(textTemplate string, params interface{}) (string, error) {
	t, err := template.New("SQL Stmt").Parse(textTemplate)
	if err != nil {
		return "", err
	}
	buf := new(bytes.Buffer)
	err = t.Execute(buf, params)
	return buf.String(), err
}
