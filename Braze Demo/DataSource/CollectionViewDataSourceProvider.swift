import UIKit

protocol CollectionViewDataSourceProvider: UICollectionViewDelegate {
  init(collectionView: UICollectionView, delegate: CellActionDelegate)
  func applySnapshot(_ content: [ContentCardable], ads: [Ad], animatingDifferences: Bool)
  func reorderDataSource()
  func resetDataSource()
}

protocol CellActionDelegate: class {
  func cellTapped(with data: Any?)
}

