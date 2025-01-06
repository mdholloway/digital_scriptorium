# DigitalScriptorium

This gem provides code to support the transformation of Digital Scriptorium Wikibase data exports into Apache Solr documents that can be searched using [DS Catalog](https://search.digital-scriptorium.org/).

See [here](doc/overview.md) for a technical overview of the logic for transforming Wikibase items in the export to Solr records.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add digital_scriptorium
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install digital_scriptorium
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mdholloway/digital_scriptorium.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
