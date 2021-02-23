import UIKit

class ShoppingCartDataSource: NSObject {
  
  // MARK: - Variables
  private var tiles: [Tile] = []
}

// MARK: - Public Methods
extension ShoppingCartDataSource {
    func configure(with tiles: [Tile]) {
        self.tiles = tiles
    }
}

// MARK: - DataSource
extension ShoppingCartDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tiles.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingCartTableViewCell.cellIdentifier, for: indexPath) as? ShoppingCartTableViewCell else { return UITableViewCell() }
    
    let tile = tiles[indexPath.row]
    cell.configure(tile.title, tile.price, tile.imageUrl)
    return cell
  }
}
