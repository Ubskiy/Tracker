//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Арсений Убский on 04.08.2023.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ColorCollectionViewCell"
    
    private let canvasView: UIView = {
        let view = UIView()
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.heightAnchor.constraint(equalToConstant: 52).isActive = true
        view.widthAnchor.constraint(equalToConstant: 52).isActive = true
        
        return view
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        return view
    }()
    
    private var indexPath: IndexPath?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(at indexPath: IndexPath) {
        self.indexPath = indexPath
        canvasView.addSubview(colorView)
        colorView.backgroundColor = UIColor.selectionArray[indexPath.row]
    }
    
    private func makeViewLayout() {
        contentView.addSubview(canvasView)
        contentView.addSubview(colorView)
        
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: contentView.topAnchor),
            canvasView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: canvasView.centerYAnchor),
            
        ])
    }
    
    func didTapColor(at indexPath: IndexPath) -> Int {
        print(indexPath.row, "ABRACADABRA")
        return indexPath.row
    }
}

