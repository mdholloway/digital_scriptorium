# frozen_string_literal: true

require 'json'

module DigitalScriptorium
  RSpec.describe TermClaimTransformer do
    context 'with a qualified genre (P18) claim' do
      json = read_fixture('claims/P18_genre_qualified.json')
      expected = {
        'term_display' => [{
          'recorded_value' => 'Deeds',
          'linked_terms': [{ 'label' => 'deeds', 'source_url' => 'http://vocab.getty.edu/aat/300027249' }]
        }.to_json],
        'term_search' => %w[Deeds deeds],
        'term_facet' => ['deeds']
      }

      it 'provides both values in display and search fields and authoritative value in the facet field' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified genre (P18) claim' do
      json = read_fixture('claims/P18_genre_unqualified.json')
      expected = {
        'term_display' => [{ 'recorded_value' => 'Deeds' }.to_json],
        'term_search' => ['Deeds'],
        'term_facet' => ['Deeds']
      }

      it 'provides the recorded value for display and search and falls back to recorded value for the facet' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with a subject (P19) claim with multiple authority (P20) values' do
      json = read_fixture('claims/P19_subject_multiple_qualifier_values.json')
      expected = {
        'term_display' => [{
          'recorded_value' => 'Cosmology--Early works to 1800',
          'linked_terms' => [
            { 'label' => 'Cosmology', 'source_url' => 'http://id.worldcat.org/fast/880600' },
            { 'label' => 'Early works', 'source_url' => 'http://id.worldcat.org/fast/1411636' }
          ]
        }.to_json],
        'term_search' => ['Cosmology--Early works to 1800', 'Cosmology', 'Early works'],
        'term_facet' => ['Cosmology', 'Early works']
      }

      it 'provides all values in display and search fields and authoritative values in the facet field' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified subject (P19) claim' do
      json = read_fixture('claims/P19_subject_unqualified.json')
      expected = {
        'term_display' => [{ 'recorded_value' => 'Cosmology--Early works to 1800' }.to_json],
        'term_search' => ['Cosmology--Early works to 1800'],
        'term_facet' => ['Cosmology--Early works to 1800']
      }

      it 'provides recorded value in display and search fields and falls back to recorded value in the facet field' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
