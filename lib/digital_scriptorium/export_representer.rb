# frozen_string_literal: true

require 'representable/json/collection'
require 'wikibase_representable'

module DigitalScriptorium
  # Representer class for deserializing Wikibase data exports from JSON.
  class ExportRepresenter < Representable::Decorator
    include Representable::JSON::Collection

    items decorator: lambda { |input:, **|
      if input.type == WikibaseRepresentable::Model::Item::ENTITY_TYPE
        WikibaseRepresentable::Representers::ItemRepresenter
      else
        WikibaseRepresentable::Representers::PropertyRepresenter
      end
    }, class: lambda { |input:, **|
      unless input['type'] == WikibaseRepresentable::Model::Item::ENTITY_TYPE
        return WikibaseRepresentable::Model::Property
      end

      case ExportRepresenter.instance_of_id_from input
      when ItemId::MANUSCRIPT
        Manuscript
      when ItemId::HOLDING
        Holding
      when ItemId::DS_20_RECORD
        Record
      else
        DsItem
      end
    }

    def self.instance_of_id_from(item_hash)
      claims = item_hash['claims']
      return nil unless claims&.any?

      claims.dig(PropertyId::INSTANCE_OF, 0, 'mainsnak', 'datavalue', 'value', 'id')
    end

    private

    def instance_of_id_from(item_hash)
      self.class.instance_of_id_from(item_hash)
    end
  end
end
