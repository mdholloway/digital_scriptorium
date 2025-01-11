# frozen_string_literal: true

require 'json'
require 'wikibase_representable'
require 'yaml'

module DigitalScriptorium
  include WikibaseRepresentable::Model
  include WikibaseRepresentable::Representers

  RSpec.describe UnqualifiedClaimTransformer do
    let(:export_hash) { { 'Q4' => ItemRepresenter.new(Item.new).from_json(read_fixture('items/current.json')) } }
    let(:config) { YAML.load_file(File.expand_path('../../property_config.yml', __dir__)) }

    context 'with a holding status claim' do
      json = read_fixture('claims/unqualified/status.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'holding_status_display' => ['{"recorded_value":"Current","linked_terms":[]}'],
        'holding_status_search' => ['Current']
      }

      it 'provides the label for the canonical holding status item in the display property' do
        solr_item = described_class.transform(claim, export_hash, config[PropertyId::HOLDING_STATUS])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a shelfmark claim' do
      json = read_fixture('claims/unqualified/shelfmark.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'shelfmark_display' => ['{"recorded_value":"Oversize LJS 110","linked_terms":[]}'],
        'shelfmark_search' => ['Oversize LJS 110']
      }

      it 'provides the recorded shelfmark in the display and search properties' do
        solr_item = described_class.transform(claim, export_hash, config[PropertyId::SHELFMARK])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with a physical description claim' do
      json = read_fixture('claims/unqualified/physical_description.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'physical_description_display' => ['{"recorded_value":"Extent: 1 parchment ; 170 x 245 mm.","linked_terms":[]}'],
        'physical_description_search' => ['Extent: 1 parchment ; 170 x 245 mm.']
      }

      it 'provides the recorded physical description in the display and search fields' do
        solr_item = described_class.transform(claim, export_hash, config[PropertyId::PHYSICAL_DESCRIPTION])
        expect(solr_item).to eq(expected)
      end
    end
  end
end
