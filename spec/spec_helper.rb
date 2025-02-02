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

def fixture_path(file)
  File.join(__dir__, 'fixtures', file)
end

def read_fixture(file)
  File.read(fixture_path(file))
end

def build_claim(json)
  statement = WikibaseRepresentable::Model::Statement.new
  WikibaseRepresentable::Representers::StatementRepresenter.new(statement).from_json(json)
end

def item_from_fixture(file)
  item = WikibaseRepresentable::Model::Item.new
  WikibaseRepresentable::Representers::ItemRepresenter.new(item).from_json(read_fixture(file))
end

def property_from_fixture(file)
  property = WikibaseRepresentable::Model::Property.new
  WikibaseRepresentable::Representers::PropertyRepresenter.new(property).from_json(read_fixture(file))
end

# Return a fixture export hash for all item and property JSON files in
# +fixtures/items+ and +fixtures/properties+. Returned fixture has Manuscript,
# Holding, and Record items, as well as corresponding Items for authority
# values: term, name, place, material, etc.
#
# @return [Hash]
def export_hash
  @export_hash ||= begin
    fixtures = []
    %w[items properties].each do |fixture_folder|
      fixtures << Dir[File.join(__dir__, 'fixtures', fixture_folder, '*.json')].map do |file|
        File.read(file)
      end
    end
    export_json = "[#{fixtures.join(',')}]"
    DigitalScriptorium::ExportRepresenter.new(DigitalScriptorium::Export.new).from_json(export_json).to_hash
  end
end
