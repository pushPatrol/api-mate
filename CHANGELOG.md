# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [1.0.1] - 2026-06-01

### Added
- Vulnerability scanning (Grype) with EPSS-based thresholds integrated into CI/CD pipeline
- Secret scanning (Gitleaks) on every branch push
- HTTP security headers in nginx (`X-Frame-Options`, `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy`, `Content-Security-Policy`, `Strict-Transport-Security`)
- SBOM generation with Syft (SPDX-JSON format), attached to releases via GitLab Package Registry
- Daily scheduled security scan with artifact reporting (`npm audit` + Grype)
- `npm audit` integrated into the build pipeline

### Changed
- Grype configuration moved to `.grype.yaml`
- Alpine packages upgraded in Docker image on every build (`apk upgrade`)
- `servers.json` renamed to `servers.json.example` to clarify it is a template

## [1.0.0] - 2026-06-01

### Added
- Server dropdown with auto-fill secret from `lib/servers.json`
- Docker image served by nginx
- GitLab CI/CD pipeline with automated releases
- GitHub mirror with synchronized releases
