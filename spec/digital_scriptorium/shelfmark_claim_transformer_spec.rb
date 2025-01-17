# frozen_string_literal: true

module DigitalScriptorium
  include PropertyId

  RSpec.describe ShelfmarkClaimTransformer do
    context 'with a shelfmark (P8) claim' do
      json = read_fixture('claims/P8_shelfmark.json')
      prefix = Transformers.prefix(SHELFMARK)
      expected = {
        'shelfmark_display' => ['{"recorded_value":"Oversize LJS 110"}'],
        'shelfmark_search' => ['Oversize LJS 110']
      }

      it 'provides the recorded shelfmark in the display and search properties' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
