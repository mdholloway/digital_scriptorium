# frozen_string_literal: true

module DigitalScriptorium
  # Simple model class representing a Wikibase JSON export.
  # Provides a to_hash method to facilitate entity lookups by ID.
  class Export < Array
    def to_hash
      each_with_object({}) { |el, hash| hash[el.id] = el }
    end
  end
end
