# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Representers

  RSpec.describe DsMeta do
    let(:holding_json) { File.read(File.expand_path('../fixtures/holding.json', __dir__)) }
    let(:manuscript_json) { File.read(File.expand_path('../fixtures/manuscript.json', __dir__)) }
    let(:record_json) { File.read(File.expand_path('../fixtures/record.json', __dir__)) }

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
