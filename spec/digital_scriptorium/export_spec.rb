# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Model
  include WikibaseRepresentable::Representers

  RSpec.describe Export do
    let(:holding_json) { File.read(File.expand_path('../fixtures/items/holding.json', __dir__)) }
    let(:manuscript_json) { File.read(File.expand_path('../fixtures/items/manuscript.json', __dir__)) }
    let(:record_json) { File.read(File.expand_path('../fixtures/items/record.json', __dir__)) }
    let(:property_json) { File.read(File.expand_path('../fixtures/properties/instance_of.json', __dir__)) }

    it 'transforms a Wikibase export to a Hash' do
      export = described_class.new
      holding = ItemRepresenter.new(DsItem.new).from_json(holding_json)
      manuscript = ItemRepresenter.new(DsItem.new).from_json(manuscript_json)
      record = ItemRepresenter.new(DsItem.new).from_json(record_json)
      property = PropertyRepresenter.new(Property.new).from_json(property_json)
      export << holding << manuscript << record << property

      expected = {
        'Q542' => holding,
        'Q543' => manuscript,
        'Q544' => record,
        'P16' => property
      }
      expect(export.to_hash).to eq(expected)
    end
  end
end
