# frozen_string_literal: true

require 'json'
require 'wikibase_representable'
require 'yaml'

module DigitalScriptorium
  include WikibaseRepresentable::Model
  include WikibaseRepresentable::Representers

  RSpec.describe UnqualifiedClaimTransformer do
    context 'with a holding status claim' do
      json = read_fixture('claims/unqualified/P6_status.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'holding_status_display' => ['{"recorded_value":"Current"}'],
        'holding_status_search' => ['Current'],
        'holding_status_facet' => ['Current']
      }

      it 'provides the label for the canonical holding status item in the display property' do
        solr_item = described_class.transform(claim, export_hash, config[PropertyId::HOLDING_STATUS])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a shelfmark claim' do
      json = read_fixture('claims/unqualified/P8_shelfmark.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'shelfmark_display' => ['{"recorded_value":"Oversize LJS 110"}'],
        'shelfmark_search' => ['Oversize LJS 110'],
        'shelfmark_facet' => ['Oversize LJS 110']
      }

      it 'provides the recorded shelfmark in the display and search properties' do
        solr_item = described_class.transform(claim, export_hash, config[PropertyId::SHELFMARK])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a physical description claim' do
      json = read_fixture('claims/unqualified/P29_physical_description.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'physical_description_display' => ['{"recorded_value":"Extent: 1 parchment ; 170 x 245 mm."}'],
        'physical_description_search' => ['Extent: 1 parchment ; 170 x 245 mm.'],
        'physical_description_facet' => ['Extent: 1 parchment ; 170 x 245 mm.']
      }

      it 'provides the recorded physical description in the display and search fields' do
        solr_item = described_class.transform(claim, export_hash, config[PropertyId::PHYSICAL_DESCRIPTION])
        expect(solr_item).to eq(expected)
      end
    end
  end
end
