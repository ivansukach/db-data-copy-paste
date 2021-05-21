package main

import (
	"fmt"
	"io"
	"os"
)

const basePath = "./scripts/db/"

func getRawScript(name string) (string, error) {
	file, err := os.Open(basePath + name + ".sql")
	if err != nil {
		return "", fmt.Errorf("failed to open file: %w", err)
	}
	defer file.Close()

	buf, err := io.ReadAll(file)
	if err != nil {
		return "", fmt.Errorf("failed to read file: %w", err)
	}

	return string(buf), nil
}
