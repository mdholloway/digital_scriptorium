# frozen_string_literal: true

require 'representable/json/collection'
require 'wikibase_representable'

module DigitalScriptorium
  # Representer class for deserializing Wikibase data exports from JSON.
  class ExportRepresenter < Representable::Decorator
    include ItemId
    include Representable::JSON::Collection
    include WikibaseRepresentable::Model
    include WikibaseRepresentable::Representers

    items decorator: lambda { |input:, **|
      input.type == Item::ENTITY_TYPE ? ItemRepresenter : PropertyRepresenter
    }, class: lambda { |input:, **|
      return Property unless input['type'] == Item::ENTITY_TYPE

      instance_of_id = instance_of_id_from input
      return Item unless CORE_MODEL_ITEMS.include? instance_of_id

      if instance_of_id == MANUSCRIPT
        Manuscript
      elsif instance_of_id == HOLDING
        Holding
      else
        Record
      end
    }
  end
end
