package storages3

import (
	"os"

	"github.com/caddyserver/caddy/caddytls"
	"github.com/mholt/certmagic"
	"github.com/securityclippy/magicstorage"
)

const (
	// EnvNameBucket defines the env variable name for the bucket name
	EnvNameBucket = "CADDY_CLUSTERING_S3_BUCKET"

	// EnvNamePath defines the env variable name for the region
	EnvNameRegion = "CADDY_CLUSTERING_S3_REGION"
)

func init() {
	caddytls.RegisterClusterPlugin("s3", constructS3ClusterPlugin)
}

// NewS3Storage connects to S3 and returns a S3Store
func NewS3Storage() (*magicstorage.S3Storage, error) {
	// override default values from ENV
	bucket := os.Getenv(EnvNameBucket)

	region := os.Getenv(EnvNameRegion)

	ss := magicstorage.NewS3Storage(bucket, region)

	return ss, nil
}

func constructS3ClusterPlugin() (certmagic.Storage, error) {
	return NewS3Storage()
}
