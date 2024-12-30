# frozen_string_literal: true

require 'representable/json'

module DigitalScriptorium
  class SolrDocumentRepresenter < Representable::Decorator
    include Representable::JSON
  end
end
