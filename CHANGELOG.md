# GitLab CodeQuality changelog

GitLab CodeQuality follows versioning of GitLab (`MAJOR.MINOR` only) and generates a `MAJOR-MINOR-stable` [Docker image](https://gitlab.com/gitlab-org/security-products/codequality/container_registry).

These "stable" Docker images may be updated after release date, changes are added to the corresponding section bellow.

## 11-0-stable
- Upgrade Code Climate to 0.72.0
- **Breaking Change:** rename report file from `codeclimate.json` to `gl-code-quality-report.json`

## 10-8-stable
- Update to Code Climate 0.71.2
- Add optional variable(`TIMEOUT_SECONDS`) to allow user to give a custom timeout for the `codeclimate analyze` command

## 10-7-stable
- Fix code climate issue type filter
- Check all supported config files before copying defaults

## 10-6-stable
- Initial release

## 10-5-stable
- **Backport:** Initial release

## 10-4-stable
- **Backport:** Initial release
