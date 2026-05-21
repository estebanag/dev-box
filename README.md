# Dev Box

A containerized development environment built on Docker. A single
`docker compose up` drops you into a `byobu` session
(that can work with displays) with the following available:

- **Neovim** + **AstroNvim**
- **Node.js**
- **uv**
- **Java** (maven + JDK)
- **LaTeX** (full scientific stack)

The container's `ubuntu` user mirrors your host user's UID/GID so files written
to the workspace are owned correctly on the host.

---

## First-time setup

```sh
# 1. Clone the repo
git clone https://github.com/estebanag/dev-box.git
cd dev-box

# 2. Create your .env from the template
cp .env.example .env
```

Edit `.env` and fill in all variables:

| Variable | Description |
|---|---|
| `WORKSPACE_DIR` | Absolute path to your workspace on the host |
| `GIT_USER_EMAIL` | Email for `git config --global user.email` |
| `GIT_USER_NAME` | Name for `git config --global user.name` |


```sh
# 3. Build the image
docker compose build
```

```sh
# 4. Start the Dev Box
docker compose run --rm devbox byobu
```

On the very first launch, open `nvim` and wait for AstroNvim to install its
plugins. This only happens once (plugin state lives in the named
volumes).

---

## Daily use

### 1. Start Dev Box in the background
```sh
docker compose up -d devbox
```

> The workspace is mounted at `/workspace`. All files you create there appear on the
host under `WORKSPACE_DIR`.

> On every start the entrypoint script overlays the nvim custom config
(`.config/nvim/`) onto the nvim config volume, so any changes you make to
`.config/nvim/` are applied automatically next time the Dev Box starts.

### 2. Enter the Dev Box
```sh
./enter.sh
```

### 3. Stop the Dev Box and remove containers
```sh
docker compose down
```
