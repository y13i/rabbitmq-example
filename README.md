# rabbitmq-example

## Quick Usage

Install and run RabbitMQ.

```
$ brew install rabbitmq
$ rabbitmq-server
```

Install bundle.

```
$ bundle install --path vendor/bundle
```

Create dummy user data.

```
$ bundle exec rake db:create
$ bundle exec rake db:seed
```

Run publisher.

```
$ bundle exec rake publisher
```

Run subscriber.

```
$ bundle exec rake subscriber
```

## Environmental Variables

- `USER_ID`: ID of the user to use
- `USER_COUNT`: Maximum count of users (Default: `100`)
- `COMPANY_COUNT`: Maximum count of companies (Default: `10`)
- `STATE_COUNT`: Maximum count of states (Default: `10`)
- `RABBITMQ_USER`: Username of RabbitMQ (Default: `guest`)
- `RABBITMQ_PASSWORD`: Password of RabbitMQ (Default: `guest`)
- `RABBITMQ_HOST`: Hostname of RabbitMQ (Default: `localhost`)
- `RABBITMQ_PORT`: Port number of RabbitMQ (Default: `5672`)
- `MIN_INTERVAL`: Minimum interval between publishes (Default: `5`)
- `MAX_INTERVAL`: Maximum interval between publishes (Default: `20`)
