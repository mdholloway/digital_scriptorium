# frozen_string_literal: true

module DigitalScriptorium
  include PropertyId

  RSpec.describe DatedClaimTransformer do
    context 'with a dated (P26) claim' do
      json = read_fixture('claims/P26_dated.json')
      prefix = Transformers.prefix(DATED)
      expected = { 'dated_facet' => ['Non-dated'] }

      it 'provides the label for the applicable entity ID value' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
