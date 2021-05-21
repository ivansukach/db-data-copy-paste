package main

import (
	_ "github.com/lib/pq"

	"context"
	"fmt"
	"github.ibm.com/HRLearning/AmplifyApiServer/pkg/database"
	"log"
)

func main() {
	config, err := readConfig()
	if err != nil {
		log.Fatal(fmt.Errorf("failed to read config: %w", err))
	}

	scriptOrder := []string{
		"role", // remove if role already exists
		"schema",
		"domains",
		"functions",
		"sequences",
		"tables",
		"table-data",
		"views",
		"relations",
	}

	scriptsByName, err := getAllParsedScripts(scriptOrder, config.ScriptTemplate)
	if err != nil {
		log.Fatal(fmt.Errorf("failed to get all parsed scripts: %w", err))
	}

	db, err := database.New(context.Background(), &config.DB)
	if err != nil {
		log.Fatal(fmt.Errorf("failed to create DB: %w", err))
	}

	tx, err := db.Pool.Begin()
	if err != nil {
		log.Fatal(fmt.Errorf("failed to begin tx: %w", err))
	}
	defer tx.Rollback()

	for _, name := range scriptOrder {
		if _, err := tx.Exec(scriptsByName[name]); err != nil {
			log.Fatal(fmt.Errorf("failed to exec %s script: %w", name, err))
		}
	}

	if err := tx.Commit(); err != nil {
		log.Fatal(fmt.Errorf("failed to commit tx: %w", err))
	}
}

func getAllParsedScripts(scriptNames []string, filler scriptTemplateConfig) (map[string]string, error) {
	scriptsByName := make(map[string]string, len(scriptNames))
	for _, name := range scriptNames {
		script, err := getParsedScript(name, filler)
		if err != nil {
			return nil, fmt.Errorf("failed to get parsed %s script: %w", name, err)
		}
		scriptsByName[name] = script
	}

	return scriptsByName, nil
}
