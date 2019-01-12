//
//  FeedCell.swift
//  ReadingHeadlines
//
//  Created by freakytune on 2019/1/11.
//  Copyright © 2019 freakytune. All rights reserved.
//

import UIKit

protocol Favorited {
    func clickFavored(cell: UITableViewCell)
}

class FeedCell: UITableViewCell {
    
    var delegate: Favorited?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //backgroundColor = .red
        let favoriteButton = UIButton(type: .system)
        favoriteButton.setImage(UIImage(named: "heart.png"), for: .normal)
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        // favoriteButton.tintColor = .red
        favoriteButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
        
        
        
        
        accessoryView = favoriteButton
        
        
    }
    
    @objc private func handleMarkAsFavorite() {
        print("Marking as Favorites")
        delegate?.clickFavored(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
