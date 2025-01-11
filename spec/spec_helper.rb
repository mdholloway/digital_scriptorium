# frozen_string_literal: true

require 'digital_scriptorium'
require 'wikibase_representable'
require 'yaml'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def config
  YAML.load_file(File.expand_path('../property_config.yml', __dir__))
end

def fixture_path(file)
  File.join(__dir__, 'fixtures', file)
end

def read_fixture(file)
  File.read(fixture_path(file))
end

def item_from_fixture(file)
  item = WikibaseRepresentable::Model::Item.new
  WikibaseRepresentable::Representers::ItemRepresenter.new(item).from_json(read_fixture(file))
end

def property_from_fixture(file)
  property = WikibaseRepresentable::Model::Property.new
  WikibaseRepresentable::Representers::PropertyRepresenter.new(property).from_json(read_fixture(file))
end

EXPORT_HASH = {
  'Q4' => item_from_fixture('items/current.json'),
  'Q18' => item_from_fixture('items/author.json'),
  'Q21' => item_from_fixture('items/former_owner.json'),
  'Q33' => item_from_fixture('items/parchment.json'),
  'Q96' => item_from_fixture('items/14c.json'),
  'Q113' => item_from_fixture('items/latin.json'),
  'Q128' => item_from_fixture('items/provence.json'),
  'Q129' => item_from_fixture('items/spain.json'),
  'Q283' => item_from_fixture('items/deeds.json'),
  'Q354' => item_from_fixture('items/almagest.json'),
  'Q374' => item_from_fixture('items/penn.json'),
  'Q383' => item_from_fixture('items/schoenberg.json'),
  'Q394' => item_from_fixture('items/dioscorides.json'),
  'Q1105' => item_from_fixture('items/deste.json'),
  'Q1106' => item_from_fixture('items/llangattock.json')
}.freeze

def export_hash
  EXPORT_HASH
end
