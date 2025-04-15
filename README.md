# ci-docker-image

[![dokku/ci-docker-image](http://dockeri.co/image/dokku/ci-docker-image)](https://registry.hub.docker.com/r/dokku/ci-docker-image)

A Docker image meant for use with CI/CD pipelines

## Supported CI Systems

Assuming a Docker image can be run as a CI task with environment variables
injected, the following CI systems will have their variables automatically
detected:

- [circleci](https://circleci.com/)
- [cloudbees](https://www.cloudbees.com/)
- [drone](https://www.drone.io/)
- [github actions](https://github.com/features/actions)
- [gitlab-ci](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/)
- [semaphoreci](https://semaphoreci.com/)
- [travisci](https://travis-ci.com/)
- [woodpecker ci](https://woodpecker-ci.org/)

## Usage

This image provides two binaries for external usage:

- `dokku-deploy`: Triggers an app deploy at the configured `GIT_REMOTE_URL`
- `dokku-unlock`: Unlocks deploys for an app at the configured `GIT_REMOTE_URL`

To run either binary, the following `docker` command can be used from a
directory containing a non-shallow clone of the repository being deployed:

```shell
# where the `.env` file contains `GIT_REMOTE_URL` and `SSH_PRIVATE_KEY`

# deploy
docker run --rm -v="$PWD:/app" --env-file=.env dokku/ci-docker-image dokku-deploy

# unlock
docker run --rm -v="$PWD:/app" --env-file=.env dokku/ci-docker-image dokku-unlock
```

### Configuration

The following environment variables are supported:

- `BRANCH`:
  - description: The branch to deploy when pushing to Dokku
  - required: false
  - default: ''master
- `CI_BRANCH_NAME`
  - description: The branch name that triggered the deploy. Interpolated if unavailable.
  - required: false
  - default: ''
- `CI_COMMIT`
  - description: The commit sha that will be pushed. Interpolated if unavailable.
  - required: false
  - default: ''
- `COMMAND`:
  - description: The command to run for the action
  - required: false
  - default: ''
- `DEPLOY_DOCKER_IMAGE`:
  - description: A docker image to deploy via `git:from-image`
  - required: false
  - default: ''
- `DEPLOY_USER_NAME`:
  - description: A username to use when deploying a docker image
  - required: false
  - default: ''
- `DEPLOY_USER_EMAIL`:
  - description: The email to use when deploying a docker image
  - required: false
  - default: ''
- `GIT_REMOTE_URL:`
  - description: The dokku app's git repository url (in SSH format, see below)
  - required: true
- `GIT_PUSH_FLAGS:`
  - description: A string containing a set of flags to set on push
  - required: false
- `REVIEW_APP_NAME`:
  - description: The name of the review app to create or destroy
  - required: false
  - default: 'review-$APP_NAME-$CI_BRANCH_NAME'
- `SSH_HOST_KEY`:
  - description: The results of running `ssh-keyscan -t rsa $HOST`
  - required: false
  - default: ''
- `SSH_PRIVATE_KEY`:
  - description: A private SSH key that has push acces to your Dokku instance
  - required: true
- `SSH_PASSPHRASE`:
  - description: If set, the passphrase to use when interacting with an SSH key that has a passphrase
  - required: false
  - default: ''
- `TRACE`:
  - description: Allows users to debug what the action is performing by enabling shell trace mode
  - required: false
  - default: ''

### `GIT_REMOTE_URL` SSH Format

The `GIT_REMOTE_URL` value should be specified in SSH Format, as shown below:

```shell
# without port specified
ssh://dokku@dokku.me/node-js-app

# with the optional port specified
ssh://dokku@dokku.me:22/node-js-app

# generalized form
ssh://dokku@HOSTNAME:PORT/APP_NAME
```

This format mimics the DSN format. It is similar to the one in use by a normal `git push dokku main` command, though with a change on how the app name is separated by a slash from the rest of the hostname. The port is completely optional, but allows users to rebind the SSH server to another port as necessary.

> [!IMPORTANT]
> The SSH key _must_ be added to the dokku user via the `dokku ssh-keys:add` command and _not_ manually or the app name will not be properly detected.

### Hooks

This image allows a variety of file-based hooks to be triggered during the app
deploy process. These hooks should be executables relative to the current working
directory in which `dokku-deploy` script is executed - typically your repository root.

The following environment variables are available for usage in the script:

- `APP_NAME`: The name of the remote app that will be deployed. This takes
the parsed GIT_REMOTE_URL and REVIEW_APP_NAME into account.
- `IS_REVIEW_APP`: `true` if a review app is being deployed, `false` otherwise.
- `SSH_REMOTE`: The parsed ssh remote url.

The simplest hook is a shell script like so:

```shell
#!/bin/sh -l

echo "hello world"
```

> [!NOTE]
> The Docker image in use by this repository currently only supports `sh` as
> the interpreter. If another interpreter is desired, it should be added to the
> environment manually.

To execute remote dokku commands, the `ssh` binary can be executed like so:

```shell
#!/bin/sh -l

ssh "$SSH_REMOTE" -- version
```

Additionally, if a Dokku command should be executed _only_ for review apps,
the `IS_REVIEW_APP` variable can be checked for the value `true` to wrap
review app-specific logic:

```shell
#!/bin/sh -l
if [ "$IS_REVIEW_APP" = "true" ]; then
  ssh "$SSH_REMOTE" -- config:set "$APP_NAME" "DOMAIN=$APP_NAME.dokku.me"
  echo "configured the review app domain"
fi
```

The following hooks are available:

- `bin/ci-pre-deploy`: Triggered after any app setup but before the app is deployed
- `bin/ci-post-deploy`: Triggered after the app is deployed
- `bin/ci-pre-review-app-destroy`: Triggered before a review app is destroyed
- `bin/ci-post-review-app-destroy`: Triggered after a review app is destroyed

## Building

```text
docker build dokku/ci-docker-image .
```
