# Caddy Cluster / Certmagic TLS cluster support for S3

[S3](https://aws.amazon.com/s3/) Storage for [Caddy](https://github.com/caddyserver/caddy) TLS data. 

## Configuration

You enable S3 storage with Caddy by setting the `CADDY_CLUSTERING` environment variable to `s3`.  

Required Variables:

- `CADDY_CLUSTERING_S3_BUCKET` defines your S3 bucket name
- `CADDY_CLUSTERING_S3_REGION` defines the S3 region
