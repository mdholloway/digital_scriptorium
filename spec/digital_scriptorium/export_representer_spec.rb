# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  include WikibaseRepresentable::Model
  include WikibaseRepresentable::Representers

  RSpec.describe ExportRepresenter do
    let(:holding_json) do
      '{"type":"item","id":"Q102","claims":{"P16":[{"mainsnak":{"datavalue":{"value":{"id":"Q2"},"type":"wikibase-entityid"}}}],"P1":[{"mainsnak":{"datavalue":{"value":"DS 1","type":"string"}}}]}}'
    end
    let(:manuscript_json) do
      '{"type":"item","id":"Q101","claims":{"P16":[{"mainsnak":{"datavalue":{"value":{"id":"Q1"},"type":"wikibase-entityid"}}}],"P2":[{"mainsnak":{"datavalue":{"value":{"id":"Q102"},"type":"wikibase-entityid"}}}]}}'
    end
    let(:record_json) do
      '{"type":"item","id":"Q103","claims":{"P16":[{"mainsnak":{"datavalue":{"value":{"id":"Q3"},"type":"wikibase-entityid"}}}],"P3":[{"mainsnak":{"datavalue":{"value":{"id":"Q101"},"type":"wikibase-entityid"}}}]}}'
    end
    let(:property_json) do
      '{"type":"property","id":"P16","datatype":"wikibase-item","labels":{"en":{"language":"en","value":"instance of"}}}'
    end
    let(:export_json) do
      "[#{holding_json},#{manuscript_json},#{record_json},#{property_json}]"
    end

    it 'deserializes a Wikibase export from JSON' do
      export = described_class.new(Export.new).from_json(export_json)
      expect(export.size).to eq 4
      expect(export[0]).to be_instance_of DsItem
      expect(export[1]).to be_instance_of DsItem
      expect(export[2]).to be_instance_of DsItem
      expect(export[3]).to be_instance_of Property
    end

    it 'transforms a Wikibase export to a Hash' do
      export = described_class.new(Export.new).from_json(export_json)
      expect(export.to_hash).to eq({
                                     'Q102' => ItemRepresenter.new(DsItem.new).from_json(holding_json),
                                     'Q101' => ItemRepresenter.new(DsItem.new).from_json(manuscript_json),
                                     'Q103' => ItemRepresenter.new(DsItem.new).from_json(record_json),
                                     'P16' => PropertyRepresenter.new(Property.new).from_json(property_json)
                                   })
    end
  end
end
