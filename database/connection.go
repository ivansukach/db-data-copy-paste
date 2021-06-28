package database

import (
	"context"
	"errors"
	"fmt"
	_ "github.com/ivansukach/super-pq"
	"github.com/ivansukach/super-sql"
)

type DB struct {
	Pool *sql.DB
}

var (
	ErrNotFound      = errors.New("record not found")
	ErrAlreadyExists = errors.New("record already exists")
)

// New sets up the database connections using the configuration.
// This should be called just once per server instance.
func New(ctx context.Context, config *Config) (*DB, error) {
	// Compose DB connection string
	dbFullURL := config.ConnectionURL()

	// Create root certificate file
	if err := config.CreatePqCertFile(); err != nil {
		return nil, err
	}

	// Open DB connection
	pool, err := sql.Open("postgres", dbFullURL)
	if err != nil {
		return nil, fmt.Errorf("creating connection pool: %v", err)
	}
	if err := pool.Ping(); err != nil {
		return nil, fmt.Errorf("ping database: %v", err)
	}
	if config.PoolMaxConnections > 0 {
		pool.SetMaxOpenConns(config.PoolMaxConnections)
	}
	if config.PoolMaxConnLife > 0 {
		pool.SetConnMaxLifetime(config.PoolMaxConnLife)
	}
	if config.PoolMaxIdleConnections > 0 {
		pool.SetMaxIdleConns(config.PoolMaxIdleConnections)
	}
	if config.PoolMaxIdleConnLife > 0 {
		pool.SetConnMaxIdleTime(config.PoolMaxIdleConnLife)
	}

	return &DB{Pool: pool}, nil
}

// InTx runs the given function f within a transaction
func (db *DB) InTx(ctx context.Context, f func(tx *sql.Tx) error) error {
	tx, err := db.Pool.BeginTx(ctx, nil)
	if err != nil {
		return fmt.Errorf("starting transaction: %v", err)
	}

	if err := f(tx); err != nil {
		if err1 := tx.Rollback(); err1 != nil {
			return fmt.Errorf("rolling back transaction: %v (original error: %v)", err1, err)
		}
		return err
	}

	if err := tx.Commit(); err != nil {
		return fmt.Errorf("committing transaction: %v", err)
	}
	return nil
}

// Close releases database connections.
func (db *DB) Close(ctx context.Context) {
	db.Pool.Close()
}

func (db *DB) SelectBlob(ctx context.Context, query string) ([]byte, error) {
	var blob []byte
	err := db.Pool.QueryRowContext(ctx, query).Scan(&blob)
	if err == sql.ErrNoRows {
		return nil, ErrNotFound
	}
	return blob, err
}
