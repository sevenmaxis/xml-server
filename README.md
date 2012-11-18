# Svitla

xml server

## Installation

Add this line to your application's Gemfile:

    gem 'svitla'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install svitla

## Usage

Get json device

    curl http://localhost:9292/device

Post json device

    curl -X POST -d '{"device":{"username":"123456","name":"some name","location":"Hidden"}}' http://localhost:9292/device
