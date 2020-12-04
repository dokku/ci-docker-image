# ci-docker-image

A Docker image meant for use with CI/CD pipelines

## Building

```
docker build dokku/ci-docker-image .
```

## Configuration

The following environment variables are supported:

- `BRANCH`:
    description: The branch to deploy when pushing to Dokku
    required: false
    default: "master"
- `command`:
    description: The command to run for the action
    required: false
    default: 'deploy'
- `GIT_PUSH_FLAGS:`
    description: The dokku app's git repository url (in SSH format)
    required: true
- `GIT_REMOTE_URL:`
    description: A string containing a set of flags to set on push
    required: false
- `REVIEW_APP_NAME`:
    description: The name of the review app to create or destroy
    required: false
    default: ''
- `SSH_HOST_KEY`:
    description: The results of running `ssh-keyscan -t rsa $HOST`
    required: false
    default: ""
- `SSH_PRIVATE_KEY`:
    description: A private SSH key that has push acces to your Dokku instance
    required: true

## Usage

This image provides two binaries for external usage:

- `dokku-deploy`: Triggers an app deploy at the configured `GIT_REMOTE_URL`
- `dokku-unlock`: Unlocks deploys for an app at the configured `GIT_REMOTE_URL`
