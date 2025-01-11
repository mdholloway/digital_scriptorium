# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Representers

  RSpec.describe DsItem do
    let(:holding_json) { read_fixture('items/holding.json') }
    let(:manuscript_json) { read_fixture('items/manuscript.json') }
    let(:record_json) { read_fixture('items/record.json') }

    it 'correctly reports if it is a holding' do
      item = ItemRepresenter.new(described_class.new).from_json(holding_json)
      expect(item.holding?).to be true
    end

    it 'correctly reports if it is a manuscript' do
      item = ItemRepresenter.new(described_class.new).from_json(manuscript_json)
      expect(item.manuscript?).to be true
    end

    it 'correctly reports if it is a record' do
      item = ItemRepresenter.new(described_class.new).from_json(record_json)
      expect(item.record?).to be true
    end

    it 'returns instance_of (P16) claims' do
      item = ItemRepresenter.new(described_class.new).from_json(record_json)
      expect(item.instance_of_claims).not_to be_empty
      expect(item.instance_of_claims.first.entity_id_value).to eq 'Q3'
    end
  end
end
