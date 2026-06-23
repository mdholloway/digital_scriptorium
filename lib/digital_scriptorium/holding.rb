# frozen_string_literal: true

module DigitalScriptorium
  # An item representing a Digital Scriptorium holding (instance of Q2)
  class Holding < DsItem
    def status_claims
      claims_by_property_id(PropertyId::HOLDING_STATUS)
    end

    def status
      claims = status_claims
      return unless claims&.any?

      claims.first.entity_id_value
    end

    def current?
      status == ItemId::HOLDING_STATUS_CURRENT
    end
  end
end
