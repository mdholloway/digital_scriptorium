# frozen_string_literal: true

require 'json'
require 'wikibase_representable'
require 'yaml'

module DigitalScriptorium
  RSpec.describe ClaimTransformer do
    let(:id_json) { File.read(File.expand_path('../fixtures/claims/unqualified/id.json', __dir__)) }
    let(:institution_json) { File.read(File.expand_path('../fixtures/claims/qualified/institution.json', __dir__)) }
    let(:status_json) { File.read(File.expand_path('../fixtures/claims/unqualified/status.json', __dir__)) }
    let(:shelfmark_json) { File.read(File.expand_path('../fixtures/claims/unqualified/shelfmark.json', __dir__)) }
    let(:institutional_record_json) { File.read(File.expand_path('../fixtures/claims/unqualified/institutional_record.json', __dir__)) }
    let(:title_json) { File.read(File.expand_path('../fixtures/claims/qualified/title.json', __dir__)) }
    let(:genre_json) { File.read(File.expand_path('../fixtures/claims/qualified/genre.json', __dir__)) }
    let(:language_json) { File.read(File.expand_path('../fixtures/claims/qualified/language.json', __dir__)) }
    let(:physical_description_json) { File.read(File.expand_path('../fixtures/claims/unqualified/physical_description.json', __dir__)) }
    let(:material_json) { File.read(File.expand_path('../fixtures/claims/qualified/material.json', __dir__)) }
    let(:iiif_manifest_json) { File.read(File.expand_path('../fixtures/claims/unqualified/iiif_manifest.json', __dir__)) }

    let(:almagest_json) { File.read(File.expand_path('../fixtures/items/almagest.json', __dir__)) }
    let(:current_json) { File.read(File.expand_path('../fixtures/items/current.json', __dir__)) }
    let(:deeds_json) { File.read(File.expand_path('../fixtures/items/deeds.json', __dir__)) }
    let(:latin_json) { File.read(File.expand_path('../fixtures/items/latin.json', __dir__)) }
    let(:parchment_json) { File.read(File.expand_path('../fixtures/items/parchment.json', __dir__)) }
    let(:penn_json) { File.read(File.expand_path('../fixtures/items/penn.json', __dir__)) }

    let(:export_hash) do
      {
        'Q4' => ItemRepresenter.new(Item.new).from_json(current_json),
        'Q33' => ItemRepresenter.new(Item.new).from_json(parchment_json),
        'Q113' => ItemRepresenter.new(Item.new).from_json(latin_json),
        'Q283' => ItemRepresenter.new(Item.new).from_json(deeds_json),
        'Q354' => ItemRepresenter.new(Item.new).from_json(almagest_json),
        'Q374' => ItemRepresenter.new(Item.new).from_json(penn_json)
      }
    end
    let(:config) { YAML.load_file(File.expand_path('../../property_config.yml', __dir__)) }

    it 'transforms an id claim' do
      id_claim = StatementRepresenter.new(Statement.new).from_json(id_json)
      solr_item = described_class.transform(id_claim, export_hash, config[PropertyId::DS_ID])
      expected = {
        'id' => ['DS121'],
        'id_display' => ['{"PV":"DS121"}'],
        'id_search' => ['DS121']
      }
      expect(solr_item).to eq(expected)
    end

    it 'transforms an institution claim' do
      institution_claim = StatementRepresenter.new(Statement.new).from_json(institution_json)
      solr_item = described_class.transform(institution_claim, export_hash, config[PropertyId::HOLDING_INSTITUTION_AS_RECORDED])
      expected = {
        'institution_display' => ['{"PV":"University of Pennsylvania","QL":"University of Pennsylvania","QU":"https://www.wikidata.org/wiki/Q49117"}'],
        'institution_search' => ['University of Pennsylvania'],
        'institution_facet' => ['University of Pennsylvania']
      }
      expect(solr_item).to eq(expected)
    end

    it 'transforms a holding status claim' do
      status_claim = StatementRepresenter.new(Statement.new).from_json(status_json)
      solr_item = described_class.transform(status_claim, export_hash, config[PropertyId::HOLDING_STATUS])
      expected = { 'holding_status_display' => ['{"PV":"Current"}'] }
      expect(solr_item).to eq(expected)
    end

    it 'transforms a shelfmark claim' do
      shelfmark_claim = StatementRepresenter.new(Statement.new).from_json(shelfmark_json)
      solr_item = described_class.transform(shelfmark_claim, export_hash, config[PropertyId::SHELFMARK])
      expected = {
        'shelfmark_display' => ['{"PV":"Oversize LJS 110"}'],
        'shelfmark_search' => ['Oversize LJS 110']
      }
      expect(solr_item).to eq(expected)
    end

    it 'transforms an institutional record claim' do
      institutional_record_claim = StatementRepresenter.new(Statement.new).from_json(institutional_record_json)
      solr_item = described_class.transform(institutional_record_claim, export_hash, config[PropertyId::LINK_TO_INSTITUTIONAL_RECORD])
      expected = { 'institutional_record_link' => ['https://franklin.library.upenn.edu/catalog/FRANKLIN_9949945603503681'] }
      expect(solr_item).to eq(expected)
    end

    it 'transforms a title claim' do
      title_claim = StatementRepresenter.new(Statement.new).from_json(title_json)
      solr_item = described_class.transform(title_claim, export_hash, config[PropertyId::TITLE_AS_RECORDED])
      expected = {
        'title_display' => ['{"PV":"Kitāb al-Majisṭī","QL":"Almagest"}'],
        'title_search' => ['Kitāb al-Majisṭī', 'Almagest'],
        'title_facet' => ['Almagest']
      }
      expect(solr_item).to eq(expected)
    end

    it 'transforms a genre claim' do
      genre_claim = StatementRepresenter.new(Statement.new).from_json(genre_json)
      solr_item = described_class.transform(genre_claim, export_hash, config[PropertyId::GENRE_AS_RECORDED])
      expected = {
        'term_display' => ['{"PV":"Deeds","QL":"deeds","QU":"http://vocab.getty.edu/aat/300027249"}'],
        'term_search' => %w[Deeds deeds],
        'term_facet' => ['deeds']
      }
      expect(solr_item).to eq(expected)
    end

    it 'transforms a language claim' do
      language_claim = StatementRepresenter.new(Statement.new).from_json(language_json)
      solr_item = described_class.transform(language_claim, export_hash, config[PropertyId::LANGUAGE_AS_RECORDED])
      expected = {
        'language_display' => ['{"PV":"In Latin","QL":"Latin","QU":"https://www.wikidata.org/wiki/Q397"}'],
        'language_search' => ['In Latin', 'Latin'],
        'language_facet' => ['Latin']
      }
      expect(solr_item).to eq(expected)
    end

    it 'transforms a physical description claim' do
      physical_description_claim = StatementRepresenter.new(Statement.new).from_json(physical_description_json)
      solr_item = described_class.transform(physical_description_claim, export_hash, config[PropertyId::PHYSICAL_DESCRIPTION])
      expected = {
        'physical_description_display' => ['{"PV":"Extent: 1 parchment ; 170 x 245 mm."}'],
        'physical_description_search' => ['Extent: 1 parchment ; 170 x 245 mm.']
      }
      expect(solr_item).to eq(expected)
    end

    it 'transforms a material claim' do
      material_claim = StatementRepresenter.new(Statement.new).from_json(material_json)
      solr_item = described_class.transform(material_claim, export_hash, config[PropertyId::MATERIAL_AS_RECORDED])
      expected = { 'material_facet' => ['Parchment'] }
      expect(solr_item).to eq(expected)
    end

    it 'transforms an IIIF manifest claim' do
      iiif_manifest_claim = StatementRepresenter.new(Statement.new).from_json(iiif_manifest_json)
      solr_item = described_class.transform(iiif_manifest_claim, export_hash, config[PropertyId::IIIF_MANIFEST])
      expected = {
        'iiif_manifest_link' => ['https://colenda.library.upenn.edu/phalt/iiif/2/81431-p33p8v/manifest'],
        'images_facet' => ['Yes']
      }
      expect(solr_item).to eq(expected)
    end
  end
end
