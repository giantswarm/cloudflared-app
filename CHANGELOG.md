# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Ability to specify annotations of the Deployment

### Changed

- Do not install PodSecurityPolicy if api not available.
- Make deployment PSS compliant.

## [0.4.0] - 2022-09-15

### Added

- Support for Quick Tunnels

### Changed

- Upgrade app to version `2022.8.4`
- Remove "argo" references from template names

## [0.3.0] - 2021-12-16

### Changed

- Added new Cloudflared version
- Improve the Readme explanation
- Add `application.giantswarm.io/team` to common labels ([#17](https://github.com/giantswarm/cloudflared-app/pull/17))

## [0.2.2] - 2021-11-03

- Metadata updates

## [0.2.1] - 2021-10-18

### Changed

- Update icon

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

[Unreleased]: https://github.com/giantswarm/cloudflared-app/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/giantswarm/cloudflared-app/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/giantswarm/cloudflared-app/compare/v0.2.1...v0.3.0
[0.2.2]: https://github.com/giantswarm/cloudflared-app/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/giantswarm/cloudflared-app/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/giantswarm/cloudflared-app/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/giantswarm/cloudflared-app/compare/v0.0.5...v0.1.0
[0.0.4]: https://github.com/giantswarm/cloudflared-app/compare/v0.0.4...v0.0.5
[0.0.3]: https://github.com/giantswarm/cloudflared-app/compare/v0.0.3...v0.0.4
[0.0.2]: https://github.com/giantswarm/cloudflared-app/compare/v0.0.2...v0.0.3
[0.0.1]: https://github.com/giantswarm/cloudflared-app/compare/v0.0.1...v0.0.2
