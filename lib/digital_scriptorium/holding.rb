# frozen_string_literal: true

module DigitalScriptorium
  # An item representing a Digital Scriptorium holding (instance of Q2)
  class Holding < DsItem
    def status_claims
      claims_by_property_id PropertyId::HOLDING_STATUS # P6
    end

    def status
      return unless status_claims&.any?

      status_claims&.first&.entity_id_value
    end

    def current?
      status == ItemId::HOLDING_STATUS_CURRENT
    end
  end
end
