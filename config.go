package main

import (
	"encoding/json"
	"fmt"
	"github.ibm.com/HRLearning/AmplifyApiServer/pkg/database"
	"os"
)

type config struct {
	DB             database.Config      `json:"DB"`
	ScriptTemplate scriptTemplateConfig `json:"ScriptTemplate"`
}

func (c config) validate() error {
	if err := c.ScriptTemplate.validate(); err != nil {
		return fmt.Errorf("bad config template: %w", err)
	}

	return nil
}

func readConfig() (config, error) {
	file, err := os.Open("config.json")
	if err != nil {
		return config{}, fmt.Errorf("failed to open file: %w", err)
	}
	defer file.Close()

	var c config
	err = json.NewDecoder(file).Decode(&c)
	if err != nil {
		return c, fmt.Errorf("failed to decode json: %w", err)
	}

	return c, c.validate()
}
