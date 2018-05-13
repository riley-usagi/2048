import UIKit

/// Плитка (элемент игры)
class Tile: Equatable {
  
  /// Значение плитки
  var value: Int = 0 {
    // При изменении значения плитки - обновлять её визуальную часть
    didSet {
      updateView()
    }
  }
  
  /// Текст плитки
  var valueText: String {
    // Если в плитке 0 очков, то не выводить текст, в противном случае сумма удваивается и выводится на экран
    return value == 0 ? "" : "\(1 << value)"
  }
  
  /// Разрядность числа
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
  
  /// Размер шрифта в зависимости от разрядности числа
  func fontSize(for length: Int) -> CGFloat {
    if length > 4 {
      return 18
    } else if length > 3 {
      return 20
    } else {
      return 30
    }
  }
  
  /// Обновление внешнего вида плитки (цвет и текст)
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
