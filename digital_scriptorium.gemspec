# frozen_string_literal: true

require_relative 'lib/digital_scriptorium/version'

Gem::Specification.new do |spec|
  spec.name = 'digital_scriptorium'
  spec.version = DigitalScriptorium::VERSION
  spec.authors = ['Michael Holloway']
  spec.email = ['michael@mdholloway.org']

  spec.summary = 'Supporting code for the Digital Scriptorium DS Catalog 2.0 project'
  spec.homepage = 'https://github.com/mdholloway/digital_scriptorium'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.glob('{lib,sig,doc}/**/*', File::FNM_DOTMATCH)
                  .select { |f| File.file?(f) } +
               %w[README.md LICENSE.txt digital_scriptorium.gemspec]
  spec.require_paths = ['lib']

  spec.add_dependency 'wikibase_representable', '~> 0.1'
  spec.add_dependency 'zeitwerk', '~> 2.6'
end
