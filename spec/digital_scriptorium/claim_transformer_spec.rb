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
    let(:term_json) { File.read(File.expand_path('../fixtures/claims/qualified/term.json', __dir__)) }
    let(:language_json) { File.read(File.expand_path('../fixtures/claims/qualified/language.json', __dir__)) }
    let(:physical_description_json) { File.read(File.expand_path('../fixtures/claims/unqualified/physical_description.json', __dir__)) }
    let(:material_json) { File.read(File.expand_path('../fixtures/claims/qualified/material.json', __dir__)) }
    let(:iiif_manifest_json) { File.read(File.expand_path('../fixtures/claims/unqualified/iiif_manifest.json', __dir__)) }

    let(:almagest_json) { File.read(File.expand_path('../fixtures/items/almagest.json', __dir__)) }
    let(:deeds_json) { File.read(File.expand_path('../fixtures/items/deeds.json', __dir__)) }
    let(:latin_json) { File.read(File.expand_path('../fixtures/items/latin.json', __dir__)) }
    let(:parchment_json) { File.read(File.expand_path('../fixtures/items/parchment.json', __dir__)) }
    let(:penn_json) { File.read(File.expand_path('../fixtures/items/penn.json', __dir__)) }

    let(:export_hash) do
      {
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
  end
end
