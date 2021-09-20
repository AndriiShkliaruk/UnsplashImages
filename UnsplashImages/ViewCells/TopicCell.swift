//
//  TopicCell.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 20.09.2021.
//

import UIKit
import SDWebImage

class TopicCell: PhotoCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.numberOfLines = 2
        label.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        
        return label
    }()
    
    var title: String! {
        didSet {
            label.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = contentView.bounds
        label.center = contentView.center
        imageView.layer.cornerRadius = 10.0
        label.layer.cornerRadius = 10.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
}
