# ErrorReporter
Simple Error reporting for WellTravel internal apps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'error-reporter', git: 'git@github.com:wtag/error-reporter'
```

And then execute:

    $ bundle

## Configuration
You can configure both `logger` and external/internal `reporters`.
```ruby
ErrorReporter.logger = Rails.logger
ErrorReporter.reporters = [Rollbar, Skylight]
```

## Usage
#### Report a error
```ruby
begin
  fail 'Boom'
rescue => error
  ErrorReporter.call(error)
end
```

#### Report a critical/fatal error
```ruby
begin
  fail 'Boom'
rescue => error
  ErrorReporter.fatal(error)
  ErrorReporter.critical(error)
end
```

#### Report a warning
```ruby
begin
  fail 'Boom'
rescue => error
  ErrorReporter.warn(error)
end
```

#### Log a info message
```ruby
ErrorReporter.info('This happened!')
```

#### Log a debug message
```ruby
ErrorReporter.info('This happened!')
```

#### You can also add extra meta data
```ruby
ErrorReporter.error(error, extra: :meta)
ErrorReporter.info('This happened!', meta: :data)
```
