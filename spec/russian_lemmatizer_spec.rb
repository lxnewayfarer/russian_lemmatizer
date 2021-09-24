# frozen_string_literal: true

require 'russian_lemmatizer'

describe RussianLemmatizer do
  let(:lemmatizer) { RussianLemmatizer.new }

  context '#tokenize' do
    it 'should tokenize properly' do
      expect(lemmatizer.tokenize('Приветы ребятам!')).to eq(%w[ПРИВЕТЫ РЕБЯТАМ])
      expect(lemmatizer.tokenize('вальс, танго - окно')).to eq(%w[ВАЛЬС ТАНГО ОКНО])
    end
  end

  context '#get_lemma' do
    it 'should find lemma for ajective' do
      expect(lemmatizer.get_lemma('кислое')).to eq('КИСЛЫЙ')
      expect(lemmatizer.get_lemma('Оконная')).to eq('ОКОННЫЙ')
      expect(lemmatizer.get_lemma('сТрАнноЕ')).to eq('СТРАННЫЙ')
      expect(lemmatizer.get_lemma('прекрасные')).to eq('ПРЕКРАСНЫЙ')
      expect(lemmatizer.get_lemma('рубиновый')).to eq('РУБИНОВЫЙ')
    end

    it 'should find lemma for noun' do
      expect(lemmatizer.get_lemma('указание')).to eq('УКАЗАНИЕ')
      expect(lemmatizer.get_lemma('окна')).to eq('ОКНО')
      expect(lemmatizer.get_lemma('вальсу')).to eq('ВАЛЬС')
      expect(lemmatizer.get_lemma('Лекцию')).to eq('ЛЕКЦИЯ')
      expect(lemmatizer.get_lemma('деревом')).to eq('ДЕРЕВО')
      expect(lemmatizer.get_lemma('зНамени')).to eq('ЗНАМЯ')
    end

    it 'should find lemma for verb' do
      expect(lemmatizer.get_lemma('указать')).to eq('УКАЗАТЬ')
      expect(lemmatizer.get_lemma('выполнила')).to eq('ВЫПОЛНИТЬ')
      expect(lemmatizer.get_lemma('сделает')).to eq('СДЕЛАТЬ')
      expect(lemmatizer.get_lemma('усреднил')).to eq('УСРЕДНИТЬ')
    end
  end

  context '#lemmatize' do
    it 'should lemmatize fine' do
      expect(lemmatizer.lemmatize('Приветы всем ребятам!')).to eq(%w[ПРИВЕТ ВЕСЬ РЕБЯТА])
      expect(lemmatizer.lemmatize('Она слушала музыку.')).to eq(%w[ОНА СЛУШАТЬ МУЗЫКА])
      expect(lemmatizer.lemmatize('Ивану показали красные листья.')).to eq(%w[ИВАН ПОКАЗАТЬ КРАСНЫЙ ЛИСТ])
    end
  end
end
