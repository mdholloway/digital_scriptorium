# frozen_string_literal: true

require 'json'
require 'wikibase_representable'

module DigitalScriptorium
  include PropertyId
  include WikibaseRepresentable::Model
  include WikibaseRepresentable::Representers

  RSpec.describe QualifiedClaimTransformer do
    def build_claim(json)
      StatementRepresenter.new(Statement.new).from_json(json)
    end

    context 'with a qualified institution (P5) claim' do
      json = read_fixture('claims/P5_institution_qualified.json')
      config = property_config[HOLDING_INSTITUTION_AS_RECORDED]
      expected = {
        'institution_display' => [{
          'recorded_value' => 'U. of Penna.',
          'linked_terms' => [{
            'label' => 'University of Pennsylvania',
            'source_url' => 'https://www.wikidata.org/wiki/Q49117'
          }]
        }.to_json],
        'institution_search' => ['U. of Penna.', 'University of Pennsylvania'],
        'institution_facet' => ['University of Pennsylvania']
      }

      it 'provides the qualifier label in the display, search, and facet fields' do
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with an unqualified institution (P5) claim' do
      json = read_fixture('claims/P5_institution_unqualified.json')
      config = property_config[HOLDING_INSTITUTION_AS_RECORDED]
      expected = {
        'institution_display' => [{ 'recorded_value' => 'U. of Penna.' }.to_json],
        'institution_search' => ['U. of Penna.']
      }

      it 'provides the recorded value only in the search and display fields' do
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a title (P10) claim with standard title (P11) and original script (P13) qualifiers' do
      json = read_fixture('claims/P10_title_qualified.json')
      config = property_config[TITLE_AS_RECORDED]
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
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a title (P10) claim with only an original script (P13) qualifier' do
      json = read_fixture('claims/P10_title_qualified_original_script_only.json')
      config = property_config[TITLE_AS_RECORDED]
      expected = {
        'title_display' => [{
          'recorded_value' => 'Kitāb al-Majisṭī',
          'original_script' => 'كتاب المجسطي.'
        }.to_json],
        'title_search' => ['Kitāb al-Majisṭī', 'كتاب المجسطي.'],
        'title_facet' => ['Kitāb al-Majisṭī']
      }

      it 'provides the original script title and falls back to the recorded title in the facet field' do
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with an unqualified title (P10) claim' do
      json = read_fixture('claims/P10_title_unqualified.json')
      config = property_config[TITLE_AS_RECORDED]
      expected = {
        'title_display' => [{ 'recorded_value' => 'Kitāb al-Majisṭī' }.to_json],
        'title_search' => ['Kitāb al-Majisṭī'],
        'title_facet' => ['Kitāb al-Majisṭī']
      }

      it 'falls back to the recorded title in the facet field' do
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a qualified genre (P18) claim' do
      json = read_fixture('claims/P18_genre_qualified.json')
      config = property_config[GENRE_AS_RECORDED]
      expected = {
        'term_display' => [{
          'recorded_value' => 'Deeds',
          'linked_terms': [{ 'label' => 'deeds', 'source_url' => 'http://vocab.getty.edu/aat/300027249' }]
        }.to_json],
        'term_search' => %w[Deeds deeds],
        'term_facet' => ['deeds']
      }

      it 'provides both values in display and search fields and authoritative value in the facet field' do
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with an unqualified genre (P18) claim' do
      json = read_fixture('claims/P18_genre_unqualified.json')
      config = property_config[GENRE_AS_RECORDED]
      expected = {
        'term_display' => [{ 'recorded_value' => 'Deeds' }.to_json],
        'term_search' => ['Deeds'],
        'term_facet' => ['Deeds']
      }

      it 'provides the recorded value for display and search and falls back to recorded value for the facet' do
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a subject (P19) claim with multiple authority (P20) values' do
      json = read_fixture('claims/P19_subject_multiple_qualifier_values.json')
      config = property_config[SUBJECT_AS_RECORDED]
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
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with an unqualified subject (P19) claim' do
      json = read_fixture('claims/P19_subject_unqualified.json')
      config = property_config[SUBJECT_AS_RECORDED]
      expected = {
        'term_display' => [{ 'recorded_value' => 'Cosmology--Early works to 1800' }.to_json],
        'term_search' => ['Cosmology--Early works to 1800'],
        'term_facet' => ['Cosmology--Early works to 1800']
      }

      it 'provides recorded value in display and search fields and falls back to recorded value in the facet field' do
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a qualified language (P21) claim' do
      json = read_fixture('claims/P21_language_qualified.json')
      config = property_config[LANGUAGE_AS_RECORDED]
      expected = {
        'language_display' => [{
          'recorded_value' => 'In Latin',
          'linked_terms': [{ 'label' => 'Latin', 'source_url' => 'https://www.wikidata.org/wiki/Q397' }]
        }.to_json],
        'language_search' => ['In Latin', 'Latin'],
        'language_facet' => ['Latin']
      }

      it 'provides both values in display and search fields and authoritative value in the facet field' do
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with an unqualified language (P21) claim' do
      json = read_fixture('claims/P21_language_unqualified.json')
      config = property_config[LANGUAGE_AS_RECORDED]
      expected = {
        'language_display' => [{ 'recorded_value' => 'In Latin' }.to_json],
        'language_search' => ['In Latin']
      }

      it 'provides the recorded value in the display and search fields only' do
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a qualified date (P23) claim' do
      json = read_fixture('claims/P23_date_qualified.json')
      config = property_config[PRODUCTION_DATE_AS_RECORDED]
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
        'date_facet' => ['fourteenth century (dates CE)'],
        'century_int' => [1301],
        'earliest_int' => [1358],
        'latest_int' => [1358]
      }

      it 'extracts display, search, facet and extra date fields' do
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with an unqualified date (P23) claim' do
      json = read_fixture('claims/P23_date_unqualified.json')
      config = property_config[PRODUCTION_DATE_AS_RECORDED]
      expected = {
        'date_meta' => ['1358.'],
        'date_display' => [{ 'recorded_value' => '1358.' }.to_json],
        'date_search' => ['1358.']
      }

      it 'provides the recorded value only in the display, search, and meta fields' do
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a qualified place (P27) claim with multi-valued qualifier' do
      json = read_fixture('claims/P27_place_multiple_qualifier_values.json')
      config = property_config[PRODUCTION_PLACE_AS_RECORDED]
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
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with an unqualified place (P27) claim' do
      json = read_fixture('claims/P27_place_unqualified.json')
      config = property_config[PRODUCTION_PLACE_AS_RECORDED]
      expected = {
        'place_display' => [{ 'recorded_value' => '[Provence or Spain],' }.to_json],
        'place_search' => ['[Provence or Spain],']
      }

      it 'provides the recorded value in the search and facet fields only' do
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a qualified material (P30) claim' do
      json = read_fixture('claims/P30_material_qualified.json')
      config = property_config[MATERIAL_AS_RECORDED]
      expected = {
        'material_display' => [{
          'recorded_value' => 'parchment',
          'linked_terms' => [{ 'label' => 'Parchment', 'source_url' => 'http://vocab.getty.edu/aat/300011851' }]
        }.to_json],
        'material_search' => %w[parchment Parchment],
        'material_facet' => ['Parchment']
      }

      it 'provides the authoritative label in the facet field' do
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with an unqualified material (P30) claim' do
      json = read_fixture('claims/P30_material_unqualified.json')
      config = property_config[MATERIAL_AS_RECORDED]
      expected = {
        'material_display' => [{ 'recorded_value' => 'parchment' }.to_json],
        'material_search' => ['parchment']
      }

      it 'provides the authoritative label in the facet field' do
        solr_item = described_class.transform(build_claim(json), export_hash, config)
        expect(solr_item).to eq(expected)
      end
    end
  end
end
