# frozen_string_literal: true

require 'json'

module DigitalScriptorium
  RSpec.describe MaterialClaimTransformer do
    context 'with a qualified material (P30) claim' do
      json = read_fixture('claims/P30_material_qualified.json')
      expected = {
        'material_display' => [{
          'recorded_value' => 'parchment',
          'linked_terms' => [{ 'label' => 'Parchment', 'source_url' => 'http://vocab.getty.edu/aat/300011851' }]
        }.to_json],
        'material_search' => %w[parchment Parchment],
        'material_facet' => ['Parchment']
      }

      it 'provides the authoritative label in the facet field' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified material (P30) claim' do
      json = read_fixture('claims/P30_material_unqualified.json')
      expected = {
        'material_display' => [{ 'recorded_value' => 'parchment' }.to_json],
        'material_search' => ['parchment']
      }

      it 'provides the recorded value only in the search and display fields' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
