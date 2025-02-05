import UIKit

final class CustomTextField: UITextField {
    
    private let shift: CGFloat = 16
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, shift, 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, shift, 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, shift, 0)
    }
}
