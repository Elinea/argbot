require 'rake'

Gem::Specification.new do |s|
  s.name         =  'argbot'
  s.version      =  '0.3.4'
  s.date         =  '2012-06-24'
  s.license	 =  'MIT'
  s.homepage     =  'http://stratosphe.re'
  s.summary      =  'A bot for VALVE ARGs'
  s.description  =  'ARGBot is a very useful bot for ARG solvers.'
  s.authors      =  ['Morgan Jones']
  s.email        =  'integ3rs@gmail.com'
  s.files        =  FileList['lib/argbot.rb', 'lib/argbot/*.rb', 'lib/argbot/cmd/*.rb'].to_a
  s.has_rdoc     = false
  s.add_dependency 'cinch'
  s.add_dependency 'json'
  s.add_dependency 'fakefs'
end