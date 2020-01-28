### Summary

Release docker image for version `(specify version)`

<!-- Add more details as necessary. -->

### Tasks

- [ ] Push a branch based off of `master` and name it after the version to be released (e.g `0.85.6` or `0.85.6-gitlab.1`). Refer to [the changelog](CHANGELOG.md) for the latest version to release. This should then trigger the `release-version` CI job to run.
- [ ] Once the docker image is released, open an MR to bump the version in the [Code Quality vendored template](https://gitlab.com/gitlab-org/gitlab/blob/master/lib/gitlab/ci/templates/Jobs/Code-Quality.gitlab-ci.yml#L10) and [reports.gitlab-ci.yml](https://gitlab.com/gitlab-org/gitlab/blob/master/.gitlab/ci/reports.gitlab-ci.yml#L23). Here's a [example](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/22659).

/label ~release
