import Foundation

struct CollectionWidthParameters {
    let cellsNumber: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let interCellSpacing: CGFloat
    
    var widthInsets: CGFloat {
        return interCellSpacing * CGFloat(cellsNumber - 1) + leftInset + rightInset
    }
}
