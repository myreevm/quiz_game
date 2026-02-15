import 'package:flutter/widgets.dart';

import 'app_settings.dart';

class AppTexts {
  final AppLanguage language;

  const AppTexts(this.language);

  static AppTexts of(BuildContext context) {
    final settings = AppSettingsScope.of(context).settings;
    return AppTexts(settings.appLanguage);
  }

  String _select({
    required String en,
    required String ru,
    required String yakut,
  }) {
    switch (language) {
      case AppLanguage.english:
        return en;
      case AppLanguage.russian:
        return ru;
      case AppLanguage.yakut:
        return yakut;
    }
  }

  String get appTitle => 'Quiz Game';

  String languageName(AppLanguage value) {
    switch (value) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.russian:
        return 'Русский';
      case AppLanguage.yakut:
        return 'Саха тыла';
    }
  }

  String get mainMenuTitle => _select(
        en: 'Main Menu',
        ru: 'Главное меню',
        yakut: 'Сүрүн меню',
      );

  String get mainMenuHeaderDescription => _select(
        en: 'Test your knowledge by categories, countries, and regions.',
        ru: 'Проверьте знания по категориям, странам и регионам.',
        yakut: 'Категория, дойду уонна регионан билиини бэрэктээ.',
      );

  String get mainMenuTagCategories => _select(
        en: 'Categories',
        ru: 'Категории',
        yakut: 'Категориялар',
      );

  String get mainMenuTagProgress => _select(
        en: 'Progress',
        ru: 'Прогресс',
        yakut: 'Сайдыы',
      );

  String get mainMenuTagResults => _select(
        en: 'Results',
        ru: 'Результаты',
        yakut: 'Түмүктэр',
      );

  String get playActionTitle => _select(
        en: 'Play',
        ru: 'Играть',
        yakut: 'Оонньоо',
      );

  String get playActionSubtitle => _select(
        en: 'Start a new quiz',
        ru: 'Начать новую викторину',
        yakut: 'Саҥа викторинаны саҕалаа',
      );

  String get settingsActionTitle => _select(
        en: 'Settings',
        ru: 'Настройки',
        yakut: 'Туруоруулар',
      );

  String get settingsActionSubtitle => _select(
        en: 'Theme, sound, and game options',
        ru: 'Тема, звук и параметры игры',
        yakut: 'Тиэмэ, тыаһы уонна оонньуу туруоруулара',
      );

  String get aboutActionTitle => _select(
        en: 'About',
        ru: 'Об игре',
        yakut: 'Оонньуу туһунан',
      );

  String get aboutActionSubtitle => _select(
        en: 'Description, modes, and tips',
        ru: 'Описание, режимы и советы',
        yakut: 'Сүрүн сирэ, режимдара уонна сүбэлэр',
      );

  String get suggestActionTitle => _select(
        en: 'Suggest a question',
        ru: 'Предложить вопрос',
        yakut: 'Ыйытыыны сүбэлээ',
      );

  String get suggestActionSubtitle => _select(
        en: 'Instagram, Telegram, or Gmail',
        ru: 'Instagram, Telegram или Gmail',
        yakut: 'Instagram, Telegram эбэтэр Gmail',
      );

  String get exitActionTitle => _select(
        en: 'Exit',
        ru: 'Выйти',
        yakut: 'Таһаар',
      );

  String get exitDialogTitle => _select(
        en: 'Exit',
        ru: 'Выход',
        yakut: 'Таһаарыы',
      );

  String get exitDialogMessage => _select(
        en: 'Close the app?',
        ru: 'Закрыть приложение?',
        yakut: 'Приложение туттарга дуо?',
      );

  String get cancelButton => _select(
        en: 'Cancel',
        ru: 'Отмена',
        yakut: 'Салҕама',
      );

  String get confirmExitButton => _select(
        en: 'Exit',
        ru: 'Выйти',
        yakut: 'Таһаар',
      );

  String get settingsTitle => _select(
        en: 'Settings',
        ru: 'Настройки',
        yakut: 'Туруоруулар',
      );

  String get settingsDarkThemeTitle => _select(
        en: 'Dark theme',
        ru: 'Тёмная тема',
        yakut: 'Хараҥа тиэмэ',
      );

  String get settingsDarkThemeSubtitle => _select(
        en: 'Enable dark appearance',
        ru: 'Включить тёмное оформление приложения',
        yakut: 'Хараҥа безиири холбоо',
      );

  String get settingsSoundTitle => _select(
        en: 'Sound',
        ru: 'Звук',
        yakut: 'Тыаһа',
      );

  String get settingsSoundSubtitle => _select(
        en: 'Enable sound effects',
        ru: 'Включить звуковые эффекты',
        yakut: 'Тыаһынан эффектары холбоо',
      );

  String get settingsShuffleQuestionsTitle => _select(
        en: 'Shuffle questions',
        ru: 'Перемешивать вопросы',
        yakut: 'Ыйытыылары бутаа',
      );

  String get settingsShuffleQuestionsSubtitle => _select(
        en: 'Change question order before each game',
        ru: 'Менять порядок вопросов перед началом игры',
        yakut: 'Оонньууттан иннин ыйытыы иһинэн уларыт',
      );

  String get settingsShuffleAnswersTitle => _select(
        en: 'Shuffle answers',
        ru: 'Перемешивать варианты ответов',
        yakut: 'Эппиэти бутаа',
      );

  String get settingsShuffleAnswersSubtitle => _select(
        en: 'Randomize answer options in each question',
        ru: 'Менять порядок ответов внутри каждого вопроса',
        yakut: 'Хас биирдии ыйытыыга эппиэт тардыытын уларыт',
      );

  String get settingsQuestionsPerRoundTitle => _select(
        en: 'Questions per round',
        ru: 'Вопросов за раунд',
        yakut: 'Түөрт оонньууга ыйытыылар',
      );

  String get settingsQuestionsPerRoundSubtitle => _select(
        en: 'How many questions to show in one game',
        ru: 'Сколько вопросов показывать за одну игру',
        yakut: 'Биир оонньууга хас ыйытыы көстөрүн туруор',
      );

  String get settingsLanguageTitle => _select(
        en: 'Language',
        ru: 'Язык',
        yakut: 'Тыл',
      );

  String get settingsLanguageSubtitle => _select(
        en: 'Select app interface language',
        ru: 'Выберите язык интерфейса',
        yakut: 'Интерфейс тылын тал',
      );

  String get countrySelectionTitle => _select(
        en: 'Choose country',
        ru: 'Выбор страны',
        yakut: 'Дойдуну тал',
      );

  String get countrySelectionHeaderTitle => _select(
        en: 'Where do we start?',
        ru: 'С чего начнем?',
        yakut: 'Ханнык саҕалыахпытый?',
      );

  String get countrySelectionHeaderDescription => _select(
        en: 'Choose a country, then region and category, or start Quick Game.',
        ru: 'Выберите страну, затем регион и категорию. Или нажмите "Быстрая игра", чтобы запустить случайный раунд.',
        yakut:
            'Дойдуну, онтон региону уонна категорияны тал. Эбэтэр "Түргэн оонньуу" баттаа уонна түөстээх раунду саҕалаа.',
      );

  String get quickGameTitle => _select(
        en: 'Quick Game',
        ru: 'Быстрая игра',
        yakut: 'Түргэн оонньуу',
      );

  String get quickGameLoadingTitle => _select(
        en: 'Preparing random game...',
        ru: 'Подбор случайной игры...',
        yakut: 'Түөстээх оонньууну талабыт...',
      );

  String get quickGameNoQuestions => _select(
        en: 'No questions found for Quick Game.',
        ru: 'Не удалось найти вопросы для быстрой игры.',
        yakut: 'Түргэн оонньууга ыйытыылар булуллубатылар.',
      );

  String quickGameStarted({
    required String country,
    required String region,
    required String category,
  }) {
    return _select(
      en: 'Quick Game: $country, $region, $category',
      ru: 'Быстрая игра: $country, $region, $category',
      yakut: 'Түргэн оонньуу: $country, $region, $category',
    );
  }

  String get countryMapHint => _select(
        en: 'Tap a country on the map',
        ru: '\u041d\u0430\u0436\u043c\u0438\u0442\u0435 \u043d\u0430 \u0441\u0442\u0440\u0430\u043d\u0443 \u043d\u0430 \u043a\u0430\u0440\u0442\u0435',
        yakut:
            '\u041a\u0430\u0440\u0442\u0430\u0495\u0430 \u0434\u043e\u0439\u0434\u0443\u043d\u0443 \u0431\u0430\u0442\u0442\u0430\u0430',
      );

  String get regionMapHint => _select(
        en: 'Tap a region on the map',
        ru: '\u041d\u0430\u0436\u043c\u0438\u0442\u0435 \u043d\u0430 \u0440\u0435\u0433\u0438\u043e\u043d \u043d\u0430 \u043a\u0430\u0440\u0442\u0435',
        yakut:
            '\u041a\u0430\u0440\u0442\u0430\u0495\u0430 \u0440\u0435\u0433\u0438\u043e\u043d\u0443 \u0431\u0430\u0442\u0442\u0430\u0430',
      );

  String get countrySortLabel => _select(
        en: 'Sort countries',
        ru: '\u0421\u043e\u0440\u0442\u0438\u0440\u043e\u0432\u043a\u0430 \u0441\u0442\u0440\u0430\u043d',
        yakut:
            '\u0414\u043e\u0439\u0434\u0443\u043b\u0430\u0440 \u043d\u0430\u0430\u0440\u0434\u0430\u0430\u04bb\u044b\u043d\u0430',
      );

  String get countrySortAlphabet => _select(
        en: 'Alphabetical',
        ru: '\u041f\u043e \u0430\u043b\u0444\u0430\u0432\u0438\u0442\u0443',
        yakut:
            '\u0410\u043b\u043f\u0430\u0430\u0432\u044b\u0442\u044b\u043d\u0430\u043d',
      );

  String get countrySortArea => _select(
        en: 'By area',
        ru: '\u041f\u043e \u0440\u0430\u0437\u043c\u0435\u0440\u0443',
        yakut: '\u041a\u044d\u044d\u043c\u044d\u0439\u0438\u043d\u044d\u043d',
      );

  String countryName(String code) {
    switch (code) {
      case 'russia':
        return _select(en: 'Russia', ru: 'Russia', yakut: 'Russia');
      case 'usa':
        return _select(en: 'USA', ru: 'USA', yakut: 'USA');
      case 'canada':
        return _select(
          en: 'Canada',
          ru: '\u041a\u0430\u043d\u0430\u0434\u0430',
          yakut: '\u041a\u0430\u043d\u0430\u0434\u0430',
        );
      case 'mexico':
        return _select(
          en: 'Mexico',
          ru: '\u041c\u0435\u043a\u0441\u0438\u043a\u0430',
          yakut: '\u041c\u0435\u043a\u0441\u0438\u043a\u0430',
        );
      case 'china':
        return _select(en: 'China', ru: 'China', yakut: 'China');
      case 'japan':
        return _select(
          en: 'Japan',
          ru: '\u042f\u043f\u043e\u043d\u0438\u044f',
          yakut: '\u042f\u043f\u043e\u043d\u0438\u044f',
        );
      case 'vietnam':
        return _select(
          en: 'Vietnam',
          ru: '\u0412\u044c\u0435\u0442\u043d\u0430\u043c',
          yakut: '\u0412\u044c\u0435\u0442\u043d\u0430\u043c',
        );
      case 'poland':
        return _select(en: 'Poland', ru: 'Poland', yakut: 'Poland');
      case 'france':
        return _select(en: 'France', ru: 'France', yakut: 'France');
      case 'australia':
        return _select(en: 'Australia', ru: 'Australia', yakut: 'Australia');
      case 'egypt':
        return _select(en: 'Egypt', ru: 'Egypt', yakut: 'Egypt');
      case 'brazil':
        return _select(en: 'Brazil', ru: 'Brazil', yakut: 'Brazil');
      case 'uk':
        return _select(
          en: 'United Kingdom',
          ru: 'United Kingdom',
          yakut: 'United Kingdom',
        );
      default:
        return code.toUpperCase();
    }
  }

  String countrySelectionSubtitle(String code) {
    switch (code) {
      case 'russia':
        return _select(
          en: 'Questions by country and regions',
          ru: 'Questions by country and regions',
          yakut: 'Questions by country and regions',
        );
      case 'usa':
        return _select(
          en: 'Categories about USA and states',
          ru: 'Categories about USA and states',
          yakut: 'Categories about USA and states',
        );
      case 'canada':
        return _select(
          en: 'Canada: history, cinema, music, and notable people',
          ru: '\u041a\u0430\u043d\u0430\u0434\u0430: \u0438\u0441\u0442\u043e\u0440\u0438\u044f, \u043a\u0438\u043d\u043e, \u043c\u0443\u0437\u044b\u043a\u0430 \u0438 \u0438\u0437\u0432\u0435\u0441\u0442\u043d\u044b\u0435 \u043b\u044e\u0434\u0438',
          yakut:
              '\u041a\u0430\u043d\u0430\u0434\u0430: \u0438\u0441\u0442\u043e\u0440\u0438\u044f, \u043a\u0438\u043d\u043e, \u043c\u0443\u0437\u044b\u043a\u0430 \u0438 \u0438\u0437\u0432\u0435\u0441\u0442\u043d\u044b\u0435 \u043b\u044e\u0434\u0438',
        );
      case 'mexico':
        return _select(
          en: 'Mexico: history, culture, movies, and music',
          ru: '\u041c\u0435\u043a\u0441\u0438\u043a\u0430: \u0438\u0441\u0442\u043e\u0440\u0438\u044f, \u043a\u0443\u043b\u044c\u0442\u0443\u0440\u0430, \u043a\u0438\u043d\u043e \u0438 \u043c\u0443\u0437\u044b\u043a\u0430',
          yakut:
              '\u041c\u0435\u043a\u0441\u0438\u043a\u0430: \u0438\u0441\u0442\u043e\u0440\u0438\u044f, \u043a\u0443\u043b\u044c\u0442\u0443\u0440\u0430, \u043a\u0438\u043d\u043e \u0438 \u043c\u0443\u0437\u044b\u043a\u0430',
        );
      case 'china':
        return _select(
          en: 'History, culture, and modern facts',
          ru: 'History, culture, and modern facts',
          yakut: 'History, culture, and modern facts',
        );
      case 'japan':
        return _select(
          en: 'Japan: history, cinema, anime, and music',
          ru: '\u042f\u043f\u043e\u043d\u0438\u044f: \u0438\u0441\u0442\u043e\u0440\u0438\u044f, \u043a\u0438\u043d\u043e, \u0430\u043d\u0438\u043c\u0435 \u0438 \u043c\u0443\u0437\u044b\u043a\u0430',
          yakut:
              '\u042f\u043f\u043e\u043d\u0438\u044f: \u0438\u0441\u0442\u043e\u0440\u0438\u044f, \u043a\u0438\u043d\u043e, \u0430\u043d\u0438\u043c\u0435 \u0438 \u043c\u0443\u0437\u044b\u043a\u0430',
        );
      case 'vietnam':
        return _select(
          en: 'Vietnam: history, culture, movies, and music',
          ru: '\u0412\u044c\u0435\u0442\u043d\u0430\u043c: \u0438\u0441\u0442\u043e\u0440\u0438\u044f, \u043a\u0443\u043b\u044c\u0442\u0443\u0440\u0430, \u043a\u0438\u043d\u043e \u0438 \u043c\u0443\u0437\u044b\u043a\u0430',
          yakut:
              '\u0412\u044c\u0435\u0442\u043d\u0430\u043c: \u0438\u0441\u0442\u043e\u0440\u0438\u044f, \u043a\u0443\u043b\u044c\u0442\u0443\u0440\u0430, \u043a\u0438\u043d\u043e \u0438 \u043c\u0443\u0437\u044b\u043a\u0430',
        );
      case 'poland':
        return _select(
          en: 'Questions about Poland and famous people',
          ru: 'Questions about Poland and famous people',
          yakut: 'Questions about Poland and famous people',
        );
      case 'france':
        return _select(
          en: 'History, cinema, music, and personalities',
          ru: 'History, cinema, music, and personalities',
          yakut: 'History, cinema, music, and personalities',
        );
      case 'australia':
        return _select(
          en: 'History, people, movies, and music of Australia',
          ru: 'History, people, movies, and music of Australia',
          yakut: 'History, people, movies, and music of Australia',
        );
      case 'egypt':
        return _select(
          en: 'Ancient history, culture, cinema, and music',
          ru: 'Ancient history, culture, cinema, and music',
          yakut: 'Ancient history, culture, cinema, and music',
        );
      case 'brazil':
        return _select(
          en: 'Brazilian history, famous people, films, and music',
          ru: 'Brazilian history, famous people, films, and music',
          yakut: 'Brazilian history, famous people, films, and music',
        );
      case 'uk':
        return _select(
          en: 'United Kingdom: history, cinema, music, and famous people',
          ru: 'United Kingdom: history, cinema, music, and famous people',
          yakut: 'United Kingdom: history, cinema, music, and famous people',
        );
      default:
        return code;
    }
  }

  String get regionSelectionTitle => _select(
        en: 'Choose region',
        ru: 'Выбор региона',
        yakut: 'Региону тал',
      );

  String get regionSelectionHeaderTitle => _select(
        en: 'Choose region',
        ru: 'Выберите регион',
        yakut: 'Региону тал',
      );

  String regionSelectionCountryLabel(String countryName) {
    return _select(
      en: 'Country: $countryName',
      ru: 'Страна: $countryName',
      yakut: 'Дойду: $countryName',
    );
  }

  String get regionSelectionHeaderDescription => _select(
        en: 'You can play for the whole country or specific regions.',
        ru: 'Можно играть как по всей стране, так и по отдельным регионам.',
        yakut: 'Бүтүн дойдуунан эбэтэр араас регионунан оонньуурга сөп.',
      );

  String get regionAllCountryTitle => _select(
        en: 'Whole country',
        ru: 'Вся страна',
        yakut: 'Бүтүн дойду',
      );

  String get regionAllCountrySubtitle => _select(
        en: 'Questions without selecting a specific region',
        ru: 'Вопросы без выбора конкретного региона',
        yakut: 'Бэйэ региону талбакка ыйытыылар',
      );

  String regionName(String code) {
    switch (code) {
      case 'all':
        return regionAllCountryTitle;
      case 'yakutia':
        return _select(en: 'Yakutia', ru: 'Якутия', yakut: 'Саха Сирэ');
      case 'dagestan':
        return _select(en: 'Dagestan', ru: 'Дагестан', yakut: 'Дагыстан');
      case 'texas':
        return _select(en: 'Texas', ru: 'Техас', yakut: 'Техас');
      case 'oklahoma':
        return _select(en: 'Oklahoma', ru: 'Оклахома', yakut: 'Оклахома');
      default:
        return code;
    }
  }

  String regionSubtitle({
    required String country,
    required String region,
  }) {
    switch ('$country/$region') {
      case 'russia/yakutia':
        return _select(
          en: 'Northern region with rich history',
          ru: 'Северный регион с богатой историей',
          yakut: 'Хотуу сирдээх бай тарихтаах регион',
        );
      case 'russia/dagestan':
        return _select(
          en: 'Culture, traditions, and famous events',
          ru: 'Культура, традиции и известные события',
          yakut: 'Культура, үгэ уонна биллэр буолбут түһүмэхтэр',
        );
      case 'usa/texas':
        return _select(
          en: 'History and culture of one of the largest states',
          ru: 'История и культура одного из крупнейших штатов',
          yakut: 'Улахан штаттар биирдэстэрин историята уонна культурата',
        );
      case 'usa/oklahoma':
        return _select(
          en: 'Facts about music, cinema, and state history',
          ru: 'Факты о музыке, кино и прошлом штата',
          yakut: 'Штат историята, ырыата уонна киното туһунан фактылар',
        );
      default:
        return region;
    }
  }

  String get categorySelectionTitle => _select(
        en: 'Choose category',
        ru: 'Выбор категории',
        yakut: 'Категорияны тал',
      );

  String get categorySelectionHeaderTitle => _select(
        en: 'Choose category',
        ru: 'Выберите категорию',
        yakut: 'Категорияны тал',
      );

  String get categorySelectionLocationAllCountry => _select(
        en: 'Whole country',
        ru: 'Страна целиком',
        yakut: 'Дойду бүтүннүк',
      );

  String categorySelectionLocationByCountry(String countryName) {
    return _select(
      en: 'Country: $countryName',
      ru: 'Страна: $countryName',
      yakut: 'Дойду: $countryName',
    );
  }

  String categoryName(String code) {
    switch (code) {
      case 'famous_people':
        return _select(
          en: 'Famous people',
          ru: 'Известные личности',
          yakut: 'Биллэр дьон',
        );
      case 'history':
        return _select(en: 'History', ru: 'История', yakut: 'История');
      case 'movies':
        return _select(en: 'Movies', ru: 'Фильмы', yakut: 'Кино');
      case 'music':
        return _select(en: 'Music', ru: 'Музыка', yakut: 'Ырыа');
      default:
        return code.toUpperCase();
    }
  }

  String categorySubtitle(String code) {
    switch (code) {
      case 'famous_people':
        return _select(
          en: 'Outstanding people, biographies, and achievements',
          ru: 'Выдающиеся люди, биографии и достижения',
          yakut: 'Биллэр дьон, биография уонна ситиһии',
        );
      case 'history':
        return _select(
          en: 'Key events, dates, and facts',
          ru: 'Ключевые события, даты и факты',
          yakut: 'Сүрүн түһүмэхтэр, күнэ уонна фактылар',
        );
      case 'movies':
        return _select(
          en: 'Cinema, directors, and iconic scenes',
          ru: 'Кино, режиссёры и знаковые сцены',
          yakut: 'Кино, режиссердар уонна биллэр сценалар',
        );
      case 'music':
        return _select(
          en: 'Genres, artists, and popular tracks',
          ru: 'Жанры, исполнители и популярные треки',
          yakut: 'Жанрдар, ырыаһыттар уонна популярнай ырыалар',
        );
      default:
        return code;
    }
  }

  String get quizSelectAnswer => _select(
        en: 'Select one answer option',
        ru: 'Выберите один вариант ответа',
        yakut: 'Биир эппиэти тал',
      );

  String quizQuestionProgress(int current, int total) {
    return _select(
      en: 'Question $current of $total',
      ru: 'Вопрос $current из $total',
      yakut: '$total иһиттэн $current ыйытыы',
    );
  }

  String quizScoreLabel(int score) {
    return _select(
      en: 'Score: $score',
      ru: 'Очки: $score',
      yakut: 'Баал: $score',
    );
  }

  String get quizScreenTitle => _select(
        en: 'Quiz',
        ru: 'Викторина',
        yakut: 'Викторина',
      );

  String get quizEmptyTitle => _select(
        en: 'No questions yet',
        ru: 'Пока нет вопросов',
        yakut: 'Ыйытыы әлегэ суох',
      );

  String quizEmptyDescription(String category) {
    return _select(
      en: 'Questions for "$category" are not added yet. Try another category or region.',
      ru: 'Для категории "$category" вопросы ещё не добавлены. Попробуйте другую категорию или регион.',
      yakut:
          '"$category" категориятыгар ыйытыылар әлегэ баар буолбатахтар. Атын категорияны эбэтэр региону тургутан көрүҥ.',
    );
  }

  String get backButton => _select(
        en: 'Go back',
        ru: 'Вернуться назад',
        yakut: 'Төнүн',
      );

  String get resultTitle => _select(
        en: 'Result',
        ru: 'Результат',
        yakut: 'Түмүк',
      );

  String resultScoreText(int score, int total) {
    return _select(
      en: 'Your result: $score out of $total',
      ru: 'Ваш результат: $score из $total',
      yakut: 'Эн түмүгүҥ: $score / $total',
    );
  }

  String resultMessageForPercent(double percent) {
    if (percent >= 0.9) {
      return _select(
        en: 'Excellent result! You are a true expert.',
        ru: 'Отличный результат! Вы настоящий эксперт.',
        yakut: 'Бэргэн түмүк! Эн кырдьык эксперт буоллаҥ.',
      );
    }
    if (percent >= 0.7) {
      return _select(
        en: 'Very good! One more try for the maximum.',
        ru: 'Очень хорошо! Ещё немного и будет максимум.',
        yakut: 'Наһаа үчүгэй! Арай биирдэ төһө да максимум буолуо.',
      );
    }
    if (percent >= 0.5) {
      return _select(
        en: 'Good try! Play again to improve your result.',
        ru: 'Неплохо! Попробуйте снова, чтобы улучшить результат.',
        yakut: 'Куһаҕаннык буолбатах! Өссө оонньоон түмүгүҥү сайыннар.',
      );
    }
    return _select(
      en: 'Nice attempt! Next time will be better.',
      ru: 'Хорошая попытка! В следующий раз будет лучше.',
      yakut: 'Үчүгэй тургутуу! Аныгыскыга ордук буолуо.',
    );
  }

  String get resultToMainMenu => _select(
        en: 'To main menu',
        ru: 'В главное меню',
        yakut: 'Сүрүн менюга',
      );

  String get aboutTitle => _select(
        en: 'About the game',
        ru: 'Об игре',
        yakut: 'Оонньуу туһунан',
      );

  String get aboutHeroTitle => _select(
        en: 'About Quiz Game project',
        ru: 'О проекте Quiz Game',
        yakut: 'Quiz Game бырайыак туһунан',
      );

  String get aboutHeroDescription => _select(
        en: 'A simple and engaging quiz to train memory, focus, and broad knowledge.',
        ru: 'Простая и увлекательная викторина для тренировки кругозора, внимания и скорости мышления.',
        yakut:
            'Көрдөрбүт билиини, болҕомтону уонна өйдөөһүнү сайыннарар эҥин уонна интэриэһинэй викторина.',
      );

  String get aboutSectionWhatTitle => _select(
        en: 'What is this app',
        ru: 'Что это за приложение',
        yakut: 'Бу ханнык приложенией',
      );

  String get aboutSectionWhatBody => _select(
        en: 'Quiz Game is an educational quiz where you answer questions in history, music, movies, and famous people. It is suitable for short game sessions and knowledge practice.',
        ru: 'Quiz Game — это обучающая викторина, где вы отвечаете на вопросы по разным темам: история, музыка, кино и известные личности. Приложение подходит для коротких игровых сессий, тренировки памяти и проверки эрудиции.',
        yakut:
            'Quiz Game диэн үөрэтэр викторина: история, ырыа, кино уонна биллэр дьон туһунан ыйытыыларга эппиэттиир. Кыратык оонньоон билиини сыалыннарарга сөп.',
      );

  String get aboutSectionHowTitle => _select(
        en: 'How to play',
        ru: 'Как играть',
        yakut: 'Хайдах оонньуур',
      );

  String get aboutStep1 => _select(
        en: 'Choose a country and, if needed, a region.',
        ru: 'Выберите страну и при необходимости регион.',
        yakut: 'Дойдуну уонна наада буоллаҕына региону тал.',
      );

  String get aboutStep2 => _select(
        en: 'Open a category and start the round.',
        ru: 'Откройте категорию и начните раунд.',
        yakut: 'Категорияны арый да раунду саҕалаа.',
      );

  String get aboutStep3 => _select(
        en: 'Answer questions and track your progress.',
        ru: 'Отвечайте на вопросы и следите за прогрессом.',
        yakut: 'Ыйытыыларга эппиэттээ уонна сайдыыҥы көр.',
      );

  String get aboutStep4 => _select(
        en: 'At the end, get your score, percent, and feedback.',
        ru: 'В конце получите итог, процент правильных ответов и обратную связь.',
        yakut: 'Түмүгэр баалы, бырыһыанны уонна санаа иһэрин ылар.',
      );

  String get aboutSectionFeaturesTitle => _select(
        en: 'Features',
        ru: 'Возможности',
        yakut: 'Мөмкүнчүлүктэр',
      );

  String get aboutFeature1 => _select(
        en: 'Shuffling questions and answer options',
        ru: 'Перемешивание вопросов и вариантов ответов',
        yakut: 'Ыйытыы уонна эппиэт тардыытын бутааһын',
      );

  String get aboutFeature2 => _select(
        en: 'Light and dark themes',
        ru: 'Светлая и тёмная тема',
        yakut: 'Сырдык уонна хараҥа тиэмэ',
      );

  String get aboutFeature3 => _select(
        en: 'Configurable number of questions per round',
        ru: 'Настройка количества вопросов в раунде',
        yakut: 'Раундугар ыйытыы ахсаанын туруоруу',
      );

  String get aboutFeature4 => _select(
        en: 'Result screen with percent and comments',
        ru: 'Экран результата с процентом и комментариями',
        yakut: 'Бырыһыаннаах уонна комментарииннаах түмүк экрана',
      );

  String get aboutSectionTipsTitle => _select(
        en: 'Tips for better results',
        ru: 'Советы для лучшего результата',
        yakut: 'Олох түмүгүн сайыннарар сүбэлэр',
      );

  String get aboutTip1 => _select(
        en: 'Play different categories to retain knowledge better.',
        ru: 'Запускайте разные категории — так знания закрепляются лучше.',
        yakut: 'Араас категориялары оонньоо, билии ордук бэхийэр.',
      );

  String get aboutTip2 => _select(
        en: 'Try answering faster for extra challenge.',
        ru: 'Попробуйте уменьшить время на ответ для дополнительной сложности.',
        yakut: 'Эппиэти түргэнник биэрэн ыараханы улаат.',
      );

  String get aboutTip3 => _select(
        en: 'Repeat rounds and compare your progress.',
        ru: 'Повторяйте раунды и сравнивайте свой прогресс.',
        yakut: 'Раундтары хаттан оонньоо уонна сайдыыҥы тэҥнэ.',
      );

  String appVersionLabel(String version) {
    return _select(
      en: 'App version: $version',
      ru: 'Версия приложения: $version',
      yakut: 'Приложение барыйаана: $version',
    );
  }

  String get suggestTitle => _select(
        en: 'Suggest a question',
        ru: 'Предложить вопрос',
        yakut: 'Ыйытыыны сүбэлээ',
      );

  String get suggestHeroTitle => _select(
        en: 'Suggest your question',
        ru: 'Предложите свой вопрос',
        yakut: 'Бэйэҥ ыйытыыгын ыыт',
      );

  String get suggestHeroDescription => _select(
        en: 'Send your ideas via Instagram, Telegram, or Gmail. The best questions will be added in future updates.',
        ru: 'Вы можете отправить свои идеи через Instagram, Telegram или Gmail. Лучшие вопросы добавим в следующие обновления.',
        yakut:
            'Санааҕын Instagram, Telegram эбэтэр Gmail нөҥүө ыыт. Ордук ыйытыылары салгыы саҥардыыларга эбэбит.',
      );

  String get suggestFooter => _select(
        en: 'You can send a question, 4 options, and the correct answer.',
        ru: 'Можно прислать вопрос, 4 варианта ответа и указать правильный вариант.',
        yakut: 'Ыйытыыны, 4 эппиэт тардыытын уонна сөп эппиэти ыыта сылдь.',
      );

  String get suggestOpenLinkFailed => _select(
        en: 'Could not open the link. Please try again later.',
        ru: 'Не удалось открыть ссылку. Попробуйте позже.',
        yakut: 'Сигэни арыйар кыах суох. Кэлин көрүҥ.',
      );

  String get suggestMailSubject => _select(
        en: 'Question suggestion for Quiz Game',
        ru: 'Предложение вопроса для Quiz Game',
        yakut: 'Quiz Game-ка ыйытыы сүбэтэ',
      );

  String get suggestMailBody => _select(
        en: 'Hello!\n\nI would like to suggest a new question:\n- Country:\n- Category:\n- Question:\n- Answer options:\n- Correct answer:\n',
        ru: 'Здравствуйте!\n\nХочу предложить новый вопрос:\n- Страна:\n- Категория:\n- Вопрос:\n- Варианты ответов:\n- Правильный ответ:\n',
        yakut:
            'Дорообо!\n\nСаҥа ыйытыыны сүбэлиибин:\n- Дойду:\n- Категория:\n- Ыйытыы:\n- Эппиэт тардыыта:\n- Сөп эппиэт:\n',
      );
}
