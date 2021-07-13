import UIKit

protocol CollectionViewDataSourceProvider: UICollectionViewDelegate {
  init(collectionView: UICollectionView, delegate: CellActionDelegate)
  func applySnapshot(_ content: [ContentCardable], ads: [Ad], animatingDifferences: Bool)
  func reorderDataSource()
  func resetDataSource()
}

protocol CellActionDelegate: AnyObject {
  func cellTapped(with data: Any?)
}

