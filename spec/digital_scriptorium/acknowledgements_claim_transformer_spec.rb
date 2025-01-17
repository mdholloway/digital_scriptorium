# frozen_string_literal: true

module DigitalScriptorium
  include PropertyId

  RSpec.describe AcknowledgementsClaimTransformer do
    context 'with an acknowledgements (P33) claim' do
      json = read_fixture('claims/P33_acknowledgements.json')
      prefix = Transformers.prefix(ACKNOWLEDGEMENTS)
      expected = {
        'acknowledgements_display' => [
          '{"recorded_value":"We thank Michael W. Heil for his work in making this description available."}'
        ]
      }

      it 'provides the acknowledgements in the display field only' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
