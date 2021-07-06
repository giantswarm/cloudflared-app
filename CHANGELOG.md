# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2021-07-06

### Changed

- Bump the version and use `2021.6.0`

### Fix

- Set security context correctly so distroless image can start
- Ensure that a Tunnel Name or ID is set when running the tunnel
- Correct reference to replicas in deployment YAML

## [0.1.0] - 2021-05-17

### Changed
- Support single deployment with multiple replicas

### Added
- Support the use of existing (pre-created) Argo Tunnels
- Pre delete hook that deletes the tunnels *only* for App managed tunnels (not pre-created tunnels)

## v0.0.5

### Fix

- Full url to images in README to fix catalogue documentation

## v0.0.4

### Fix

- Correct Chart icon image

## v0.0.3
First Release

## v0.0.2
Version not released

## v0.0.1
Version not released

[Unreleased]: https://github.com/giantswarm/cloudflared-app/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/giantswarm/cloudflared-app/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/giantswarm/cloudflared-app/compare/v0.0.5...v0.1.0
[0.0.4]: https://github.com/giantswarm/cloudflared-app/compare/v0.0.4...v0.0.5
[0.0.3]: https://github.com/giantswarm/cloudflared-app/compare/v0.0.3...v0.0.4
[0.0.2]: https://github.com/giantswarm/cloudflared-app/compare/v0.0.2...v0.0.3
[0.0.1]: https://github.com/giantswarm/cloudflared-app/compare/v0.0.1...v0.0.2
