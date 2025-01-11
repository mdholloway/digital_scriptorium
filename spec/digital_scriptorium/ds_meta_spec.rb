# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Representers

  RSpec.describe DsMeta do
    let(:holding) { item_from_fixture('items/Q542_holding_example.json') }
    let(:manuscript) { item_from_fixture('items/Q543_manuscript_example.json') }
    let(:record) { item_from_fixture('items/Q544_record_example.json') }
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
