# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Representers

  RSpec.describe DsMeta do
    let(:holding) { item_from_fixture('items/Q542_holding_example.json') }
    let(:manuscript) { item_from_fixture('items/Q543_manuscript_example.json') }
    let(:record) { item_from_fixture('items/Q544_record_example.json') }

    context 'with a record concerning a manuscript with a single current holding' do
      it 'correctly sets the holding' do
        meta = described_class.new(record, export_hash)
        expect(meta.holding).to eq holding
      end
    end

    # TODO: Create setters in wikibase_representable and use them to build objects for testing
    # (currently) counterfactual holdings scenarios (i.e., other than exactly one current holding)
  end
end
