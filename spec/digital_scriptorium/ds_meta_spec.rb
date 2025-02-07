# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Representers

  RSpec.describe DsMeta do
    context 'with a record concerning a manuscript with a single current holding' do
      it 'correctly sets the holding' do
        record = export_hash.fetch('Q544')
        meta = described_class.new(record, export_hash)
        expect(meta.holding).to eq export_hash.fetch('Q542')
      end
    end

    # TODO: Create setters in wikibase_representable and use them to build objects for testing
    # (currently) counterfactual holdings scenarios (i.e., other than exactly one current holding)
  end
end
