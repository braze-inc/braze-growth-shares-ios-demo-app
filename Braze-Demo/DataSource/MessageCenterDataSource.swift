import UIKit

class MessageCenterDataSource: NSObject {
  
  // MARK: - Variables
  private var messages: [Message] = []
  weak var delegate: CellActionDelegate?
}

// MARK: - Public Methods
extension MessageCenterDataSource {
  func configure(with messages: [Message], delegate: CellActionDelegate? = nil) {
    self.messages = messages
    self.delegate = delegate
  }
  
  func deleteMessage(_ messageToDelete: Message) {
    messageToDelete.logContentCardDismissed()
    
    messages = messages.filter { $0.contentCardData?.contentCardId != messageToDelete.contentCardData?.contentCardId }
  }
  
  func removeAllMessages() {
    for message in messages {
      message.logContentCardDismissed()
    }
    messages.removeAll()
  }
}

// MARK: - Delegate
extension MessageCenterDataSource: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let message = messages[indexPath.row]
    delegate?.cellTapped(with: message)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let message = messages[indexPath.row]
    
    messages.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
    
    message.logContentCardDismissed()
  }
}

// MARK: - DataSource
extension MessageCenterDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 56
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCenterTableViewCell.cellIdentifier, for: indexPath) as? MessageCenterTableViewCell else { return UITableViewCell() }
    
    let message = messages[indexPath.row]
    cell.configureCell(message.messageTitle, message.imageUrl, message.contentCardData?.createdAt)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let message = messages[indexPath.row]
    message.logContentCardImpression()
  }
}
