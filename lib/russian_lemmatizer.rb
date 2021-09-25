# frozen_string_literal: true

require 'redis'

# Russian lemmatizer. Transforming russian text to lemmas
#
class RussianLemmatizer
  # Initialize and loads data to redis if not loaded
  #
  # @param dictionary_path [String] Path to your dictionary
  # @param redis [Hash] Redis config
  def initialize(dictionary_path: './data/dict.opcorpora.txt', redis_config: nil)
    @dictionary_path = dictionary_path

    @redis = redis_config.nil? ? Redis.new : Redis.new(redis_config)

    @dictionary_key = 'lemmas_dictionary'

    load_data_to_redis unless @redis.exists?(@dictionary_key)
  end

  # Loads data from dictionary to Redis for fasten access
  #
  def load_data_to_redis
    is_new_lemma = true
    current_lemma = ''
    verbs = []

    File.foreach(@dictionary_path) do |line|
      word = line.split("\t")[0]
      word.gsub!('Ё', 'Е')
      word_info = line.split("\t")[1]

      if word.match?(/[0-9]/) || word == "\n"
        is_new_lemma = true
        next
      end

      if is_new_lemma
        current_lemma = word
        is_new_lemma = false
      end

      if word_info.include?('VERB')
        verbs << word
      elsif word_info.include?('INFN')
        verbs.each do |verb|
          @redis.hmset(@dictionary_key, verb, word)
        end
        verbs = []
      else
        @redis.hmset(@dictionary_key, word, current_lemma)
      end
    end
  end

  # Get lemma for certain word
  #
  # @param word [String] Word which you want to find lemma for
  # return [String] Lemma for this word
  def get_lemma(word_form)
    word_form = word_form.upcase.gsub('Ё', 'Е')

    @redis.hget(@dictionary_key, word_form) || word_form
  end

  # Tokenize sentence
  #
  # @param word form [String/Array] Sentence which is array or string separated with spaces
  # return [String] Array of words without any symbols
  def tokenize(word_form)
    word_form = word_form.split if word_form.is_a? String

    word_form.map! { |word| word.upcase.gsub('Ё', 'Е') }

    tokenized = []
    word_form.each do |word|
      word = word.upcase
      tokenized << word.scan(/[А-Я]+/)[0] if word.match?(/[А-Я]+/)
    end

    tokenized
  end

  # Find lemmas for sentence
  #
  # @param word form [String/Array] Sentence which is array or string separated with spaces
  # return [String] Array of lemmas for this sentence
  def lemmatize(word_form)
    word_form = tokenize(word_form)

    word_form.map { |word| get_lemma(word) }
  end

  # Clears Redis storage dictionary key
  #
  def clear_storage
    @redis.del(@dictionary_key)
  end
end
