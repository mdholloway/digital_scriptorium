# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Representers

  RSpec.describe DsMeta do
    let(:holding) { ItemRepresenter.new(DsItem.new).from_json(read_fixture('items/holding.json')) }
    let(:manuscript) { ItemRepresenter.new(DsItem.new).from_json(read_fixture('items/manuscript.json')) }
    let(:record) { ItemRepresenter.new(DsItem.new).from_json(read_fixture('items/record.json')) }
    let(:meta) do
      described_class.new(record, { record.id => record, holding.id => holding, manuscript.id => manuscript })
    end

    it 'correctly returns the holding' do
      expect(meta.holding).to eq holding
    end

    it 'correctly returns the manuscript' do
      expect(meta.manuscript).to eq manuscript
    end

    it 'correctly returns the record' do
      expect(meta.record).to eq record
    end
  end
end
