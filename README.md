
# MyEdgeApp Service

Server for a end-2-end encrypted proxy pass for Edgebox using tinc, etcd and traefik. Made to run as a gateway to EdgeApps across multiple devices, even those running under private networks.


## Running locally

Run locally with

```bash
  docker-compose up
```

## Creating a cloud image

This repository includes a [Packer](https://www.packer.io/) configuration for building machine images.

1. Create the `variables.auto.pkrvars.hcl` file and insert any necessary variables to build your images (See `image variables` below ). The format is `key = value`.
2. Run:
```bash
  packer build .
```

## Image variables
Depending on the image being built, it may require variables that need to be provided beforehand. Here's a list of variables per type of image supported:

### All Images
 - `system_pw` - The default password for the system user.

### DigitalOcean
- `digitalocean-api_token` - The API token that can be obtained in your DigitalOcean account.

## Contributing

Contributions are always welcome!

See `contributing.md` for ways to get started.

Please adhere to this project's `code of conduct`.

