# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'shopping_list_manager'
  spec.version       = '0.1.0'
  spec.required_ruby_version = '>= 3.0'
  spec.summary       = 'CLI shopping list manager'
  spec.authors       = ['Batrakov Timofey']
  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.bindir        = 'bin'
  spec.executables   = ['shopping']

  spec.add_dependency 'json'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
