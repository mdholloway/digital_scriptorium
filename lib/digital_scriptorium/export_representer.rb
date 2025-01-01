# frozen_string_literal: true

require 'representable/json/collection'
require 'wikibase_representable'

module DigitalScriptorium
  class ExportRepresenter < Representable::Decorator
    include Representable::JSON::Collection
    include WikibaseRepresentable::Model
    include WikibaseRepresentable::Representers
    
    items decorator: ->(input:,**) do
      input.type == Item::ENTITY_TYPE ? ItemRepresenter : PropertyRepresenter
    end, class: ->(input:,**) do
      input['type'] == Item::ENTITY_TYPE ? DsItem : Property
    end
  end
end
