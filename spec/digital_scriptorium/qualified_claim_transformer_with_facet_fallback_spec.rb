# frozen_string_literal: true

require 'json'

module DigitalScriptorium
  include PropertyId

  RSpec.describe QualifiedClaimTransformerWithFacetFallback do
    context 'with a title (P10) claim with standard title (P11) and original script (P13) qualifiers' do
      json = read_fixture('claims/P10_title_qualified.json')
      prefix = Transformers.prefix(TITLE_AS_RECORDED)
      authority_id = Transformers.authority_id(TITLE_AS_RECORDED)
      expected = {
        'title_display' => [{
          'recorded_value' => 'Kitāb al-Majisṭī',
          'original_script' => 'كتاب المجسطي.',
          'linked_terms': [{ 'label' => 'Almagest' }]
        }.to_json],
        'title_search' => ['Kitāb al-Majisṭī', 'كتاب المجسطي.', 'Almagest'],
        'title_facet' => ['Almagest']
      }

      it 'provides all titles in the display and search fields and the standard title in the facet field' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with a title (P10) claim with only an original script (P13) qualifier' do
      json = read_fixture('claims/P10_title_qualified_original_script_only.json')
      prefix = Transformers.prefix(TITLE_AS_RECORDED)
      authority_id = Transformers.authority_id(TITLE_AS_RECORDED)
      expected = {
        'title_display' => [{
          'recorded_value' => 'Kitāb al-Majisṭī',
          'original_script' => 'كتاب المجسطي.'
        }.to_json],
        'title_search' => ['Kitāb al-Majisṭī', 'كتاب المجسطي.'],
        'title_facet' => ['Kitāb al-Majisṭī']
      }

      it 'provides the original script title and falls back to the recorded title in the facet field' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified title (P10) claim' do
      json = read_fixture('claims/P10_title_unqualified.json')
      prefix = Transformers.prefix(TITLE_AS_RECORDED)
      authority_id = Transformers.authority_id(TITLE_AS_RECORDED)
      expected = {
        'title_display' => [{ 'recorded_value' => 'Kitāb al-Majisṭī' }.to_json],
        'title_search' => ['Kitāb al-Majisṭī'],
        'title_facet' => ['Kitāb al-Majisṭī']
      }

      it 'falls back to the recorded title in the facet field' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with a qualified genre (P18) claim' do
      json = read_fixture('claims/P18_genre_qualified.json')
      prefix = Transformers.prefix(GENRE_AS_RECORDED)
      authority_id = Transformers.authority_id(GENRE_AS_RECORDED)
      expected = {
        'term_display' => [{
          'recorded_value' => 'Deeds',
          'linked_terms': [{ 'label' => 'deeds', 'source_url' => 'http://vocab.getty.edu/aat/300027249' }]
        }.to_json],
        'term_search' => %w[Deeds deeds],
        'term_facet' => ['deeds']
      }

      it 'provides both values in display and search fields and authoritative value in the facet field' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified genre (P18) claim' do
      json = read_fixture('claims/P18_genre_unqualified.json')
      prefix = Transformers.prefix(GENRE_AS_RECORDED)
      authority_id = Transformers.authority_id(GENRE_AS_RECORDED)
      expected = {
        'term_display' => [{ 'recorded_value' => 'Deeds' }.to_json],
        'term_search' => ['Deeds'],
        'term_facet' => ['Deeds']
      }

      it 'provides the recorded value for display and search and falls back to recorded value for the facet' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with a subject (P19) claim with multiple authority (P20) values' do
      json = read_fixture('claims/P19_subject_multiple_qualifier_values.json')
      prefix = Transformers.prefix(SUBJECT_AS_RECORDED)
      authority_id = Transformers.authority_id(SUBJECT_AS_RECORDED)
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
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified subject (P19) claim' do
      json = read_fixture('claims/P19_subject_unqualified.json')
      prefix = Transformers.prefix(SUBJECT_AS_RECORDED)
      authority_id = Transformers.authority_id(SUBJECT_AS_RECORDED)
      expected = {
        'term_display' => [{ 'recorded_value' => 'Cosmology--Early works to 1800' }.to_json],
        'term_search' => ['Cosmology--Early works to 1800'],
        'term_facet' => ['Cosmology--Early works to 1800']
      }

      it 'provides recorded value in display and search fields and falls back to recorded value in the facet field' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
