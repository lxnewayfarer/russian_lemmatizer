# frozen_string_literal: true

require 'redis'

# Russian lemmatizer. Transforming russian text to lemmas
#
class RussianLemmatizer
  # Initialize
  #
  # @param dictionary_path [String] Path to your dictionary
  # @param redis [Object] Redis instance
  def initialize(dictionary_path = './data/dict.opcorpora.txt', redis = nil)
    @dictionary_path = dictionary_path

    @redis = redis || Redis.new

    @dictionary_key = 'lemmas_dictionary'

    load_data_to_redis unless @redis.exists?(@dictionary_key)
  end

  # Loads data from dictionary to Redis for fasten access
  #
  def load_data_to_redis
    is_new_lemma = true
    current_lemma = ''

    File.foreach(@dictionary_path) do |line|
      word = line.split("\t")[0]

      if word.match?(/[0-9]/) || word == "\n"
        is_new_lemma = true
        next
      end

      if is_new_lemma
        current_lemma = word
        is_new_lemma = false
      end

      @redis.hmset(@dictionary_key, word, current_lemma)
    end
  end

  # Get lemma for certain word
  #
  # @param word [String] Word which you want to find lemma for
  # return [String] Lemma for this word
  def get_lemma(word_form)
    word_form = word_form.upcase

    @redis.hget(@dictionary_key, word_form) || word_form
  end

  # Tokenize sentence
  #
  # @param word form [String/Array] Sentence which is array or string separated with spaces
  # return [String] Array of words without any symbols
  def tokenize(word_form)
    word_form = word_form.split if word_form.is_a? String

    tokenized = []
    word_form.each do |word|
      word = word.upcase
      tokenized << word.scan(/[А-Я|Ё]+/)[0] if word.match?(/[А-Я|Ё]+/)
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

  # Clear Redis storage
  #

  def clear_storage
    @redis.del(@dictionary_key)
  end
end
