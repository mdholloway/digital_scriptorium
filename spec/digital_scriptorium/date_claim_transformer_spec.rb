# frozen_string_literal: true

require 'json'

module DigitalScriptorium
  RSpec.describe DateClaimTransformer do
    context 'with a qualified date (P23) claim' do
      json = read_fixture('claims/P23_date_qualified.json')
      expected = {
        'date_meta' => ['1358.'],
        'date_display' => [{
          'recorded_value' => '1358.',
          'linked_terms' => [{
            'label' => 'fourteenth century (dates CE)',
            'source_url' => 'http://vocab.getty.edu/aat/300404506'
          }]
        }.to_json],
        'date_search' => ['1358.', 'fourteenth century (dates CE)'],
        'date_facet' => ['fourteenth century (dates CE)']
      }

      it 'extracts display, search, facet and extra date fields' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified date (P23) claim' do
      json = read_fixture('claims/P23_date_unqualified.json')
      expected = {
        'date_meta' => ['1358.'],
        'date_display' => [{ 'recorded_value' => '1358.' }.to_json],
        'date_search' => ['1358.']
      }

      it 'provides the recorded value only in the display, search, and meta fields' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
