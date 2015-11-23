# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mercure/version'

Gem::Specification.new do |spec|
  spec.name          = "mercure"
  spec.version       = Mercure::VERSION
  
  spec.homepage    = 'https://github.com/teriiehina/mercure'
  spec.license     = 'MIT'
  
  spec.date        = '2015-11-23'
  spec.summary     = "Build and distribute iOS app"
  spec.description = "A tool that works only with plist files"
  spec.authors     = ["Peter Meuel"]
  spec.email       = 'peter@teriiehina.net'
                    

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'rspec-mocks', '~> 3.3'
  spec.add_development_dependency 'simplecov', '~> 0'
  
  spec.add_runtime_dependency 'bundler', '~> 1.10'
  spec.add_runtime_dependency "rake", '~> 0'
  spec.add_runtime_dependency 'thor', '~> 0'
  spec.add_runtime_dependency 'plist', '~> 3.1'
  spec.add_runtime_dependency 'net-scp', '~> 1.2'
  spec.add_runtime_dependency 'parse-ruby-client', '~> 0'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6'
  spec.add_runtime_dependency 'CFPropertyList', '~> 2.3'
  spec.add_runtime_dependency 'xcpretty', '~> 0.1'
end
