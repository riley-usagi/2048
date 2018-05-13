import UIKit

/// Направление по вертикали/горизонтали
enum Orientation {
  case vertical
  case horizon
}

/// Шаг вперёд и назад
enum Direction : Int {
  case forward = 1
  case backward = -1
}

// Инициализируем настройки в формате переменых для удобства дальнейшего пользования
let style = Style()
let config = BoardSizeConfig()

class ViewController: UIViewController {
  
  let board = Board()
  
  // Обработка одного единственного возможного действия ("свайпа")
  @IBAction func swipe(recognizer: UIGestureRecognizer?) {
    guard let recognizer = recognizer as? UISwipeGestureRecognizer else {
      return
    }
    
    switch recognizer.direction {
      
    // Свайп вправо. Движение плиток вперёд по горизонтали
    case UISwipeGestureRecognizerDirection.right:
      board.moveTile(direction: .forward, orientation: .horizon)
      
    // Свайп влево. Движение плиток назад по горизонтали
    case UISwipeGestureRecognizerDirection.left:
      board.moveTile(direction: .backward, orientation: .horizon)
      
    // Свайп вверх. Движение плиток назад по вертикали (вверх)
    case UISwipeGestureRecognizerDirection.up:
      board.moveTile(direction: .backward, orientation: .vertical)
      
    // Свайп вниз. Движение плиток вперёд по вертикали (вниз)
    case UISwipeGestureRecognizerDirection.down:
      board.moveTile(direction: .forward, orientation: .vertical)
    default:
      break
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Игровой процесс
    if let view = self.view {
      view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      // view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      
      // Обрабатываем "свайпы" по экрану
      for direction: UISwipeGestureRecognizerDirection in [.left, .right, .up, .down] {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        gesture.direction = direction
        view.addGestureRecognizer(gesture)
      }
      
      // Вывод заготовки под доску на экран
      board.addTo(view: view)
      
      // Вывод начальных плиток на доску (включая первоначальные две)
      board.buildBoard()
    }
    
  }
}
