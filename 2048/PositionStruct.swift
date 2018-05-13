import Foundation

/// Положение плиток на доске
struct Position : Equatable {
  let x : Int
  let y : Int
  
  /// Ищем предыдущую позицию в соответствии текущими направлением и ориентацией
  func previousPosition(direction: Direction, orientation: Orientation) -> Position {
    switch orientation {
    case .vertical:
      return Position(x: x, y: y - direction.rawValue)
    case .horizon:
      return Position(x: x - direction.rawValue, y: y)
    }
  }
}
