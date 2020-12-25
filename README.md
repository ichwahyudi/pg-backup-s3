![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/ichsanwahyudi/pg-backup-s3) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/ichsanwahyudi/pg-backup-s3) ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/ichsanwahyudi/pg-backup-s3) ![Docker Image Version (latest semver)](https://img.shields.io/docker/v/ichsanwahyudi/pg-backup-s3)
# pg-backup-s3

Hi Guys!

Feel free to use this script and I'm Happy to get some feedback.

## Requirements

* aws-cli
* postgresql-client (need to run `pg_dump`)

## Environment Variables

To run this script, make sure to set these enviroment variables:

```
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=
DB_USERNAME=
DB_PASSWORD=
DB_HOST=
DB_PORT=
DB_NAME=
S3_BUCKET=
```

## How to run?

To use this script is simple. Just make sure environment variables above already set. 

And then you can directly execute it with:
```
./pg_backup.sh
```

OR, you can run as docker container, put the environment variables above inside file `env.list` and then pull and run the docker image:
```
docker run --env-file env.list ichsanwahyudi/pg-backup-s3
```

OR, you can run as Kubernetes Cronjob like this:
```
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: postgres-backup
  labels:
    app: postgres-backup
data:
  AWS_ACCESS_KEY_ID: ''
  AWS_SECRET_ACCESS_KEY: ''
  AWS_DEFAULT_REGION: ''
  DB_USERNAME: ''
  DB_PASSWORD: ''
  DB_HOST: ''
  DB_PORT: ''
  DB_NAME: ''
  S3_BUCKET: ''

---
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  annotations:
    reloader.stakater.com/auto: "true"
  labels:
    app: postgres-backup
  name: postgres-backup
spec:
  concurrencyPolicy: Forbid
  failedJobsHistoryLimit: 1
  jobTemplate:
    metadata:
      labels:
        app: postgres-backup
    spec:
      template:
        metadata:
          labels:
            app: postgres-backup
            type: job
        spec:
          containers:
          - name: postgres-backup
            image: ichsanwahyudi/pg-backup-s3:latest
            imagePullPolicy: Always
            envFrom:
              - configMapRef:
                  name: postgres-backup
            resources:
              limits:
                cpu: 100m
                memory: 200Mi
              requests:
                cpu: 5m
                memory: 10Mi
            workingDir: /app
          restartPolicy: Never
  schedule: 00 00 * * *
  successfulJobsHistoryLimit: 1
```