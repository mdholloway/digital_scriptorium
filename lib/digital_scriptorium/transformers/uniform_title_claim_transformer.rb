# frozen_string_literal: true

module DigitalScriptorium
  # Base transformer class providing a common interface for all transformers.
  class UniformTitleClaimTransformer < BaseClaimTransformer
    PREFIX = 'uniform_title'

    def initialize(claim, _)
      super(claim, prefix: PREFIX)
    end

    def search_values
      [@claim.data_value]
    end
  end
end
