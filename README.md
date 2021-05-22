# ci-docker-image

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

## Configuration

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
  - default: 'deploy'
- `GIT_PUSH_FLAGS:`
  - description: The dokku app's git repository url (in SSH format)
  - required: true
- `GIT_REMOTE_URL:`
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

## Building

```text
docker build dokku/ci-docker-image .
```



## Examples

Where `DOKKU_SERVER_IP` is the URL or IP Address of the host running dokku.
and `DOKKU_APP_NAME` is the app which has been created on dokku.

### Basic Deploy using the Git Repository of the CI
Using Gitlab-CI:
```yaml
deploy:
  stage: deploy
  image: dokku/ci-docker-image
  variables:
    GIT_DEPTH: 0
    GIT_REMOTE_URL: ssh://dokku@${DOKKU_SERVER_IP}:22/${DOKKU_APP_NAME}
  script:
    - dokku-deploy
  after_script:
    - dokku-unlock
```


### Deploying an Existing Docker Image
To deploy an existing docker image rather than the git repository. For instance, if the docker image is built in a previous step of the pipeline.

Replace `existing/docker-image:$VERSION` with your own docker image and tag. 

Using Gitlab-CI:
```yaml
deploy:
  stage: deploy
  image: dokku/ci-docker-image
  variables:
    GIT_STRATEGY: none
    GIT_REMOTE_URL: ssh://dokku@${DOKKU_SERVER_IP}:22/${DOKKU_APP_NAME}
    COMMAND: git:from-image
  before_script:
    # version as artifact from previous pipeline step
    - export VERSION=$(cat ./version)  
    # must use specific version deploying latest on top of latest will not trigger a deploy
    - export IMAGE_NAME=existing/docker-image:$VERSION 
  script:
    - dokku-deploy
  after_script:
    - dokku-unlock

```

