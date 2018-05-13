import UIKit
import GameplayKit

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

/// Положение плиток на доске
struct Position : Equatable{
  let x : Int
  let y : Int
  
  /// find previouse position according to the direction and orientation
  func previousPosition(direction: Direction, orientation: Orientation) -> Position {
    switch orientation {
    case .vertical:
      return Position(x: x, y: y - direction.rawValue)
    case .horizon:
      return Position(x: x - direction.rawValue, y: y)
    }
  }
}

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

