# gemgate

gemgate receives built gems and makes them available via S3.

Example use:

```bash
$ gem build foobar.gemspec #=> produces foobar-0.0.1.gem
$ curl --data-binary @foobar-0.0.1.gem https://gemgate.herokuapp.com/
$ gem sources -a https://gemgate.s3.amazonaws.com/deadbeef/
$ gem install foobar -v 0.0.1
```

## Running locally

```bash
$ cp .env.sample .env
# edit .env
$ foreman start
$ curl --data-binary @foobar-0.0.1.gem http://localhost:3000/
$ gem sources -a https://gemgate-development.s3.amazonaws.com/deadbeef/
$ gem install foobar -v 0.0.1
```

## Deployment on Heroku

```bash
$ heroku create gemgate-production -s cedar
$ heroku config:add -a gemgate \
  AWS_ACCESS_KEY_ID=... \
  AWS_SECRET_ACCESS_KEY=... \
  S3_BUCKET=...
$ git push heroku master
```

## Configuration

* `AWS_ACCESS_KEY_ID`: The AWS access key to use when communicating with S3
* `AWS_SECRET_ACCESS_KEY`: The AWS secret access key to use when communicating with S3
* `S3_BUCKET`: Name of the S3 bucket to use

It's recommended you use [IAM credentials](https://gist.github.com/34e08aaf5e5e87814c72) with bucket-specific access for S3.
