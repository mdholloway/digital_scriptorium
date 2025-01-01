# frozen_string_literal: true

module DigitalScriptorium
  class Export < Array
    def to_hash
      hash = {}
      self.each do |el|
        hash[el.id] = el
      end
      hash
    end
  end
end
