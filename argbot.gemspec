require 'rake'

Gem::Specification.new do |s|
  s.name         =  'argbot'
  s.version      =  '0.2.0'
  s.date         =  '2012-06-23'
  s.license	 =  'MIT'
  s.homepage     =  'http://stratosphe.re'
  s.summary      =  'A bot for VALVE ARGs'
  s.description  =  'ARGBot is a very useful for ARG solvers.'
  s.authors      =  ['Morgan Jones']
  s.email        =  'integ3rs@gmail.com'
  s.files        =  FileList['lib/argbot.rb'].to_a
  s.has_rdoc     = false
  s.add_dependency 'cinch'
end