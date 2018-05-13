import UIKit

// Инициализируем настройки в формате переменых для удобства дальнейшего пользования
let style = Style()
let config = BoardSizeConfig()

class ViewController: UIViewController {
  
  let board = Board()
  
  @IBAction func swipe(recognizer: UIGestureRecognizer?) {
    guard let recognizer = recognizer as? UISwipeGestureRecognizer else {
      return
    }
    
    switch recognizer.direction {
    case UISwipeGestureRecognizerDirection.right:
      board.moveTile(direction: .forward, orientation: .horizon)
    case UISwipeGestureRecognizerDirection.left:
      board.moveTile(direction: .backward, orientation: .horizon)
    case UISwipeGestureRecognizerDirection.up:
      board.moveTile(direction: .backward, orientation: .vertical)
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
      view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      
      for direction: UISwipeGestureRecognizerDirection in [.left, .right, .up, .down] {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        gesture.direction = direction
        view.addGestureRecognizer(gesture)
      }
      
      board.addTo(view: view)
      board.buildBoard()
    }
    
  }
}
