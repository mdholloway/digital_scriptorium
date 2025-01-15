# frozen_string_literal: true

require 'json'

module DigitalScriptorium
  RSpec.describe LanguageClaimTransformer do
    context 'with a qualified language (P21) claim' do
      json = read_fixture('claims/P21_language_qualified.json')
      expected = {
        'language_display' => [{
          'recorded_value' => 'In Latin',
          'linked_terms': [{ 'label' => 'Latin', 'source_url' => 'https://www.wikidata.org/wiki/Q397' }]
        }.to_json],
        'language_search' => ['In Latin', 'Latin'],
        'language_facet' => ['Latin']
      }

      it 'provides both values in display and search fields and authoritative value in the facet field' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified language (P21) claim' do
      json = read_fixture('claims/P21_language_unqualified.json')
      expected = {
        'language_display' => [{ 'recorded_value' => 'In Latin' }.to_json],
        'language_search' => ['In Latin']
      }

      it 'provides the recorded value in the display and search fields only' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
