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
      input['type'] == Item::ENTITY_TYPE ? DsItem : Property
    }
  end
end
