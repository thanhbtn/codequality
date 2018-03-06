# GitLab CodeQuality

[![pipeline status](https://gitlab.com/gitlab-org/security-products/codequality/badges/master/pipeline.svg)](https://gitlab.com/gitlab-org/security-products/codequality/commits/master)
[![coverage report](https://gitlab.com/gitlab-org/security-products/codequality/badges/master/coverage.svg)](https://gitlab.com/gitlab-org/security-products/codequality/commits/master)

GitLab tool for running codequality checks on provided source code.
It is currently based on CodeClimate only, but this may change in the future.

## How to use

1. `cd` into the directory of the source code you want to scan
1. Run the Docker image:

    ```sh
    docker run \
      --interactive --tty --rm \
      --env CODECLIMATE_CODE="$PWD" \
      --volume "$PWD":/code \
      --volume /var/run/docker.sock:/var/run/docker.sock \
      --volume /tmp/cc:/tmp/cc \
      registry.gitlab.com/gitlab-org/security-products/codequality/codeclimate:${VERSION:-latest} analyze -f json
    ```
    `VERSION` can be replaced with the latest available release matching your GitLab version. See [Versioning](#versioning-and-release-cycle) for more details.

**Why mounting the Docker socket?**

Some tools require to be able to launch Docker containers to scan your application. You can skip this but you won't benefit from all scanners.

## Versioning and release cycle

GitLab CodeQuality follows the versioning of GitLab (`MAJOR.MINOR` only) and is available as a Docker image tagged with `MAJOR-MINOR-stable`.

E.g. For GitLab `10.5.x` you'll need to run the `10-5-stable` GitLab CodeQuality image:

    registry.gitlab.com/gitlab-org/security-products/codequality/codeclimate:10-5-stable

Please note that the Auto-DevOps feature automatically uses the correct version. If you have your own `.gitlab-ci.yml` in your project, please ensure you are up-to-date with the [Auto-DevOps template](https://gitlab.com/gitlab-org/gitlab-ci-yml/blob/master/Auto-DevOps.gitlab-ci.yml).

# Contributing

If you want to help and extend the list of supported scanners, read the
[contribution guidelines](CONTRIBUTING.md).
