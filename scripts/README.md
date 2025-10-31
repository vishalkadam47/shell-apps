# Scripts

This folder contains utility scripts for the shell-apps system.

## local-server.js

A simple Node.js HTTP server with CORS enabled for local development and testing.

### Usage:
```bash
cd shell-apps-repo/scripts
node local-server.js
```

This will serve the shell-apps-repo content on `http://localhost:8080` with CORS headers enabled, allowing you to test the UI locally by changing the `REPO_BASE_URL` in the React component to `'http://localhost:8080/'`.

### Features:
- CORS enabled for cross-origin requests
- Serves YAML, SVG, PNG files with correct content types
- Serves from the shell-apps-repo root directory
- Simple file server for development testing

