# frozen_string_literal: true

module DigitalScriptorium
  RSpec.describe UniformTitleClaimTransformer do
    context 'with a uniform title (P12) claim' do
      json = read_fixture('claims/P12_uniform_title.json')
      expected = {
        'uniform_title_search' => ['Image du monde.']
      }

      it 'provides the uniform title in the search field only' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
