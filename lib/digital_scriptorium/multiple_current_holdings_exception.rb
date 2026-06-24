# frozen_string_literal: true

module DigitalScriptorium
  # Exception raised when a manuscript has multiple current holdings, which is an invalid state
  # that requires correction in the data.
  class MultipleCurrentHoldingsException < StandardError
    attr_reader :manuscript_id, :holdings_count

    def initialize(manuscript_id, holdings_count)
      @manuscript_id = manuscript_id
      @holdings_count = holdings_count
      super("Manuscript #{manuscript_id} has #{holdings_count} current holdings, expected at most 1")
    end
  end
end
