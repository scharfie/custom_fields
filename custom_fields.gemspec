# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'custom_fields/version'

Gem::Specification.new do |spec|
  spec.name          = "custom_fields"
  spec.version       = CustomFields::VERSION
  spec.authors       = ["Chris Scharf"]
  spec.email         = ["scharfie@gmail.com"]

  spec.summary       = %q(Simple custom fields for Active Record, stored in separate table, serialized in JSON)
  spec.description   = %q(Simple custom fields for Active Record, stored in separate table, serialized in JSON)
  spec.homepage      = "https://github.com/scharfie/custom_fields"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_runtime_dependency("railties", ">= 3.0.0")
  spec.add_runtime_dependency("activerecord", ">= 3.0.0")
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sqlite3"
end
