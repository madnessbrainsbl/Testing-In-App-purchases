# Flutter Testing In-App Purchases

Этот проект представляет собой набор компонентов и экранов для тестирования встроенных покупок (In-App Purchases) в Flutter приложениях для iOS и Android.

## 🚀 Особенности

- ✅ Поддержка подписок (месячные, годовые)
- ✅ Поддержка разовых покупок (пожизненный доступ)
- ✅ Восстановление покупок
- ✅ Тестовый режим с мок-данными
- ✅ Подробное логирование
- ✅ State management с помощью BLoC/Cubit
- ✅ Готовые UI компоненты для экрана оплаты

## 📁 Структура проекта

```
pay_wall/
├── cubit/
│   ├── purchase_cubit.dart        # Бизнес-логика покупок
│   └── purchase_state.dart        # Состояния покупок
├── models/
│   └── paywall_content.dart       # Модели данных
├── widgets/
│   ├── pay_wall_button.dart       # Кнопка покупки
│   ├── paywall_app_bar.dart       # App bar для экрана
│   ├── paywall_bg_image.dart      # Фоновое изображение
│   ├── paywall_buttons.dart       # Группа кнопок покупок
│   ├── paywall_glass_container.dart # Стеклянный контейнер
│   ├── paywall_header.dart        # Заголовок экрана
│   └── paywall_text.dart          # Текстовые элементы
├── pay_wall_banner_overlay.dart   # Баннер оверлей
└── pay_wall_screen.dart           # Основной экран оплаты
```

## 🛠 Установка и настройка

### 1. Зависимости

Добавьте следующие зависимости в ваш `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  in_app_purchase: ^3.1.11
  equatable: ^2.0.5
  go_router: ^10.1.2
```

### 2. Настройка iOS

В `Info.plist` добавьте поддержку SKAdNetwork:

```xml
<key>SKAdNetworkItems</key>
<array>
  <dict>
    <key>SKAdNetworkIdentifier</key>
    <string>cstr6suwn9.skadnetwork</string>
  </dict>
</array>
```

### 3. Настройка продуктов

Настройте продукты в App Store Connect:
- `monthly_subscription` - месячная подписка
- `annual_subscription` - годовая подписка  
- `lifetime_access` - пожизненный доступ

## 💻 Использование

### Базовый пример

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pay_wall/cubit/purchase_cubit.dart';
import 'pay_wall/pay_wall_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => PurchaseCubit(),
        child: PayWallScreen(),
      ),
    );
  }
}
```

### Обработка состояний покупок

```dart
BlocBuilder<PurchaseCubit, PurchaseState>(
  builder: (context, state) {
    if (state is PurchaseLoading) {
      return CircularProgressIndicator();
    } else if (state is PurchaseSuccess) {
      return Text('Покупка успешно завершена!');
    } else if (state is PurchaseError) {
      return Text('Ошибка: ${state.message}');
    }
    return PayWallScreen();
  },
)
```

## 🧪 Тестирование

### Тестовый режим

Для включения тестового режима (использование мок-данных):

```dart
final purchaseCubit = PurchaseCubit();
purchaseCubit.testMode = true; // Включить тест режим
```

### Sandbox тестирование

1. Создайте Sandbox тестеров в App Store Connect
2. Выйдите из основного Apple ID на устройстве
3. При первой покупке используйте Sandbox аккаунт
4. Проверьте логи для отслеживания процесса

Подробная инструкция по тестированию находится в файле `test_purchases.md`.

## 📊 Логирование

Все операции покупок логируются с префиксом `[PurchaseCubit]`:

```
[PurchaseCubit] Loading products...
[PurchaseCubit] Products loaded: [monthly_subscription, annual_subscription, lifetime_access]
[PurchaseCubit] Starting purchase for: monthly_subscription
[PurchaseCubit] Purchase updated: 1 items
[PurchaseCubit] Processing purchase: monthly_subscription, status: PurchaseStatus.purchased
```

## 🔧 Кастомизация

### Изменение продуктов

Отредактируйте список продуктов в `PurchaseCubit`:

```dart
static const List<String> _productIds = [
  'your_monthly_subscription',
  'your_annual_subscription',
  'your_lifetime_access',
];
```

### Настройка UI

Все UI компоненты находятся в папке `widgets/` и легко кастомизируются.

## 📋 Поддерживаемые функции

- [x] Загрузка продуктов из магазина
- [x] Покупка подписок
- [x] Покупка разовых товаров
- [x] Восстановление покупок
- [x] Валидация покупок
- [x] Обработка ошибок
- [x] Тестовый режим
- [ ] Серверная валидация
- [ ] Аналитика покупок
- [ ] A/B тестирование

## 🤝 Содействие

1. Fork проект
2. Создайте feature branch (`git checkout -b feature/amazing-feature`)
3. Commit изменения (`git commit -m 'Add amazing feature'`)
4. Push в branch (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

## 📄 Лицензия

Этот проект распространяется под лицензией MIT. Подробности в файле `LICENSE`.

## 📞 Поддержка

Если у вас есть вопросы или проблемы, создайте Issue в этом репозитории.
