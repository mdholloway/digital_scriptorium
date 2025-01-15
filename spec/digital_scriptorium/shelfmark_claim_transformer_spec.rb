# frozen_string_literal: true

module DigitalScriptorium
  RSpec.describe ShelfmarkClaimTransformer do
    context 'with a shelfmark (P8) claim' do
      json = read_fixture('claims/P8_shelfmark.json')
      expected = {
        'shelfmark_display' => ['{"recorded_value":"Oversize LJS 110"}'],
        'shelfmark_search' => ['Oversize LJS 110']
      }

      it 'provides the recorded shelfmark in the display and search properties' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
