# frozen_string_literal: true

module DigitalScriptorium
  # Simple model class representing a Wikibase JSON export.
  # Provides a to_hash method to facilitate entity lookups by ID.
  class Export < Array
    def to_hash
      hash = {}
      each do |el|
        hash[el.id] = el
      end
      hash
    end
  end
end
