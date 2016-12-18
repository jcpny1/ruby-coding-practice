# classifieds-cli-app

Display classified ads from the current online edition of Newsday.com and BoatTrader.com.
This gem was created to meet the requirements of the learn.co CLI Data Gem Project.

  0.1.1  Initial release.
  0.1.2  Improved column display formatting.
  0.1.3  Improved use of Nokogiri methods.
  0.1.4  Fix scrape bug introduced in 0.1.3.
         Display invalid input message if user enters item number 0.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'classifieds-cli-app'
```

And then execute:

  `$ bundle`

Or install it yourself as:

  `$ gem install classifieds-cli-app`

## Usage

  `$ classifieds`

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jcpny1/classifieds-cli-app. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
