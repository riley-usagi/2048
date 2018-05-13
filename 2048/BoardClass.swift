import UIKit

/// Игровая площадка (доска)
class Board {
  let boardView: UIView
  var tileArray = [Tile]()
  
  // Задаём изначальные настройки игровой площадки
  init() {
    // Позиция отрисовки (левый верхний угол)
    boardView = UIView(frame: .zero)
    
    // Задний фон доски
    boardView.backgroundColor = style.boardBackgoundColor
    
    // Огругление углов доски
    boardView.layer.cornerRadius = 6
    
    // Не переводить авторазмеры в ограничения (не знаю как ещё это назвать =D)
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
  
  /// Вывод доски на экран, со всевозможными ограничениями по краям
  func addTo(view: UIView) {
    view.addSubview(self.boardView)
    boardView.widthAnchor.constraint(equalToConstant: config.boardSize.width).isActive = true
    boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor).isActive = true
    boardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    boardView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  /// Сообщение о проигрыше (необходимо вызвать метод в нужный момент)
  func gameOver() {
    // ToDo: add alert with action
    print("Game over")
  }
  
  /// Процесс добавления плитки на текущее игровое поле
  func add(tile: Tile) {
    tile.addTo(board: self)
  }
  
  /// Генерация новой плитки на свободной позиции
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
  
  /// Заполнение доски пустыми плитками и двумя первоначальными
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
  
  /// Проверка возможности сдвига для каждой плитки на экране на данный момент
  func checkMovement(direction: Direction, orientation: Orientation) -> Bool {
    
    /// Значение сдвига
    var moved = false
    
    /// Начальный массив плиток
    var tileList = [Tile]()
    
    //
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
  
  /// Процесс сдвига конкретной плитки
  func moveTile(direction: Direction, orientation: Orientation) {
    // Проверка на то, сдвинулись ли плитки (с учётом игровой возможности)
    let moved = checkMovement(direction: direction, orientation: orientation)
    
    // Анимация движения
    UIView.animate(withDuration: 0.1, animations: {
      self.boardView.layoutIfNeeded()
    }) { (_) in
      // Если плитки успешно сдвинулись - генерируем новую плитку среди свободных
      if moved {
        self.generateTile()
      }
    }
  }
}
