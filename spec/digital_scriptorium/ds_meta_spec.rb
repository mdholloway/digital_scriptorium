# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Representers

  RSpec.describe DsMeta do
    let(:record) { export_hash.fetch('Q544') }
    let(:manuscript) { export_hash.fetch('Q543') }

    context 'with a record concerning a manuscript with a single current holding' do
      it 'correctly sets the holding' do
        meta = described_class.new(record, export_hash)
        expect(meta.holding).to eq export_hash.fetch('Q542')
      end
    end

    context 'with a record concerning a manuscript with no current holdings' do
      let(:manuscript_no_holdings) do
        manuscript.tap { |m| allow(m).to receive(:holding_ids).and_return([]) }
      end

      it 'raises NoCurrentHoldingException' do
        allow(export_hash).to receive(:[]).with(record.described_manuscript_id).and_return(manuscript_no_holdings)

        expect { described_class.new(record, export_hash) }
          .to raise_error(DigitalScriptorium::NoCurrentHoldingException,
                          'Manuscript Q543 has no current holding')
      end
    end

    context 'with a record concerning a manuscript with multiple current holdings' do
      let(:first_holding) { instance_double(DigitalScriptorium::Holding, current?: true) }
      let(:second_holding) { instance_double(DigitalScriptorium::Holding, current?: true) }
      let(:manuscript_multi_holdings) do
        manuscript.tap { |m| allow(m).to receive(:holding_ids).and_return(%w[H1 H2]) }
      end

      before do
        allow(export_hash).to receive(:[]).with(record.described_manuscript_id).and_return(manuscript_multi_holdings)
        allow(export_hash).to receive(:[]).with('H1').and_return(first_holding)
        allow(export_hash).to receive(:[]).with('H2').and_return(second_holding)
      end

      it 'raises MultipleCurrentHoldingsException' do
        expect { described_class.new(record, export_hash) }
          .to raise_error(DigitalScriptorium::MultipleCurrentHoldingsException,
                          'Manuscript Q543 has 2 current holdings, expected at most 1')
      end
    end

    # TODO: Create setters in wikibase_representable and use them to build objects for testing
    # (currently) counterfactual holdings scenarios (i.e., other than exactly one current holding)
  end
end
