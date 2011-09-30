# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'silk_icons/version'

Gem::Specification.new do |s|
  s.name = 'silk_icons'
  s.version = SilkIcons::VERSION
  s.authors = ['Mark James', 'OZAWA Sakuro']
  s.email = ['mjames@gmail.com', 'sakuro@2238club.org']
  s.homepage = 'http://github.com/sakuro/silk_icons'
  s.summary = 'A fancy free icon collection'
  s.description = <<-DESC.gsub(/^  /, '')
  The Silk icon set is a collection of 1,000 16x16 PNG icons created by Mark James.
  This gem provides access to the icons as Rails assets.
  DESC
  s.rubyforge_project = '(n/a)'

  s.files = `git ls-files`.split("\n")
  s.required_ruby_version = '~> 1.9.2' # Note that dev tasks require ~> 1.9.3
  s.add_dependency('rails', '~> 3.1.0')
end
