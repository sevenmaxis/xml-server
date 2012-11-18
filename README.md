# Svitla

xml server

## Installation

Run in command line:

    git clone git@github.com:sevenmaxis/xml-server.git

And then execute:

    $ bundle install

Run rack application as:

    rackup -Ilib

## Usage

Get json device

    curl http://localhost:9292/device

Post json device

    curl -X POST -d '{"device":{"username":"123456","name":"some name","location":"Hidden"}}' http://localhost:9292/device
