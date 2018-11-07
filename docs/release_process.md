# GitLab Security Products release process

GitLab Security Products follow the versioning of GitLab (`MAJOR.MINOR` only) and are available as Docker images tagged with `MAJOR-MINOR-stable`, also known as `SP_VERSION`.

E.g. For GitLab `10.5.x` you'll need to run the `10-5-stable` GitLab Code Quality image:

    registry.gitlab.com/gitlab-org/security-products/codequality:10-5-stable

This ensures GitLab Security Products stays compatible with the GitLab instance it runs on and generates the expected report while allowing flexibility to provide patches without having to upgrade the whole GitLab project.

Please note that the Auto-DevOps feature automatically uses the correct version. If you have your own `.gitlab-ci.yml` in your project, please ensure you are up-to-date with the [Auto-DevOps template](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/lib/gitlab/ci/templates/Auto-DevOps.gitlab-ci.yml).

## codequality

Release Managers ensure that the latest version of codequality (like codequality
v1) is published as a Docker image tagged with `MAJOR-MINOR-stable`
to make it compatible with the `codequality` job definition.
They then perform Q&A on the latest release of GitLab.

### On 7th of the month (working day, prior to 23:59 pacific):

> 7th of the month is the date of the feature freeze and the first RC of GitLab is created on the 8th. When the GitLab `X.Y.0-RC1` is deployed for QA on the 8th, the CI server looks for the matching `X-Y-stable` Docker image of GitLab Security Products.

* Make sure there's a Docker image with tag `X-Y-stable`.
  The CI generates the `X-Y-stable` images only if the manual job `build major` is triggered and succeeds.
* create the Release issue
    * complete changelog/documentation with missing entries for `X-Y-stable`
    * create the `X-Y-stable` branch from `master`.
    * bump version number to next release (`X.Y+1`) in the `VERSION` file.
    * add the corresponding `CHANGELOG` section to ease upcoming Merge Requests.
    * push the branch `X-Y-stable` to remote, this generates the `X-Y-stable` Docker image.
* create the QA issue

### After the 7th and until next month:

To submit a feature for next release (`X.Y+1`):
  - start working from the `master` branch and open an MR against `master`
  - update the changelog for next release `X-Y+1-stable`
  - merge the feature branch into `master`. Nothing is published yet, it will be on the next release (`X.Y+1`)

To submit a feature or bugfix for current or previous releases:
  - if feature or bug also affects the next release (`X.Y+1`):
    - start working from the `master` branch and open an MR against `master`
    - update the changelog for release `X-Y+1-stable`
    - assign the MR to the `X.Y+1` milestone
    - assign one `Pick into MAJOR.MINOR` label per release where the merge request should be backported to.
    - merge the feature branch into `master`.
    - backport the bugfix into each `MAJOR-MINOR-stable` branch corresponding to the `Pick into MAJOR.MINOR` labels assigned:
      - create a branch `backport-MAJOR-MINOR-awesome_fix_or_feature` from `MAJOR-MINOR-stable`
      - cherry-pick the feature/fix commit(s) and adapt to this stable branch
      - update changelog of `MAJOR-MINOR-stable` with: `**Backport:** Awesome feature` and discard the other changelog update that may come with the cherry-pick.
      - open an MR against `MAJOR-MINOR-stable`
      - assign the MR to the `MAJOR.MINOR` milestone
      - merge the MR into the `MAJOR-MINOR-stable` release branche. This will automatically generate a new Docker image
      that is released immediately by overriding the corresponding `MAJOR-MINOR-stable` image tag.
    - remove each label once picked into their respective stable branches

  - if feature or bug does not affect the next release (`X.Y+1`):
    - start working from the most recent `X-Y-stable` branch that is affected and open an MR against this branch
    - update the changelog for release `X-Y-stable`
    - assign the MR to the `X.Y` milestone
    - assign one `Pick into MAJOR.MINOR` label per release where the merge request should be backported to.
    - merge the feature branch into `X-Y-stable` branch. This generates a new Docker image that is released immediately by overriding the corresponding `X-Y-stable` image tag.
    - backport the bugfix into each `MAJOR-MINOR-stable` branch corresponding to the `Pick into MAJOR.MINOR` labels assigned:
      - create a branch `backport-MAJOR-MINOR-awesome_fix_or_feature` from `MAJOR-MINOR-stable`
      - cherry-pick the feature/fix commit(s) and adapt to this stable branch
      - update changelog of `MAJOR-MINOR-stable` with: `**Backport:** Awesome feature` and discard the other changelog update that may come with the cherry-pick.
      - open an MR against `MAJOR-MINOR-stable`
      - assign the MR to the `MAJOR.MINOR` milestone
      - merge the MR into the `MAJOR-MINOR-stable` release branche. This will automatically generate a new Docker image
      that is released immediately by overriding the corresponding `MAJOR-MINOR-stable` image tag.
    - remove each label once picked into their respective stable branches
