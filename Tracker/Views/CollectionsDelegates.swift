import UIKit

final class ColorCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    var selectedColorNum: Int = 0
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Ваш код обработки нажатия на ячейку
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 3.0
        cell?.layer.borderColor = UIColor(named: "YPSelection\(indexPath.row+1)")?.withAlphaComponent(0.3).cgColor
        cell?.layer.cornerRadius = 8
        selectedColorNum = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Ваш код обработки нажатия на ячейку
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
    }
}

final class EmojiCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    var selectedEmojiNum: Int = 0
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Ваш код обработки нажатия на ячейку
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .ypLightGray
        cell?.layer.cornerRadius = 16
        selectedEmojiNum = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Ваш код обработки нажатия на ячейку
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .ypWhiteDay
    }
}



