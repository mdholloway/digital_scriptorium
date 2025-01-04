# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Model
  include WikibaseRepresentable::Representers

  RSpec.describe ExportRepresenter do
    let(:holding_json) { File.read(File.expand_path('../fixtures/holding.json', __dir__)) }
    let(:manuscript_json) { File.read(File.expand_path('../fixtures/manuscript.json', __dir__)) }
    let(:record_json) { File.read(File.expand_path('../fixtures/record.json', __dir__)) }
    let(:property_json) { File.read(File.expand_path('../fixtures/instance_of.json', __dir__)) }
    let(:export_json) { "[#{holding_json},#{manuscript_json},#{record_json},#{property_json}]" }

    it 'deserializes a Wikibase export from JSON' do
      export = described_class.new(Export.new).from_json(export_json)
      expect(export.size).to eq 4
      expect(export[0]).to be_instance_of DsItem
      expect(export[1]).to be_instance_of DsItem
      expect(export[2]).to be_instance_of DsItem
      expect(export[3]).to be_instance_of Property
    end
  end
end
