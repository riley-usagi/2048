import Foundation

/// Направление по вертикали/горизонтали
enum Orientation {
  case vertical
  case horizon
}

/// Направление движения
enum Direction : Int {
  case forward = 1
  case backward = -1
}
