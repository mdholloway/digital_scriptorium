# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include ItemId
  include WikibaseRepresentable::Representers

  RSpec.describe DsItem do
    let(:holding) { item_from_fixture('items/Q542_holding_example.json') }
    let(:manuscript) { item_from_fixture('items/Q543_manuscript_example.json') }
    let(:record) { item_from_fixture('items/Q544_record_example.json') }

    it 'correctly reports holding instance-of item ID' do
      expect(holding.instance_of).to eq HOLDING
    end

    it 'correctly reports manuscript instance-of item ID' do
      expect(manuscript.instance_of).to eq MANUSCRIPT
    end

    it 'correctly reports record instance-of item ID' do
      expect(record.instance_of).to eq DS_20_RECORD
    end
  end
end
