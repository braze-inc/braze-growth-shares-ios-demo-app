import UIKit

// SOURCE: - https://stackoverflow.com/questions/28338981/how-to-add-done-button-to-numpad-in-ios-using-swift
extension UITextField{
    @IBInspectable private var doneAccessory: Bool {
        get { return self.doneAccessory }
        
        set (hasDone) {
            if hasDone { addDoneButtonOnKeyboard() }
        }
    }

    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc private func doneButtonAction() {
        self.resignFirstResponder()
    }
}

