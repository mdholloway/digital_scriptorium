# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Model
  include WikibaseRepresentable::Representers

  RSpec.describe ExportRepresenter do
    let(:holding_json) { read_fixture('items/holding.json') }
    let(:manuscript_json) { read_fixture('items/manuscript.json') }
    let(:record_json) { read_fixture('items/record.json') }
    let(:property_json) { read_fixture('properties/instance_of.json') }
    let(:export) do
      described_class.new(Export.new).from_json("[#{holding_json},#{manuscript_json},#{record_json},#{property_json}]")
    end

    it 'deserializes holding as a DsItem' do
      expect(export[0]).to be_instance_of DsItem
    end

    it 'deserializes manuscript as a DsItem' do
      expect(export[1]).to be_instance_of DsItem
    end

    it 'deserializes record as a DsItem' do
      expect(export[2]).to be_instance_of DsItem
    end

    it 'deserializes property as a Property' do
      expect(export[3]).to be_instance_of Property
    end
  end
end
