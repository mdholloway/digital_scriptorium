# frozen_string_literal: true

require 'wikibase_representable'
require 'yaml'

module DigitalScriptorium
  include WikibaseRepresentable::Model
  include WikibaseRepresentable::Representers

  RSpec.describe LinkClaimTransformer do
    let(:config) { YAML.load_file(File.expand_path('../../property_config.yml', __dir__)) }

    context 'with an institutional record claim' do
      json = read_fixture('claims/unqualified/institutional_record.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'institutional_record_link' => ['https://franklin.library.upenn.edu/catalog/FRANKLIN_9949945603503681']
      }

      it 'provides the link to the institutional record' do
        solr_item = described_class.transform(claim, config[PropertyId::LINK_TO_INSTITUTIONAL_RECORD])
        expect(solr_item).to eq(expected)
      end
    end

    context 'with an IIIF manifest claim' do
      json = read_fixture('claims/unqualified/iiif_manifest.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'iiif_manifest_link' => ['https://colenda.library.upenn.edu/phalt/iiif/2/81431-p33p8v/manifest'],
        'images_facet' => ['Yes']
      }

      it 'provides the link to the IIIF manifest in the link property and "Yes" in the facet property' do
        solr_item = described_class.transform(claim, config[PropertyId::IIIF_MANIFEST])
        expect(solr_item).to eq(expected)
      end
    end
  end
end
