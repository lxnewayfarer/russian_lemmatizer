# frozen_string_literal: true

require 'russian_lemmatizer'

describe RussianLemmatizer do
  let(:lemmatizer) { RussianLemmatizer.new }

  it 'should tokenize properly' do
    expect(lemmatizer.tokenize('Приветы ребятам!')).to eq(%w[ПРИВЕТЫ РЕБЯТАМ])
  end

  it 'should find lemma' do
    expect(lemmatizer.get_lemma('кислое')).to eq('КИСЛЫЙ')
  end

  it 'should lemmatize fine' do
    expect(lemmatizer.lemmatize('Приветы ребятам!')).to eq(%w[ПРИВЕТ РЕБЯТА])
  end
end
