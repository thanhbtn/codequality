# GitLab Code Quality

[![pipeline status](https://gitlab.com/gitlab-org/security-products/codequality/badges/master/pipeline.svg)](https://gitlab.com/gitlab-org/security-products/codequality/commits/master)
[![coverage report](https://gitlab.com/gitlab-org/security-products/codequality/badges/master/coverage.svg)](https://gitlab.com/gitlab-org/security-products/codequality/commits/master)

GitLab tool for running Code Quality checks on provided source code.
It is currently based on CodeClimate only, but this may change in the future.

## How to use

1. `cd` into the directory of the source code you want to scan
1. Run the Docker image:

    ```sh
    docker run \
      --env SOURCE_CODE="$PWD" \
      --volume "$PWD":/code \
      --volume /var/run/docker.sock:/var/run/docker.sock \
      registry.gitlab.com/gitlab-org/security-products/codequality:${VERSION:-latest} /code
    ```
    `VERSION` can be replaced with the latest available release matching your GitLab version. See [Versioning](#versioning-and-release-cycle) for more details.

1. The results will be stored in the `codeclimate.json` file in the application directory.

**Why mounting the Docker socket?**

Some tools require to be able to launch Docker containers to scan your application.

### Environment variables

Code Quality can be configured with environment variables, here is a list:

| Name              | Function                                             |
|-------------------|------------------------------------------------------|
| SOURCE_CODE       | Path to the source code to scan                      |
| TIMEOUT_SECONDS   | Custom timeout for the `codeclimate analyze` command |
| CODECLIMATE_DEBUG | Set to enable [Code Climate debug mode](https://github.com/codeclimate/codeclimate#environment-variables) |
| CODECLIMATE_DEV   | Set to enable `--dev` mode which lets you run engines not known to the CLI. |

### Configuration

GitLab Code Quality comes with some default engines enabled and [default configurations](./codeclimate_defaults) but we encourage you to customize them to your own needs.
Please refer to [CodeClimate documentation](https://docs.codeclimate.com/docs/configuring-your-analysis) to learn more.

## Versioning and release cycle

GitLab CodeQuality follows the versioning of GitLab (`MAJOR.MINOR` only) and is available as a Docker image tagged with `MAJOR-MINOR-stable`.

E.g. For GitLab `10.5.x` you'll need to run the `10-5-stable` GitLab CodeQuality image:

    registry.gitlab.com/gitlab-org/security-products/codequality:10-5-stable

Please note that the Auto-DevOps feature automatically uses the correct version. If you have your own `.gitlab-ci.yml` in your project, please ensure you are up-to-date with the [Auto-DevOps template](https://gitlab.com/gitlab-org/gitlab-ci-yml/blob/master/Auto-DevOps.gitlab-ci.yml).

# Contributing

If you want to help and extend the list of supported scanners, read the
[contribution guidelines](CONTRIBUTING.md).
