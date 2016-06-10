# Hijack

[![Join the chat at https://gitter.im/nicb/hijack](https://badges.gitter.im/nicb/hijack.svg)](https://gitter.im/nicb/hijack?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build Status](https://travis-ci.org/nicb/hijack.svg?branch=master)](https://travis-ci.org/nicb/hijack)
[![Code Climate](https://codeclimate.com/github/nicb/hijack/badges/gpa.svg)](https://codeclimate.com/github/nicb/hijack)
[![Test Coverage](https://codeclimate.com/github/nicb/hijack/badges/coverage.svg)](https://codeclimate.com/github/nicb/hijack/coverage)
[![Issue Count](https://codeclimate.com/github/nicb/hijack/badges/issue_count.svg)](https://codeclimate.com/github/nicb/hijack)
[![Inline docs](http://inch-ci.org/github/nicb/hijack.svg?branch=master)](http://inch-ci.org/github/nicb/hijack)

Dynamic website hijacking software

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hijack'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hijack

## Usage

1. set your configuration in `config/configuration.rb`
2. run it with `rake hijack`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hijack.
