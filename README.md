# F(x) Sqlserver Adapter

A Sqlserver adapter for the [fx](https://github.com/teoljungberg/fx) gem

## Features

This adapter makes possible to use sqlserver database functions/procedures _(under functions)_ and triggers with active record migrations and schema dump for them.

## Installation

Add this line your gemfile

```ruby
gem 'fx'
gem 'fx-sqlserver-adapter'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fx-sqlserver-adapter

## Usage

After that you will need to tell F(x) to use this adapter in an initializer `config/initializer/fx.rb`:

```ruby
# frozen_string_literal: true

require 'fx/adapters/sqlserver'
if defined?(Fx)
  Fx.configuration.database = Fx::Adapters::Sqlserver.new
end
```

The generators for this gem still uses generators from the original [fx](https://github.com/teoljungberg/fx#great-how-do-i-create-a-trigger-and-a-function) gem.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tarellel/fx-sqlserver-adapter.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org/) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
