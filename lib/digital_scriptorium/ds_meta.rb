# frozen_string_literal: true

module DigitalScriptorium
  # Represents a meta record consisting of a manuscript, its holding information, and metadata record.
  class DsMeta
    attr_reader :holding, :manuscript, :record

    def initialize(record, export_hash)
      manuscript = export_hash[record.described_manuscript_id]
      current_holdings = current_holdings(manuscript, export_hash)

      @holding = validate_holdings_count(manuscript, current_holdings)
      @manuscript = manuscript
      @record = record
    end

    def current_holdings(manuscript, export_hash)
      manuscript.holding_ids.filter_map { |id| export_hash[id] if export_hash[id]&.current? }
    end

    private

    def validate_holdings_count(manuscript, current_holdings)
      case current_holdings.size
      when 0
        raise NoCurrentHoldingException, manuscript.id
      when 1
        current_holdings.first
      else
        raise MultipleCurrentHoldingsException.new(manuscript.id, current_holdings.size)
      end
    end
  end
end
