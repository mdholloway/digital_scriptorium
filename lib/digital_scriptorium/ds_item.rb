# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  # Represents a generic Digital Scriptorium item
  class DsItem < WikibaseRepresentable::Model::Item
    include PropertyId

    def instance_of
      claims_by_property_id(INSTANCE_OF)&.first&.entity_id_value
    end
  end
end
