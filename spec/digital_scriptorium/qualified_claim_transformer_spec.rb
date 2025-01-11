# frozen_string_literal: true

require 'json'
require 'wikibase_representable'
require 'yaml'

module DigitalScriptorium
  include WikibaseRepresentable::Model
  include WikibaseRepresentable::Representers

  RSpec.describe QualifiedClaimTransformer do
    let(:export_hash) do
      {
        'Q33' => ItemRepresenter.new(Item.new).from_json(read_fixture('items/parchment.json')),
        'Q113' => ItemRepresenter.new(Item.new).from_json(read_fixture('items/latin.json')),
        'Q128' => ItemRepresenter.new(Item.new).from_json(read_fixture('items/provence.json')),
        'Q129' => ItemRepresenter.new(Item.new).from_json(read_fixture('items/spain.json')),
        'Q283' => ItemRepresenter.new(Item.new).from_json(read_fixture('items/deeds.json')),
        'Q354' => ItemRepresenter.new(Item.new).from_json(read_fixture('items/almagest.json')),
        'Q374' => ItemRepresenter.new(Item.new).from_json(read_fixture('items/penn.json'))
      }
    end

    let(:config) { YAML.load_file(File.expand_path('../../property_config.yml', __dir__)) }

    context 'with an institution claim' do
      json = read_fixture('claims/qualified/institution.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'institution_display' => ['{"recorded_value":"University of Pennsylvania","linked_terms":[{"label":"University of Pennsylvania","source_url":"https://www.wikidata.org/wiki/Q49117"}]}'],
        'institution_search' => ['University of Pennsylvania'],
        'institution_facet' => ['University of Pennsylvania']
      }

      it 'provides the qualifier label in the display, search, and facet fields' do
        solr_item = described_class.transform(claim, export_hash, config[PropertyId::HOLDING_INSTITUTION_AS_RECORDED])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a title claim with standard title and original script qualifiers' do
      json = read_fixture('claims/qualified/title.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'title_display' => ['{"recorded_value":"Kitāb al-Majisṭī","original_script":"كتاب المجسطي.","linked_terms":[{"label":"Almagest"}]}'],
        'title_search' => ['Kitāb al-Majisṭī', 'كتاب المجسطي.', 'Almagest'],
        'title_facet' => ['Almagest']
      }

      it 'provides all titles in the display and search fields and the standard title in the facet field' do
        solr_item = described_class.transform(claim, export_hash, config[PropertyId::TITLE_AS_RECORDED])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a qualified genre claim' do
      json = read_fixture('claims/qualified/genre.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'term_display' => ['{"recorded_value":"Deeds","linked_terms":[{"label":"deeds","source_url":"http://vocab.getty.edu/aat/300027249"}]}'],
        'term_search' => %w[Deeds deeds],
        'term_facet' => ['deeds']
      }

      it 'provides both values in display and search fields and authoritative value in the facet field' do
        solr_item = described_class.transform(claim, export_hash, config[PropertyId::GENRE_AS_RECORDED])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a qualified language claim' do
      json = read_fixture('claims/qualified/language.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'language_display' => ['{"recorded_value":"In Latin","linked_terms":[{"label":"Latin","source_url":"https://www.wikidata.org/wiki/Q397"}]}'],
        'language_search' => ['In Latin', 'Latin'],
        'language_facet' => ['Latin']
      }

      it 'provides both values in display and search fields and authoritative value in the facet field' do
        solr_item = described_class.transform(claim, export_hash, config[PropertyId::LANGUAGE_AS_RECORDED])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a place claim with multi-valued qualifier' do
      json = read_fixture('claims/qualified/place.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'place_display' => ['{"recorded_value":"[Provence or Spain],","linked_terms":[{"label":"Provence","source_url":"http://vocab.getty.edu/tgn/7012209"},{"label":"Spain","source_url":"http://vocab.getty.edu/tgn/1000095"}]}'],
        'place_search' => ['[Provence or Spain],', 'Provence', 'Spain'],
        'place_facet' => %w[Provence Spain]
      }

      it 'includes the data from all qualifiers in the display, search, and facet fields' do
        solr_item = described_class.transform(claim, export_hash, config[PropertyId::PRODUCTION_PLACE_AS_RECORDED])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a qualified material claim' do
      json = read_fixture('claims/qualified/material.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'material_display' => ['{"recorded_value":"parchment","linked_terms":[{"label":"Parchment","source_url":"http://vocab.getty.edu/aat/300011851"}]}'],
        'material_search' => %w[parchment Parchment],
        'material_facet' => ['Parchment']
      }

      it 'provides the authoritative label in the facet field' do
        solr_item = described_class.transform(claim, export_hash, config[PropertyId::MATERIAL_AS_RECORDED])
        expect(solr_item).to eq(expected)
      end
    end
  end
end
