# ContextMenuSDK

[![Version](https://img.shields.io/cocoapods/v/ContextMenuSDK.svg?style=flat)](https://cocoapods.org/pods/ContextMenuSDK)
[![License](https://img.shields.io/cocoapods/l/ContextMenuSDK.svg?style=flat)](https://cocoapods.org/pods/ContextMenuSDK)
[![Platform](https://img.shields.io/cocoapods/p/ContextMenuSDK.svg?style=flat)](https://cocoapods.org/pods/ContextMenuSDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ContextMenuSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ContextMenuSDK ~> 1.0.0'
```

## Usage

Для использования компонента есть специальная сущность ContextMenu. У нее есть 3 метода для добавления контекстного меню на отдельный элемент, с набором конфигурация:
```swift
public static func add(to view: UIView,
                       with config: ContextMenuViewConfig)
public static func add(to barItem: UIBarButtonItem,
                       with config: ContextMenuNavBarItemConfig)
public static func add(to barItem: UITabBarItem,
                       with config: ContextMenuTabBarItemConfig)
```
Для настройки компонета используем синглон ContextMenu.settings.

## Setting
Набор глобальных настроек на уровне всего проекта.
Настройки разбиты на несколько разделов:
- Contant - Объект, с которым пользователь ваимодействовал.
- Menu - Контейнер для отображения меню.
- MenuAction - Ячейки в меню.
- Animations - Анамации отображения и скрытия.

#### Contant
- shadow - Тень вокруг объекта, с которым пользователь ваимодействовал.

#### Menu
- width - Ширина меню.
- insetOfLeftAndRight - Минимальные отстпупы от правого и левого краев экрана.
- insetOfContent - Отступ меню от контента.
- cornerRadius - Закругление углов меню.
- footerHeight - Высота между секциями в меню.
- separatorColor - Цвет разделителя между ячейками и секциями меню.
- shadow - Тень вокруг меню.

#### MenuAction
- defaultBackgroundColor - Цвет обычных ячеек в меню.
- selectedBackgroundColor - Цвет выделенных ячеек в меню.
- insetOfinsetOfTopAndBottomContent - Отстыпы внутри ячейки от верхнего и нижнего краев.
- insetOfLeftAndRight - Отстыпы внутри ячейки от правого и левого краев
- imageSize - Размер иконки.
- font - Шрифт текста.
- defaultTextColor - Цвет обычного текста.
- negativeTextColor - Альтернативный цвет текста.
- defaultImageColor - Цвет обычного иконки.
- negativeImageColor - Альтернативный цвет иконки.

#### Animations
- blurStyle - Стиль блюра  (используется с BackgroudType == .blur).
- backgroundColor - Цвет фона (используется с BackgroudType == .color).
- scaleValue - Абсолютная величина на которую сжимается каждая сторона. Если это значение превышает scaleValue в относительном занчении, то используется scaleFactor.
- scaleFactor - Относительная величина на которую сжимается каждая сторона.
- scaleDuration - Продолжительность скеил аниации (когда при нажатии, вью проваливается).
- showTransitionDuration - Продолжительность анимации открытия.
- hideTransitionDuration - Продолжительность анимации закрытия.
- showAnimation - Колбек, который позвонялет полностью переопределить поведение аниации открытия. Все анимации связанные с перемещение объектов, при необходимости, обрабатываются под капотом. Здесь можно обработать только только простые вещи, например анимацию "вплытия" после скейла или закругления углов. Параметры:
    - BackgroundContent: энум через который можно молучить бекграунд
    - UIView: непосредственно сама вью, на которое было нажание
    - UIView: меню
    - () -> Void: всегда необходимо вызывать после окончания анимации. В нем обрабатывается завершение перехода
- hideAnimation - Колбек, который позвонялет полностью переопределить поведение аниации закрытия. Если переопределяется анимация отображения,то здесь стоит все вернуть как было. Параметры:
    - BackgroundContent: энум через который можно молучить бекграунд
    - UIView: непосредственно сама вью, на которое было нажание
    - UIView: меню
    - () -> Void: всегда необходимо вызывать после окончания анимации. В нем обрабатывается завершение перехода

## Configs
Набор конфигурация отоброжения меню для конкретной view. 
Есть 3 конфигурации: 
- для UIBarButtonItem
- для UITabBarItem
- для UIView

#### ContextMenuViewConfig
- actionSections - Массив  секция для меню. Каждая секция состоит из набора экшенов и футера (опционально).
- trigger - Триггер для отображения контекстного меню (tap или longPress).
- position - Позиция меню по отношению к контенту.
- backgroudType - Тип бэкграунда (blur, color, none).
- menuWidth - Ширина меню для конкретного контента (если nil, то значение беерться из Settings).

В силу специфики UIBarButtonItem и UITabBarItem, ContextMenuNavBarItemConfig и ContextMenuTabBarItemConfig соответственно, являются ограниченными версиями ContextMenuViewConfig. ContextMenuNavBarItemConfig может позиционироваться только bottomCenter. ContextMenuTabBarItemConfig может позиционироваться только topCenter и реагировать тольок на longPress.

#### ContextMenuSection
- actions - Массив секций, состоящих из экшенов (ContextMenuAction) для меню.
- footer - Используется когда нужно разделить несколько секций сепаратором.

#### ContextMenuAction
- text - Текст ячейки меню.
- font - Шрифт текста. Имеет больший приоритет, чем значение из настроек (Settings).
- textColor - Цвет текста. Имеет больший приоритет, чем значение из настроек (Settings).
- image - Иконка, расположенная справа.
- imageColor - Цвет иконки.
- action - Колбек ячейки меню.

#### Trigger
- tap
- longPrees

#### MenuPosition
- topLeft
- topCenter
- topRight
- bottomLeft
- bottomCenter
- bottomRight

#### BackgroudType
- blur
- color
- none

Важно отметить, что если выбранная позиция не позволяет уместить меню в пределах экрана, то меню будет смещаться, до минимального отспупа от края.

## Author

Aleksandr Lis, mr.aleksandr.lis@gmail.com

## License

ContextMenuSDK is available under the MIT license. See the LICENSE file for more info.
