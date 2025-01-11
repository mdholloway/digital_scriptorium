# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Model
  include WikibaseRepresentable::Representers

  RSpec.describe Export do
    let(:holding) { item_from_fixture('items/holding.json') }
    let(:manuscript) { item_from_fixture('items/manuscript.json') }
    let(:record) { item_from_fixture('items/record.json') }
    let(:property) { property_from_fixture('properties/instance_of.json') }

    it 'transforms a Wikibase export to a Hash' do
      export = described_class.new
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
