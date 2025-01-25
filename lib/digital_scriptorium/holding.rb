# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  # An item representing a Digital Scriptorium holding (instance of Q2)
  class Holding < WikibaseRepresentable::Model::Item
    include ItemId
    include PropertyId

    def status_claims
      claims_by_property_id HOLDING_STATUS # P6
    end

    def status
      return nil unless status_claims&.any?

      status_claims&.first&.entity_id_value
    end

    def current?
      status == HOLDING_STATUS_CURRENT
    end
  end
end
