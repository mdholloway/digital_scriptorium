# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Representers

  RSpec.describe DsItem do
    let(:holding_json) do
      '{"id":"Q102","claims":{"P16":[{"mainsnak":{"datavalue":{"value":{"id":"Q2"},"type":"wikibase-entityid"}}}],"P1":[{"mainsnak":{"datavalue":{"value":"DS 1","type":"string"}}}]}}'
    end
    let(:manuscript_json) do
      '{"id":"Q101","claims":{"P16":[{"mainsnak":{"datavalue":{"value":{"id":"Q1"},"type":"wikibase-entityid"}}}],"P2":[{"mainsnak":{"datavalue":{"value":{"id":"Q102"},"type":"wikibase-entityid"}}}]}}'
    end
    let(:record_json) do
      '{"id":"Q103","claims":{"P16":[{"mainsnak":{"datavalue":{"value":{"id":"Q3"},"type":"wikibase-entityid"}}}],"P3":[{"mainsnak":{"datavalue":{"value":{"id":"Q101"},"type":"wikibase-entityid"}}}]}}'
    end

    it 'correctly reports if it is a holding' do
      item = ItemRepresenter.new(described_class.new).from_json(holding_json)
      expect(item.holding?).to be true
      expect(item.manuscript?).to be false
      expect(item.record?).to be false
    end

    it 'correctly reports if it is a manuscript' do
      item = ItemRepresenter.new(described_class.new).from_json(manuscript_json)
      expect(item.holding?).to be false
      expect(item.manuscript?).to be true
      expect(item.record?).to be false
    end

    it 'correctly reports if it is a record' do
      item = ItemRepresenter.new(described_class.new).from_json(record_json)
      expect(item.holding?).to be false
      expect(item.manuscript?).to be false
      expect(item.record?).to be true
    end

    it 'returns instance_of (P16) claims' do
      item = ItemRepresenter.new(described_class.new).from_json(record_json)
      expect(item.instance_of_claims).not_to be_empty
      expect(item.instance_of_claims.first.entity_id_value).to eq 'Q3'
    end
  end
end
