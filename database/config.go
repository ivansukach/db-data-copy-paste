package database

import (
	"encoding/base64"
	"fmt"
	"os"
	"time"
)

const pqCertFilename = "configs/root.crt"

type Config struct {
	PostgresConnString     string
	PostgresCert64         string
	PoolMaxConnections     int
	PoolMaxIdleConnections int
	PoolMaxConnLife        time.Duration
	PoolMaxIdleConnLife    time.Duration
}

func (c *Config) ConnectionURL() string {
	if c == nil {
		return ""
	}
	return fmt.Sprintf("%s&sslrootcert=%s", c.PostgresConnString, pqCertFilename)
}

// CreatePqCertFile reads base64 encoded postgres certificate from credentials env variable,
// decodes and saves to file
func (c *Config) CreatePqCertFile() error {
	pqCert, err := base64.StdEncoding.DecodeString(c.PostgresCert64)
	if err != nil {
		return fmt.Errorf("unable to decode postgres certificate: %w", err)
	}

	err = os.WriteFile(pqCertFilename, pqCert, 0644)
	if err != nil {
		return err
	}
	return nil
}
