# frozen_string_literal: true

require 'representable/json/collection'
require 'wikibase_representable'

module DigitalScriptorium
  # Representer class for deserializing Wikibase data exports from JSON.
  class ExportRepresenter < Representable::Decorator
    include Representable::JSON::Collection
    include WikibaseRepresentable::Model
    include WikibaseRepresentable::Representers

    items decorator: lambda { |input:, **|
      input.type == Item::ENTITY_TYPE ? ItemRepresenter : PropertyRepresenter
    }, class: lambda { |input:, **|
      return Property unless input['type'] == Item::ENTITY_TYPE

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

    # rubocop:disable Naming/PredicateMethod
    def self.instance_of_id_from(item_hash)
      claims = item_hash['claims']
      return nil unless claims&.any?

      claims.dig(PropertyId::INSTANCE_OF, 0, 'mainsnak', 'datavalue', 'value', 'id')
    end
    # rubocop:enable Naming/PredicateMethod

    private

    def instance_of_id_from(item_hash)
      self.class.instance_of_id_from(item_hash)
    end
  end
end
