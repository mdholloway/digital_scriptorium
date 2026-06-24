# frozen_string_literal: true

# Top-level namespace for the Digital Scriptorium gem
module DigitalScriptorium
end

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
# TODO: v1.0 – Fix transformer class namespacing quirk.
# Transformer classes (e.g., NameClaimTransformer) currently live in
# lib/digital_scriptorium/transformers/*.rb but are defined as
# DigitalScriptorium::NameClaimTransformer, NOT
# DigitalScriptorium::Transformers::NameClaimTransformer.
# The collapse call below works around this mismatch for Zeitwerk.
# For 1.0, move the classes into the proper
# DigitalScriptorium::Transformers namespace and remove the collapse.
loader.collapse("#{__dir__}/digital_scriptorium/transformers")
loader.setup
