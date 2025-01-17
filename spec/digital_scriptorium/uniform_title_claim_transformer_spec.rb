# frozen_string_literal: true

module DigitalScriptorium
  include PropertyId

  RSpec.describe UniformTitleClaimTransformer do
    context 'with a uniform title (P12) claim' do
      json = read_fixture('claims/P12_uniform_title.json')
      prefix = Transformers.prefix(UNIFORM_TITLE_AS_RECORDED)
      expected = {
        'uniform_title_search' => ['Image du monde.']
      }

      it 'provides the uniform title in the search field only' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
