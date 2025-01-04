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
  spec.required_ruby_version = '>= 3.0.0'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'multi_json', '~> 1.15'
  spec.add_dependency 'representable', '~> 3.2'
  spec.add_dependency 'tty-spinner', '~> 0.9'
  spec.add_dependency 'wikibase_representable', '~> 0.1'
end
