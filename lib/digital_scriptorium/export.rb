# frozen_string_literal: true

module DigitalScriptorium
  # Simple model class representing a Wikibase JSON export.
  # Provides a to_hash method to facilitate entity lookups by ID.
  class Export
    include Enumerable

    def initialize(items = [])
      @items = items
    end

    def <<(item)
      @items << item
      self
    end

    def each(&block)
      @items.each(&block)
    end

    def replace(items)
      @items = items.to_a
      self
    end

    def to_hash
      # rubocop:disable Rails/IndexBy
      @items.to_h { |el| [el.id, el] }
      # rubocop:enable Rails/IndexBy
    end
  end
end
