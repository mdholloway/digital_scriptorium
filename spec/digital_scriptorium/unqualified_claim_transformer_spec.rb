# frozen_string_literal: true

require 'json'
require 'wikibase_representable'
require 'yaml'

module DigitalScriptorium
  include PropertyId
  include WikibaseRepresentable::Model
  include WikibaseRepresentable::Representers

  RSpec.describe UnqualifiedClaimTransformer do
    context 'with a shelfmark (P8) claim' do
      json = read_fixture('claims/P8_shelfmark.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      config = property_config[SHELFMARK]
      expected = {
        'shelfmark_display' => ['{"recorded_value":"Oversize LJS 110"}'],
        'shelfmark_search' => ['Oversize LJS 110']
      }

      it 'provides the recorded shelfmark in the display and search properties' do
        solr_item = SolrFieldFilter.filter described_class.transform(claim, export_hash, config), config
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a uniform title (P12) claim' do
      json = read_fixture('claims/P12_uniform_title.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      config = property_config[UNIFORM_TITLE_AS_RECORDED]
      expected = {
        'uniform_title_search' => ['Image du monde.']
      }

      it 'provides the uniform title in the search field only' do
        solr_item = SolrFieldFilter.filter described_class.transform(claim, export_hash, config), config
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a dated (P26) claim' do
      json = read_fixture('claims/P26_dated.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      config = property_config[DATED]
      expected = { 'dated_facet' => ['Non-dated'] }

      it 'provides the label for the applicable entity ID value' do
        solr_item = SolrFieldFilter.filter described_class.transform(claim, export_hash, config), config
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a physical description (P29) claim' do
      json = read_fixture('claims/P29_physical_description.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      config = property_config[PHYSICAL_DESCRIPTION]
      expected = {
        'physical_description_display' => ['{"recorded_value":"Extent: 1 parchment ; 170 x 245 mm."}'],
        'physical_description_search' => ['Extent: 1 parchment ; 170 x 245 mm.']
      }

      it 'provides the recorded physical description in the display and search fields' do
        solr_item = SolrFieldFilter.filter described_class.transform(claim, export_hash, config), config
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a note (P32) claim' do
      json = read_fixture('claims/P32_note.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      config = property_config[NOTE]
      expected = {
        'note_display' => ['{"recorded_value":"Ms. codex."}'],
        'note_search' => ['Ms. codex.']
      }

      it 'provides the note in the display and search fields' do
        solr_item = SolrFieldFilter.filter described_class.transform(claim, export_hash, config), config
        expect(solr_item).to eq(expected)
      end
    end

    context 'with an acknowledgements (P33) claim' do
      json = read_fixture('claims/P33_acknowledgements.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      config = property_config[ACKNOWLEDGEMENTS]
      expected = {
        'acknowledgements_display' => [
          '{"recorded_value":"We thank Michael W. Heil for his work in making this description available."}'
        ]
      }

      it 'provides the acknowledgements in the display field only' do
        solr_item = SolrFieldFilter.filter described_class.transform(claim, export_hash, config), config
        expect(solr_item).to eq(expected)
      end
    end
  end
end
