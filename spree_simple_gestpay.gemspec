# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_simple_gestpay/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_simple_gestpay'
  s.version     = SpreeSimpleGestpay.version
  s.summary     = 'Banca Sella Gestpay unofficial gateway for Spree'
  s.description = 'It supports only "direct" payment method'
  s.required_ruby_version = '>= 2.2.2'

  s.author    = 'Fabrizio Monti'
  s.email     = 'fabrizio.monti@welaika.com'
  s.homepage  = 'https://github.com/welaika/spree_simple_gestpay'
  s.license = 'BSD-3-Clause'

  s.files = `git ls-files`.split("\n")
  # s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 3.1.0', '< 4.0'
  s.add_dependency 'simple_gestpay'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-screenshot'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  # s.add_development_dependency 'pg'
  # s.add_development_dependency 'mysql2'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'appraisal'
end
