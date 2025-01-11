# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Model
  include WikibaseRepresentable::Representers

  RSpec.describe Export do
    let(:holding) { ItemRepresenter.new(DsItem.new).from_json(read_fixture('items/holding.json')) }
    let(:manuscript) { ItemRepresenter.new(DsItem.new).from_json(read_fixture('items/manuscript.json')) }
    let(:record) { ItemRepresenter.new(DsItem.new).from_json(read_fixture('items/record.json')) }
    let(:property) { PropertyRepresenter.new(Property.new).from_json(read_fixture('properties/instance_of.json')) }

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
