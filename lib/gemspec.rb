#!/usr/bin/env ruby
require File.expand_path('../../vendor/refinerycms/refinery.rb', __FILE__)
files = %w( .gitignore .yardopts Gemfile ).map { |file| Dir[file] }.flatten
%w(app bin config db features lib public script test themes vendor).sort.each do |dir|
  files += Dir.glob("#{dir}/**/*")
end
rejection_patterns = [
  "public\/system",
  "^config\/(application|boot|environment).rb$",
  "^config\/environments",
  "^config\/initializers\/(backtrace_silencers|inflections|mime_types|secret_token|session_store).rb$",
  "^config\/(cucumber|database|i18n\-js).yml$",
  "^public\/",
  "^lib\/gemspec\.rb",
  "^lib\/tasks",
  ".*\/cache\/",
  "^db\/.*\.sqlite3?$",
  "^features\/?",
  "^script\/*",
  "^vendor\/plugins\/?$",
  "\.log$",
  "\.rbc$"
]

files.reject! do |f|
  !File.exist?(f) or f =~ %r{(#{rejection_patterns.join(')|(')})}
end

gemspec = <<EOF
Gem::Specification.new do |s|
  s.name              = %q{refinerycms}
  s.version           = %q{#{Refinery.version}}
  s.description       = %q{A beautiful open source Ruby on Rails content manager for small business. Easy to extend, easy to use, lightweight and all wrapped up in a super slick UI.}
  s.date              = %q{#{Time.now.strftime('%Y-%m-%d')}}
  s.summary           = %q{A beautiful open source Ruby on Rails content manager for small business.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Resolve Digital', 'David Jones', 'Philip Arndt']
  s.require_paths     = %w(vendor/refinerycms)
  s.executables       = %w(#{Dir.glob('bin/*').map{|d| d.gsub('bin/','')}.join(' ')})

  s.add_dependency    'rails',            '~> 3.0.0.rc2'
  s.add_dependency    'bundler',          '~> 1.0.0'
  s.add_dependency    'childlabor'

  s.add_dependency    'acts_as_indexed',  '= 0.6.5'
  s.add_dependency    'friendly_id',      '~> 3.1.3'
  s.add_dependency    'truncate_html',    '= 0.4'
  s.add_dependency    'will_paginate',    '>= 3.0.pre2'
  s.add_dependency    'authlogic',        '~> 2.1.6'
  s.add_dependency    'rmagick'
  s.add_dependency    'rack-cache'
  s.add_dependency    'dragonfly'

  s.files             = [
    '#{files.join("',\n    '")}'
  ]
end
EOF

File.open(File.expand_path("../../refinerycms.gemspec", __FILE__), 'w').puts(gemspec)
