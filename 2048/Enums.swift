import Foundation

/// Формат положения экрана
enum Orientation {
  case vertical
  case horizon
}

/// Направление движения
enum Direction : Int {
  case forward = 1
  case backward = -1
}
