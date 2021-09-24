# frozen_string_literal: true

require 'russian_lemmatizer'

# Set up Redis config
redis_config = {
  host: '127.0.0.1',
  port: 6379
}

# Set up dictionary path
dictionary_path = './data/dict.opcorpora.txt'

# Create lemmatizer instance with our parameters
lemmatizer = RussianLemmatizer.new(dictionary_path: dictionary_path, redis_config: redis_config)

puts lemmatizer.get_lemma('рубиновая')
# > РУБИНОВЫЙ

puts lemmatizer.get_lemma('Вальсу')
# > ВАЛЬС

puts lemmatizer.get_lemma('Сделала')
# > СДЕЛАТЬ

puts lemmatizer.lemmatize('Ивану показали красные листья.')
# > ИВАН ПОКАЗАТЬ КРАСНЫЙ ЛИСТ
