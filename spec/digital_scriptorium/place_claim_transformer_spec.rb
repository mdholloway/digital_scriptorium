# frozen_string_literal: true

require 'json'

module DigitalScriptorium
  RSpec.describe PlaceClaimTransformer do
    context 'with a qualified place (P27) claim with multi-valued qualifier' do
      json = read_fixture('claims/P27_place_multiple_qualifier_values.json')
      expected = {
        'place_display' => [{
          'recorded_value' => '[Provence or Spain],',
          'linked_terms' => [
            { 'label' => 'Provence', 'source_url' => 'http://vocab.getty.edu/tgn/7012209' },
            { 'label' => 'Spain', 'source_url' => 'http://vocab.getty.edu/tgn/1000095' }
          ]
        }.to_json],
        'place_search' => ['[Provence or Spain],', 'Provence', 'Spain'],
        'place_facet' => %w[Provence Spain]
      }

      it 'includes the data from all qualifiers in the display, search, and facet fields' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified place (P27) claim' do
      json = read_fixture('claims/P27_place_unqualified.json')
      expected = {
        'place_display' => [{ 'recorded_value' => '[Provence or Spain],' }.to_json],
        'place_search' => ['[Provence or Spain],']
      }

      it 'provides the recorded value in the search and facet fields only' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
