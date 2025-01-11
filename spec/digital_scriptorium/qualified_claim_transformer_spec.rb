# frozen_string_literal: true

require 'json'
require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Model
  include WikibaseRepresentable::Representers

  RSpec.describe QualifiedClaimTransformer do
    def build_claim(json)
      StatementRepresenter.new(Statement.new).from_json(json)
    end

    context 'with an institution (P5) claim' do
      json = read_fixture('claims/qualified/P5_institution.json')
      expected = {
        'institution_display' => ['{"recorded_value":"University of Pennsylvania","linked_terms":[{"label":"University of Pennsylvania","source_url":"https://www.wikidata.org/wiki/Q49117"}]}'],
        'institution_search' => ['University of Pennsylvania'],
        'institution_facet' => ['University of Pennsylvania']
      }

      it 'provides the qualifier label in the display, search, and facet fields' do
        solr_item = described_class.transform(build_claim(json), export_hash, config[PropertyId::HOLDING_INSTITUTION_AS_RECORDED])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a title (P10) claim with standard title (P11) and original script (P13) qualifiers' do
      json = read_fixture('claims/qualified/P10_title.json')
      expected = {
        'title_display' => ['{"recorded_value":"Kitāb al-Majisṭī","original_script":"كتاب المجسطي.","linked_terms":[{"label":"Almagest"}]}'],
        'title_search' => ['Kitāb al-Majisṭī', 'كتاب المجسطي.', 'Almagest'],
        'title_facet' => ['Almagest']
      }

      it 'provides all titles in the display and search fields and the standard title in the facet field' do
        solr_item = described_class.transform(build_claim(json), export_hash, config[PropertyId::TITLE_AS_RECORDED])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a qualified genre (P18) claim' do
      json = read_fixture('claims/qualified/P18_genre.json')
      expected = {
        'term_display' => ['{"recorded_value":"Deeds","linked_terms":[{"label":"deeds","source_url":"http://vocab.getty.edu/aat/300027249"}]}'],
        'term_search' => %w[Deeds deeds],
        'term_facet' => ['deeds']
      }

      it 'provides both values in display and search fields and authoritative value in the facet field' do
        solr_item = described_class.transform(build_claim(json), export_hash, config[PropertyId::GENRE_AS_RECORDED])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a qualified language (P21) claim' do
      json = read_fixture('claims/qualified/P21_language.json')
      expected = {
        'language_display' => ['{"recorded_value":"In Latin","linked_terms":[{"label":"Latin","source_url":"https://www.wikidata.org/wiki/Q397"}]}'],
        'language_search' => ['In Latin', 'Latin'],
        'language_facet' => ['Latin']
      }

      it 'provides both values in display and search fields and authoritative value in the facet field' do
        solr_item = described_class.transform(build_claim(json), export_hash, config[PropertyId::LANGUAGE_AS_RECORDED])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a date (P23) claim' do
      json = read_fixture('claims/qualified/P23_date.json')
      expected = {
        'date_meta' => ['1358.'],
        'date_display' => ['{"recorded_value":"1358.","linked_terms":[{"label":"fourteenth century (dates CE)","source_url":"http://vocab.getty.edu/aat/300404506"}]}'],
        'date_search' => ['1358.', 'fourteenth century (dates CE)'],
        'date_facet' => ['fourteenth century (dates CE)'],
        'century_int' => [1301],
        'earliest_int' => [1358],
        'latest_int' => [1358]
      }

      it 'extracts display, search, facet and extra date fields' do
        solr_item = described_class.transform(build_claim(json), export_hash, config[PropertyId::PRODUCTION_DATE_AS_RECORDED])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a place (P27) claim with multi-valued qualifier' do
      json = read_fixture('claims/qualified/P27_place.json')
      expected = {
        'place_display' => ['{"recorded_value":"[Provence or Spain],","linked_terms":[{"label":"Provence","source_url":"http://vocab.getty.edu/tgn/7012209"},{"label":"Spain","source_url":"http://vocab.getty.edu/tgn/1000095"}]}'],
        'place_search' => ['[Provence or Spain],', 'Provence', 'Spain'],
        'place_facet' => %w[Provence Spain]
      }

      it 'includes the data from all qualifiers in the display, search, and facet fields' do
        solr_item = described_class.transform(build_claim(json), export_hash, config[PropertyId::PRODUCTION_PLACE_AS_RECORDED])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a qualified material (P30) claim' do
      json = read_fixture('claims/qualified/P30_material.json')
      expected = {
        'material_display' => ['{"recorded_value":"parchment","linked_terms":[{"label":"Parchment","source_url":"http://vocab.getty.edu/aat/300011851"}]}'],
        'material_search' => %w[parchment Parchment],
        'material_facet' => ['Parchment']
      }

      it 'provides the authoritative label in the facet field' do
        solr_item = described_class.transform(build_claim(json), export_hash, config[PropertyId::MATERIAL_AS_RECORDED])
        expect(solr_item).to eq(expected)
      end
    end
  end
end
