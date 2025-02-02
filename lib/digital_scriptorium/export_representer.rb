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

      case instance_of_id_from input
      when MANUSCRIPT
        Manuscript
      when HOLDING
        Holding
      when DS_20_RECORD
        Record
      else
        DsItem
      end
    }
  end
end
