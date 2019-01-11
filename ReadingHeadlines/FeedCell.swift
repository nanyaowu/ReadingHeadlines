//
//  FeedCell.swift
//  ReadingHeadlines
//
//  Created by freakytune on 2019/1/11.
//  Copyright © 2019 freakytune. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //backgroundColor = .red
        let favoriteButton = UIButton(type: .system)
        favoriteButton.setImage(UIImage(named: "star.png"), for: .normal)
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        favoriteButton.tintColor = .red
        favoriteButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
        
        
        
        
        accessoryView = favoriteButton
        
        
    }
    
    @objc private func handleMarkAsFavorite() {
        print("Marking as Favorites")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
