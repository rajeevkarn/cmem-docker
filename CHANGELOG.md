# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/).

## [Unreleased]

### Added
- dockerfiles for the `DataPlatform`, `DataIntegration` and `DataManager`
- kubernetes deployment templates

### Changed

- default link for data artifact download

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
