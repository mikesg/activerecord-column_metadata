# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/column_metadata/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-column_metadata"
  spec.version       = ActiveRecord::ColumnMetadata::VERSION
  spec.authors       = ["Sava Chankov", "Tsanka Encheva"]
  spec.email         = ["sava@tutuf.com", "tsanka@tutuf.com"]
  spec.description   = %q{ActiveRecord extension to store column metadata in database as comments on columns}
  spec.summary       = %q{ActiveRecord extension to store column metadata in database}
  spec.homepage      = "http://github.com/tutuf/activerecord-column_metadata"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">=4.0.0"
  spec.add_dependency "pg"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "database_cleaner"
end
