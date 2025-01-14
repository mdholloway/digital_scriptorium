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

def property_config
  YAML.load_file(File.expand_path('../property_config.yml', __dir__))
end

def fixture_path(file)
  File.join(__dir__, 'fixtures', file)
end

def read_fixture(file)
  File.read(fixture_path(file))
end

def item_from_fixture(file)
  item = DigitalScriptorium::DsItem.new
  WikibaseRepresentable::Representers::ItemRepresenter.new(item).from_json(read_fixture(file))
end

def property_from_fixture(file)
  property = WikibaseRepresentable::Model::Property.new
  WikibaseRepresentable::Representers::PropertyRepresenter.new(property).from_json(read_fixture(file))
end

EXPORT_HASH = {
  'Q4' => item_from_fixture('items/Q4_holding_status_current.json'),
  'Q5' => item_from_fixture('items/Q5_holding_status_non_current.json'),
  'Q15' => item_from_fixture('items/Q15_non_dated.json'),
  'Q18' => item_from_fixture('items/Q18_author.json'),
  'Q21' => item_from_fixture('items/Q21_former_owner.json'),
  'Q33' => item_from_fixture('items/Q33_parchment.json'),
  'Q96' => item_from_fixture('items/Q96_14th_century.json'),
  'Q113' => item_from_fixture('items/Q113_latin.json'),
  'Q128' => item_from_fixture('items/Q128_provence.json'),
  'Q129' => item_from_fixture('items/Q129_spain.json'),
  'Q169' => item_from_fixture('items/Q169_cosmology.json'),
  'Q283' => item_from_fixture('items/Q283_deeds.json'),
  'Q300' => item_from_fixture('items/Q300_early_works.json'),
  'Q354' => item_from_fixture('items/Q354_almagest.json'),
  'Q374' => item_from_fixture('items/Q374_upenn.json'),
  'Q383' => item_from_fixture('items/Q383_schoenberg.json'),
  'Q394' => item_from_fixture('items/Q394_dioscorides.json'),
  'Q542' => item_from_fixture('items/Q542_holding_example.json'),
  'Q543' => item_from_fixture('items/Q543_manuscript_example.json'),
  'Q544' => item_from_fixture('items/Q544_record_example.json'),
  'Q1105' => item_from_fixture('items/Q1105_deste.json'),
  'Q1106' => item_from_fixture('items/Q1106_llangattock.json')
}.freeze

def export_hash
  EXPORT_HASH
end
