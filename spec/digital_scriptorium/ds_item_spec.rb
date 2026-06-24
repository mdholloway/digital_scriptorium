# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  RSpec.describe DsItem do
    let(:holding) { item_from_fixture('items/Q542_holding_example.json') }
    let(:manuscript) { item_from_fixture('items/Q543_manuscript_example.json') }
    let(:record) { item_from_fixture('items/Q544_record_example.json') }

    it 'correctly reports holding instance-of item ID' do
      expect(holding.instance_of).to eq ItemId::HOLDING
    end

    it 'correctly reports manuscript instance-of item ID' do
      expect(manuscript.instance_of).to eq ItemId::MANUSCRIPT
    end

    it 'correctly reports record instance-of item ID' do
      expect(record.instance_of).to eq ItemId::DS_20_RECORD
    end
  end
end
