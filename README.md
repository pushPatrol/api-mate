# API Mate

API Mate is a browser-based tool for testing the [BigBlueButton](https://bigbluebutton.org) API.
It generates signed API URLs on the fly and lets you call them directly from the browser.

---

## Running with Docker

The easiest way to run API Mate is with Docker Compose:

```bash
docker-compose up -d
```

The app is then available at <http://localhost:9000>.

### Custom server list

By default the image ships with a built-in `servers.json`. You can override it at runtime by
mounting your own file (no rebuild needed):

```yaml
# docker-compose.yml
volumes:
  - ./servers.json:/usr/share/nginx/html/servers.json:ro
```

The file must be a JSON array:

```json
[
  {
    "name": "My BBB Server",
    "url": "https://my-server.example.com/bigbluebutton/api",
    "secret": "my-shared-secret"
  }
]
```

---

## Server dropdown

The **Server** dropdown in the UI is populated from `servers.json`. Selecting a server
automatically fills in the shared secret field, so credentials never have to be typed manually.

---

## Development

**Prerequisites:** Node.js (see `.nvmrc` for the exact version) and npm.

```bash
# Install dependencies
npm install

# Build once
./node_modules/.bin/cake build

# Watch for changes and rebuild automatically
./node_modules/.bin/cake watch
```

Compiled files are written to `lib/`. Serve them with any static file server, e.g.:

```bash
npx serve lib/
```

---

## CI/CD Pipeline

The GitLab CI/CD pipeline (`.gitlab-ci.yml`) runs the following stages:

| Stage | Trigger | What it does |
|-------|---------|--------------|
| **test** | every push | Builds the assets and validates `servers.json` |
| **build** | `development` / `master` branch | Builds and pushes a Docker image to the registry |
| **deploy** | `development` branch | SSH-deploys the new image to the test server |
| **release** | version tag (e.g. `v1.0.0`) | Creates a GitLab Release and mirrors it to GitHub |

### Required CI/CD variables

| Variable | Description |
|----------|-------------|
| `REGISTRY_HOST` | Docker registry hostname |
| `SSH_PRIVATE_KEY` | Private SSH key for the test server |
| `SSH_KNOWN_HOSTS` | `known_hosts` entry for the test server |
| `DEPLOY_HOST` | Hostname / IP of the test server |
| `DEPLOY_USER` | SSH user on the test server |
| `GITHUB_TOKEN` | GitHub Personal Access Token (scope: `repo`) |
| `GITHUB_URL` | Base URL of the GitHub account (e.g. `https://github.com/your-org`) |

---

## License

Distributed under the [MIT License](LICENSE).
Copyright (c) 2013 Mconf, 2026 pushPatrol.
