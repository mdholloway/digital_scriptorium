# frozen_string_literal: true

module DigitalScriptorium
  RSpec.describe ExportRepresenter do
    it 'deserializes holding as a Holding' do
      expect(export_hash.fetch('Q542')).to be_instance_of Holding
    end

    it 'deserializes manuscript as a Manuscript' do
      expect(export_hash.fetch('Q543')).to be_instance_of Manuscript
    end

    it 'deserializes record as a Record' do
      expect(export_hash.fetch('Q544')).to be_instance_of Record
    end

    it 'deserializes property as a Property' do
      expect(export_hash.fetch('P16')).to be_instance_of WikibaseRepresentable::Model::Property
    end

    it 'deserializes non-core item as an Item' do
      expect(export_hash.fetch('Q129')).to be_instance_of WikibaseRepresentable::Model::Item
    end
  end
end
