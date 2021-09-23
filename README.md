# Russian lemmatizer

Лемматизация — процесс приведения словоформы к лемме — её нормальной (словарной) форме.

## Принцип работы
Текст или слово очищается от знаков препинания и переводится в верхний регистр. Затем, эти словоформы находятся в хранилище Redis (подробнее в пункте "Зависимости"), где они хранятся в виде ключ-значение, где ключ - это словоформа, а значение - его лемма, то есть начальная форма.

## Использование
Для использования, необходимо создать экземпляр класса. Далее доступны методы lemmatize - приведение к нормальной форме предложения, представленного в виде строки или массива, tokenize - очистка строки или массива от знаков препинания и get_lemma - получение леммы для одного русского слова. Пример:
```
lemmatizer = RussianLemmatizer.new

lemmatizer.lemmatize("Лемматизация — процесс приведения словоформы к лемме — её нормальной (словарной) форме.")
> ["ЛЕММАТИЗАЦИЯ", "ПРОЦЕСС", "ПРИВЕДЕНИЕ", "СЛОВОФОРМА", "К", "ЛЕММА", "ОНА", "НОРМАЛЬНЫЙ", "СЛОВАРНЫЙ", "ФОРМА"]
```

## Зависимости
Так как средство рассчитано под большой объем данных в словаре, для быстрого доступа к данным используется Redis. Класс использует хост и порт по умолчанию *localhost:6379*. Есть возможность создать класс со своим экземпляром Redis:
```
redis = Redis.new(port: 5555)

lemmatizer = RussianLemmatizer.new(redis = redis)
```
Благодаря использованию Redis, лемматизация текста в 1000 слов происходит в среднем за 0.2 сек. В то время как лемматизация лишь одного слова при поиске по текстовому файлу займет до 8 сек.
При создании класса, проверяется наличие ключа в Redis. Если ключ отсутствуют, то данные подгружаются из текстового словаря. Этот процесс может занять некоторое время. 

## Где взять словарь
OpenCorpora — это проект по созданию размеченного корпуса текстов силами сообщества. Корпус будет доступен бесплатно и в полном объёме (под лицензией CC-BY-SA). 

http://opencorpora.org/dict.php

Для использования этого корпуса, необходимо скачать текстовый вариант, и при создании экземпляра, указать путь до словаря:
```
lemmatizer = RussianLemmatizer.new(dictionary_path = "./data/dict.opcorpora.txt")
```