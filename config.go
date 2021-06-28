package main

import (
	"encoding/json"
	"fmt"
	"github.com/ivansukach/db-data-copy-paste/database"
	"os"
)

func readConfig(source bool) (database.Config, error) {
	file := &os.File{}
	var err error
	if source {
		file, err = os.Open("config_source.json")
	} else {
		file, err = os.Open("config_receiver.json")
	}

	if err != nil {
		return database.Config{}, fmt.Errorf("failed to open file: %w", err)
	}
	defer file.Close()

	var c database.Config
	err = json.NewDecoder(file).Decode(&c)
	if err != nil {
		return c, fmt.Errorf("failed to decode json: %w", err)
	}

	return c, nil
}
