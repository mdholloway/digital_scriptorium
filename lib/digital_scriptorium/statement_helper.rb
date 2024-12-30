# frozen_string_literal: true

module DigitalScriptorium
  module StatementHelper
    # Convenience method for getting the first claim for properties that should have only one
    def first_claim_by_property_id
      claims = get_claims_by_property_id
      return nil if claims.empty?

      claims.first
    end
  end
end
