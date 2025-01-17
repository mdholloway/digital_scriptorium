# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include PropertyId

  RSpec.describe PhysicalDescriptionClaimTransformer do
    context 'with a physical description (P29) claim' do
      json = read_fixture('claims/P29_physical_description.json')
      prefix = Transformers.prefix(PHYSICAL_DESCRIPTION)
      expected = {
        'physical_description_display' => ['{"recorded_value":"Extent: 1 parchment ; 170 x 245 mm."}'],
        'physical_description_search' => ['Extent: 1 parchment ; 170 x 245 mm.']
      }

      it 'provides the recorded physical description in the display and search fields' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
