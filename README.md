# Pronghorn

_Minimal HTTP server for Rack applications_

## Description

Pronghorn is a minimal and fast HTTP server for Rack applications.

It's powered by [EventMachine](https://github.com/eventmachine/eventmachine), Ryan Dahl's [http-parser](https://github.com/joyent/http-parser) and [Rack](https://github.com/rack/rack). It's highly inspired in [Thin](https://github.com/macournoyer/thin)

## Installation

    $ gem install pronghorn


## Usage

### Rails 

Add Pronghorn to your Gemfile:

```ruby
gem "pronghorn"
```

Run your application with the Pronghorn server:

    rails s pronghorn

### Sinatra

Configure Sinatra to use Pronghorn server:

```ruby
configure { set :server, :pronghorn }
```

### Rack

Run rackup using pronghorn server:

    $ rackup -s pronghorn
 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Copyright

Copyright (c) 2012 Guillermo Iguaran. See LICENSE for further details.
