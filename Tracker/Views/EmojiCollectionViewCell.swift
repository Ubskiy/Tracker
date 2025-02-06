//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Арсений Убский on 04.08.2023.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell{
    
    static let identifier = "EmojiCollectionViewCell"
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.layer.masksToBounds = true
        label.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        return label
    }()
    
    private let testEmojis: Array<String> = [
        "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏",
        "🍐", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆",
        "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅",
    ]
    
    private let canvasView: UIView = {
        let view = UIView()
        
        view.layer.masksToBounds = true
        view.heightAnchor.constraint(equalToConstant: 52).isActive = true
        view.widthAnchor.constraint(equalToConstant: 52).isActive = true
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
    
    func configure(emoji: String, at indexPath: IndexPath) {
        self.indexPath = indexPath
        emojiLabel.text = emoji
        canvasView.addSubview(emojiLabel)
    }
    
    private func makeViewLayout() {
        contentView.addSubview(canvasView)
        canvasView.addSubview(emojiLabel)
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            canvasView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            canvasView.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            
            emojiLabel.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: canvasView.centerYAnchor)
            
        ])
    }
}


