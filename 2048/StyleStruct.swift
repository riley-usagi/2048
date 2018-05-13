import UIKit

/// Стили оформления игры
struct Style {
  
  /// Задний фон доски
  let boardBackgoundColor = #colorLiteral(red: 0.6823529412, green: 0.624, blue: 0.561, alpha: 1)
  
  /// Цвет пустой плитки
  let emptyBackgroundColor = #colorLiteral(red: 0.561, green: 0.7058823529, blue: 0.639, alpha: 1)
  
  /// Цвета плиток
  let tileBackgroundColors = [
    #colorLiteral(red: 0.7529411765, green: 0.7098039216, blue: 0.6509803922, alpha: 1), #colorLiteral(red: 0.9254901961, green: 0.8745098039, blue: 0.8196078431, alpha: 1), #colorLiteral(red: 0.9098039216, green: 0.8549019608, blue: 0.7490196078, alpha: 1), #colorLiteral(red: 0.9333333333, green: 0.6392156863, blue: 0.3960784314, alpha: 1),
    #colorLiteral(red: 0.9019607843, green: 0.4784313725, blue: 0.262745098, alpha: 1), #colorLiteral(red: 0.9764705882, green: 0.3843137255, blue: 0.2980392157, alpha: 1), #colorLiteral(red: 0.8901960784, green: 0.2549019608, blue: 0.1764705882, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.8235294118, blue: 0.3568627451, alpha: 1),
    #colorLiteral(red: 0.9333333333, green: 0.7921568627, blue: 0.231372549, alpha: 1), #colorLiteral(red: 0.8745098039, green: 0.7137254902, blue: 0.1333333333, alpha: 1), #colorLiteral(red: 0.9137254902, green: 0.7333333333, blue: 0.1921568627, alpha: 1), #colorLiteral(red: 0.9098039216, green: 0.737254902, blue: 0.03921568627, alpha: 1)
  ]
  
  // Цвета цифр в плитках
  let tileForgroundColors = [
    #colorLiteral(red: 0.3882352941, green: 0.3647058824, blue: 0.3176470588, alpha: 1), UIColor.white
  ]
  
  /// Цвет плитки в соответствии с её значанием
  func tileBackgroundColor(value: Int) -> CGColor {
    return value < tileBackgroundColors.count ? tileBackgroundColors[value].cgColor : (tileBackgroundColors.last!.cgColor)
  }
  
  /// Цвет текста плитки в соответствии со значением плитки
  func tileForegroundColor(value: Int) -> UIColor {
    return tileForgroundColors[value > 2 ? 1 : 0]
  }
}
