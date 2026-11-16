[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/typesense-2?utm_medium=integration&utm_source=button&utm_campaign=typesense)

# Typesense on Railway

This repo is the source of the **Typesense** template on Railway. It deploys [Typesense](https://typesense.org) **30.2**, an open-source, typo-tolerant search engine, as a single service built from this repo's `Dockerfile`.

## What it deploys

- One service, `Typesense`, built from `Dockerfile`: the official image `typesense/typesense:30.2`, pinned by digest, plus `start.sh`, a small wrapper that maps Railway's `PORT` and volume onto Typesense's settings.
- A Railway volume at `/data` for the indexes, so collections and documents survive redeploys.
- A public Railway domain. `GET /health` answers without a key and is the health check; every other endpoint needs the API key.

## Variables

| Variable | Default | What it does |
|---|---|---|
| `TYPESENSE_API_KEY` | `${{secret(32)}}` | Admin API key, generated at deploy. Send it as the `X-TYPESENSE-API-KEY` header. Use it to create scoped search-only keys for browsers |
| `PORT` | `8108` | Port Typesense listens on |
| `TYPESENSE_DATA_DIR` | `/data` | Where the indexes are stored (the volume) |
| `TYPESENSE_URL` | `http://${{RAILWAY_PRIVATE_DOMAIN}}:${{PORT}}` | Private URL for other services in the same project |
| `TYPESENSE_PUBLIC_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Public URL |

`start.sh` also sets these defaults, which you can override with a variable of the same name: `TYPESENSE_ENABLE_CORS=true`, `TYPESENSE_THREAD_POOL_SIZE=32`, `TYPESENSE_NUM_COLLECTIONS_PARALLEL_LOAD=8`, `TYPESENSE_API_ADDRESS=::`. Any other [Typesense server setting](https://typesense.org/docs/30.2/api/server-configuration.html) can be set as a `TYPESENSE_*` variable.

## Quick check

```sh
curl https://YOUR-DOMAIN/health
curl -H "X-TYPESENSE-API-KEY: YOUR-KEY" https://YOUR-DOMAIN/collections
```

## How updates reach you

When a new Typesense version is tested, this repo's `Dockerfile` pin is bumped on a branch, an entry is added to `CHANGELOG.md`, and the change is merged to `main`. Railway then shows an "update available" notice on projects deployed from the template, and you choose when to apply it. Read `CHANGELOG.md` before applying, and back up the volume before a major version upgrade.

## Run it locally

```sh
docker build -t typesense-railway .
docker run -p 8108:8108 -e TYPESENSE_API_KEY=change-me -v typesense-data:/data typesense-railway
```
