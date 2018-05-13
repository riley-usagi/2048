import UIKit

let style = Style()
let config = BoardSizeConfig()

/// Плитка (элемент игры)
class Tile: Equatable {
  
  
  var value: Int = 0 {
    didSet {
      updateView()
    }
  }
  
  var valueText: String {
    return value == 0 ? "" : "\(1 << value)"
  }
  
  var valueLength: Int {
    return valueText.count
  }
  
  var isEmpty: Bool {
    return value == 0
  }
  
  let view: UILabel = UILabel(frame: .zero)
  
  var position: Position {
    didSet {
      guard let board = self.board else {
        return
      }
      let point = board.pointAt(position: self.position)
      self.topConstraint?.constant = point.y
      self.letfConstraint?.constant = point.x
    }
  }
  
  var board: Board?
  var topConstraint: NSLayoutConstraint?
  var letfConstraint: NSLayoutConstraint?
  
  init(value: Int, position: Position = Position(x: 0, y: 0)) {
    self.position = position
    view.textAlignment = .center
    view.layer.cornerRadius = 3
    view.translatesAutoresizingMaskIntoConstraints = false
    self.value = value
    updateView()
  }
  
  /// Размер шрифта в зависимости от разрядноси числа
  func fontSize(for length: Int) -> CGFloat {
    if length > 4 {
      return 18
    } else if length > 3 {
      return 20
    } else {
      return 30
    }
  }
  
  func updateView() {
    view.text = valueText
    view.font = UIFont.boldSystemFont(ofSize: fontSize(for: valueLength))
    view.layer.backgroundColor = style.tileBackgroundColor(value: value)
    view.textColor = style.tileForegroundColor(value: value)
  }
  
  func moveTo(position: Position) {
    self.position = position
  }
  
  func mergeTo(position: Position) {
    moveTo(position: position)
    self.value += 1
  }
  
  /// Добавление плитки на поле
  func addTo(board: Board) {
    guard self.board == nil else {
      return
    }
    
    self.board = board
    let boardView = board.boardView
    boardView.addSubview(view)
    view.widthAnchor.constraint(equalToConstant: config.tileSize.width).isActive = true
    view.heightAnchor.constraint(equalToConstant: config.tileSize.height).isActive = true
    
    let point = board.pointAt(position: self.position)
    topConstraint = view.topAnchor.constraint(equalTo: boardView.topAnchor, constant: point.y)
    letfConstraint = view.leftAnchor.constraint(equalTo: boardView.leftAnchor, constant: point.x)
    topConstraint?.isActive = true
    letfConstraint?.isActive = true
  }
  
  func removeFromBoard() {
    self.view.removeFromSuperview()
  }
  
  func createPreviousEmptyTile(direction: Direction, orientation: Orientation) -> Tile {
    // ToDo: rename to position?
    let pos = self.position.previousPosition(direction: direction, orientation: orientation)
    return Tile(value: 0, position: pos)
  }
  
  static func == (lhs: Tile, rhs: Tile) -> Bool {
    return lhs.value == rhs.value && lhs.position == rhs.position
  }
}



/// Игровая площадка (доска)
class Board {
  let boardView: UIView
  var tileArray = [Tile]()
  
