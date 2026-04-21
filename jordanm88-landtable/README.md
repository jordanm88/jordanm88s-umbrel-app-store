# Landtable for Umbrel

Drop-in app definition for installing Landtable on
[umbrelOS](https://umbrel.com/) via your fork of the
[`getumbrel/umbrel-apps`](https://github.com/getumbrel/umbrel-apps) repo (or
your own community app store).

## What's here

| File                  | Purpose                                                                  |
| --------------------- | ------------------------------------------------------------------------ |
| `docker-compose.yml`  | Compose file Umbrel runs. Modeled after the upstream `nocodb` app.       |
| `umbrel-app.yml`      | Umbrel app manifest (id, name, version, port, etc.).                     |
| `exports.sh`          | Empty placeholder; Landtable does not export inter-app env vars.         |

## Install

1. **Make the GHCR image public.** This is the most common reason Umbrel
   silently fails to install a custom app — the image defaults to private.
   - GitHub → your profile → **Packages** → `landtable` → **Package settings**
     → **Change visibility** → **Public**.
   - Verify from any machine: `docker pull ghcr.io/jordanm88/landtable:latest`
     should succeed without authentication.
2. **Fork** [`getumbrel/umbrel-apps`](https://github.com/getumbrel/umbrel-apps)
   (or use your own community app store repo).
3. Create `<store-root>/jordanm88-landtable/` and copy the three files from
   this directory into it. The folder name **must** match the `id` in
   `umbrel-app.yml` and the `APP_HOST` prefix in `docker-compose.yml`.
4. (Production-grade) Pin the image to a digest:
   ```sh
   docker buildx imagetools inspect ghcr.io/jordanm88/landtable:latest
   ```
   then change `image:` to e.g.
   `ghcr.io/jordanm88/landtable:0.9.7@sha256:<digest>`.
5. Add the fork as a community app store inside Umbrel
   (Settings → Community App Stores → Add) and install Landtable.

## Common install failures

| Symptom                                                          | Cause / Fix                                                                                     |
| ---------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| `services.<svc>.environment must be a mapping`                   | `environment:` written as YAML list (`- KEY=value`). Use mapping form (`KEY: value`).           |
| Install spinner forever, no error                                | GHCR image is **private**. Make the package public (see step 1).                                |
| `pull access denied` / `manifest unknown`                        | Wrong image path, wrong tag, or image not yet built by the GitHub Actions workflow.             |
| App container restart-loops                                      | `${APP_DATA_DIR}/data` not writable by uid 1000 — `sudo chown -R 1000:1000 ${APP_DATA_DIR}`.    |
| Browser shows Umbrel login first, then Landtable login           | Set `PROXY_AUTH_ADD: "false"` in `app_proxy` (already set in the bundled compose).              |

## Persistent data

Landtable stores the SQLite database and auto-generated secrets at `/data`
inside the container. Umbrel maps `${APP_DATA_DIR}/data` to that path so
everything (including JWT/encryption keys minted on first boot) survives
restarts and updates.

## First-time setup

After installation, open the app from your Umbrel home screen and **register
the first account** — that account is automatically granted system-admin
rights by Landtable's own auth flow.
