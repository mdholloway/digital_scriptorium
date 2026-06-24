# frozen_string_literal: true

module DigitalScriptorium
  # Exception raised when a manuscript has no current holding, which is a valid state
  # but requires special handling in processing workflows.
  class NoCurrentHoldingException < StandardError
    attr_reader :manuscript_id

    def initialize(manuscript_id)
      @manuscript_id = manuscript_id
      super("Manuscript #{manuscript_id} has no current holding")
    end
  end
end
