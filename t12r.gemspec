# -*- coding: utf-8 -*-
require 'English'

VERSION = File.read(File.join(File.dirname(__FILE__), 'Cargo.toml')).match(/^version = "(.*?)"$/m).group(1)

Gem::Specification.new do |s|
  s.name    = 't12r'
  s.version = VERSION
  s.authors = ['Mark Lee']
  s.email   = ['Mark.Lee@infogroup.com']
  s.summary = 'Rust-based speedup for transliterating Unicode characters into ASCII.'
  s.license = 'Apache-2.0'

  s.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  s.require_paths = %w(lib)

  s.extensions << 'ext/Rakefile'

  s.add_runtime_dependency 'thermite', '~> 0.10'
end
