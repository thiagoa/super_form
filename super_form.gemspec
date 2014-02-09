# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'super_form/version'

Gem::Specification.new do |spec|
  spec.name          = "super_form"
  spec.version       = SuperForm::VERSION
  spec.authors       = ["Thiago A. Silva"]
  spec.email         = ["thiagoaraujos@gmail.com"]
  spec.summary       = 'Object oriented forms for Rails'
  spec.description   = 'Super Form adopts the concept of forms and fields, making it easy to define fields containing bundled validations and attributes. Also, it aims to supply a handy form builder for these fields.'
  spec.homepage      = "http://github.com/thiagoa/super_form"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "sqlite3", '1.3.8'
  spec.add_development_dependency 'virtus', '1.0.1'
  spec.add_development_dependency 'pry-rails', '0.3.2'
  spec.add_development_dependency 'rspec', '2.14.1'
  spec.add_development_dependency 'simplecov', '0.8.2'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'capybara', '2.2.0'
  spec.add_development_dependency 'activemodel', '4.0.2'
  spec.add_development_dependency 'activesupport', '4.0.2'
  spec.add_development_dependency 'cpf_cnpj', '0.2.0'
  spec.add_development_dependency 'validates_email_format_of', '1.5.3'
end