  // Задаём изначальные настройки игровой площадки
  init() {
    boardView = UIView(frame: .zero)
    boardView.backgroundColor = style.boardBackgoundColor
    boardView.layer.cornerRadius = 6
    boardView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func pointAt(x: Int, y: Int) -> CGPoint {
    let offsetX = config.borderSize.width
    let offsetY = config.borderSize.height
    let width = config.tileSize.width + config.borderSize.width
    let height = config.tileSize.height + config.borderSize.height
    
    return CGPoint(x: offsetX + width * CGFloat(x), y: offsetY + height * CGFloat(y))
  }
  
  func pointAt(position: Position) -> CGPoint {
    return pointAt(x: position.x, y: position.y)
  }
  
  func addTo(view: UIView) {
    view.addSubview(self.boardView)
    boardView.widthAnchor.constraint(equalToConstant: config.boardSize.width).isActive = true
    boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor).isActive = true
    boardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    boardView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  /// Сообщение о проигрыше
  func gameOver() {
    // ToDo: add alert with action
    print("Game over")
  }
  
  /// Процесс добавления плитки на текущее игровое поле
  func add(tile: Tile) {
    tile.addTo(board: self)
  }
  
  func generateTile() {
    guard tileArray.count <= config.tileCount else {
      print("Не влезет")
      return
    }
    
    var tileList: [(Int, Int)?] = Array(repeating: nil, count: config.tileCount)
    
    for x in 0..<config.tileNumber {
      for y in 0..<config.tileNumber {
        tileList[x + y * config.tileNumber] = (x, y)
      }
    }
    
    for tile in tileArray {
      tileList[tile.position.x + tile.position.y * config.tileNumber] = nil
    }
    
    let remain = tileList.compactMap {$0}
    let random = arc4random_uniform(UInt32(remain.count))
    let value = Int(arc4random_uniform(3) / 2) + 1
    let (x, y) = remain[Int(random)]
    let tile = Tile(value: value, position: Position(x: x, y: y))
    
    tile.addTo(board: self)
    tileArray.append(tile)
  }
  
  func buildBoard() {
    for i in 0..<4 {
      for j in 0..<4 {
        let layer = CALayer()
        layer.frame = CGRect(origin: pointAt(x: i, y: j), size: config.tileSize)
        layer.backgroundColor = style.emptyBackgroundColor.cgColor
        layer.cornerRadius = 3
        boardView.layer.addSublayer(layer)
      }
    }
    generateTile()
    generateTile()
  }
  
  func removeTileFromArray(tile: Tile) {
    if let idx = tileArray.index(where: {$0  == tile}) {
      tileArray.remove(at: idx)
      tile.removeFromBoard()
    }
  }
  
  func checkMovement(direction: Direction, orientation: Orientation) -> Bool {
    var moved = false
    var tileList = [Tile]()
    
    for y in 0..<config.tileNumber {
      for x in 0..<config.tileNumber {
        let tile = Tile(value: 0, position: Position(x: x, y: y))
        tileList.append(tile)
      }
    }
    
    for tile in tileArray {
      tileList[tile.position.x + tile.position.y * config.tileNumber] = tile
    }
    
    var lastZeroTile: Tile? = nil
    var lastMergableTile: Tile? = nil
    
    for i in 0..<config.tileNumber {
      lastZeroTile = nil
      lastMergableTile = nil
      
      for j in 0..<config.tileNumber {
        let temp = direction == .forward ? (config.tileNumber - 1) - j : j
        let x = orientation == .horizon ? temp : i
        let y = orientation == .horizon ? i : temp
        let tile = tileList[x + y * config.tileNumber]
        
        if !tile.isEmpty {
          
          if let mergableTile = lastMergableTile, mergableTile.value == tile.value {
            tile.mergeTo(position: mergableTile.position)
            removeTileFromArray(tile: mergableTile)
            lastMergableTile = nil
            lastZeroTile = tile.createPreviousEmptyTile(direction: direction, orientation: orientation)
            moved = true
            continue
          }
          
          if let zeroTile = lastZeroTile {
            tile.moveTo(position: zeroTile.position)
            lastZeroTile = tile.createPreviousEmptyTile(direction: direction, orientation: orientation)
            moved = true
          }
          
          lastMergableTile = tile
        } else {
          if lastZeroTile == nil {
            lastZeroTile = tile
          }
        }
      }
    }
    
    return moved
  }
  
  func moveTile(direction: Direction, orientation: Orientation) {
    let moved = checkMovement(direction: direction, orientation: orientation)
    UIView.animate(withDuration: 0.1, animations: {
      self.boardView.layoutIfNeeded()
    }) { (_) in
      if moved {
        self.generateTile()
      }
    }
  }
  
}

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
      view.backgroundColor = UIColor(white: 1.0, alpha: 1)
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
