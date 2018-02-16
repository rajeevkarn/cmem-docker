# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/).

## [Unreleased]

### Fixed

- `cmem` image tag

## [2.3.2] 2018-02-16

### Changed

- Compose file format `2` to `3` due to health check feature

### Fixed

- `cmem` container startup fails if initial data artifacts are missing
- DataPlatform health check no longer blocks forever

## [2.3.1] 2017-12-14

### Changed

- Forward used versions of Corporate Memory to
    - `DataIntegration@4.2.0`
    - `DataPlatform@9.3.0`

### Fixed

- DataPlatform Tomcat deployment
- Memory settings
- Docker image tags
- Import no longer requires anonymous access

## [2.3.0] 2017-11-30

### Fixed

- Tomcat startup error

## [2.2.0] 2017-10-10

### Changed

- Forward used versions of Corporate Memory to
    - `DataIntegration@4.1.0`
    - `DataManager@4.1.2`
    - `DataPlatform@9.2.0`

## [2.1.1] 2017-09-22

### Removed

- unused file

## [2.1.0] 2017-09-19

### Added

- Separate Dockerfiles for the `DataPlatform`, `DataIntegration` and `DataManager` are now available in the apropriate directories
- Sample Kubernetes deployment templates have been added

### Changed

- Updated links for data artifact downloads

### Fixed

- Importer now imports sample data correctly

## [2.0.0] 2017-05-29

### Added

- Provide initial data and import scripts

### Changed

- Improved READMEs
- Forward used versions of Corporate Memory to
    - `DataIntegration@3.4.0`
    - `DataManager@4.0.1`
    - `DataPlatform@8.0.2`

## [1.0.0] 2017-03-28

### Added

- Add option to choose between stardog and virtuoso by using different docker compose files for each environment
- Add build script and instructions for stardog, as we currently cannot provide the artifacts due to licensing

### Changed

- Improved README
- Forward used versions of Corporate Memory to
    - `DataIntegration@3.3.2`
    - `DataManager@3.5.3`
    - `DataPlatform@7.0.3`
