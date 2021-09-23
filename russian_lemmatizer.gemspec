# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'russian_lemmatizer'
  s.version     = '0.1.0'
  s.summary     = 'Russian lemmatizer'
  s.description = 'Transforming russian text to lemmas'
  s.authors     = ['Andrey Dolgikh']
  s.email       = 'lxnewayfarer@yandex.ru'
  s.files       = ['lib/russian_lemmatizer.rb']
  s.homepage    =
    'https://rubygems.org/gems/russian_lemmatizer'
  s.license = 'MIT'
  s.required_ruby_version = '>= 2.6'
  s.requirements << 'redis'
end
