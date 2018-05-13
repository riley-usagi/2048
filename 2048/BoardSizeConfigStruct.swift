import UIKit

/// Настройки размеров доски
struct BoardSizeConfig {
  
  /// Количество плиток в ряд
  let tileNumber = 4
  
  /// Всего плиток в игре
  let tileCount = 16
  
  // Различные размеры
  let boardSize = CGSize(width: 290, height: 290)
  let tileSize = CGSize(width: 60, height: 60)
  let borderSize = CGSize(width: 10, height: 10)
}
