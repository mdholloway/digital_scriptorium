# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Representers

  RSpec.describe DsMeta do
    let(:holding_json) do
      '{"id":"Q102","claims":{"P16":[{"mainsnak":{"datavalue":{"value":{"id":"Q2"},"type":"wikibase-entityid"}}}],"P1":[{"mainsnak":{"datavalue":{"value":"DS 1","type":"string"}}}]}}'
    end
    let(:manuscript_json) do
      '{"id":"Q101","claims":{"P16":[{"mainsnak":{"datavalue":{"value":{"id":"Q1"},"type":"wikibase-entityid"}}}],"P2":[{"mainsnak":{"datavalue":{"value":{"id":"Q102"},"type":"wikibase-entityid"}}}]}}'
    end
    let(:record_json) do
      '{"id":"Q103","claims":{"P16":[{"mainsnak":{"datavalue":{"value":{"id":"Q3"},"type":"wikibase-entityid"}}}],"P3":[{"mainsnak":{"datavalue":{"value":{"id":"Q101"},"type":"wikibase-entityid"}}}]}}'
    end

    it 'initializes from linked records in export' do
      holding = ItemRepresenter.new(DsItem.new).from_json(holding_json)
      manuscript = ItemRepresenter.new(DsItem.new).from_json(manuscript_json)
      record = ItemRepresenter.new(DsItem.new).from_json(record_json)

      meta = described_class.new(record, { record.id => record, holding.id => holding, manuscript.id => manuscript })
      expect(meta.holding).to eq holding
      expect(meta.manuscript).to eq manuscript
      expect(meta.record).to eq record
    end
  end
end
