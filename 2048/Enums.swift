//
//  enums.swift
//  2048
//
//  Created by Riley Usagi on 13.05.2018.
//  Copyright © 2018 Riley Usagi. All rights reserved.
//

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
