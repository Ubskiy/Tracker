import UIKit

// Расширение для ViewController'a - убираем клавиатуру с экрана при нажатии
extension UIViewController {
    func hideKeyboardWhenDidTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

