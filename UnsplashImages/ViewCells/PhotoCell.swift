//
//  PhotoCell.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 05.09.2021.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    static let identifier = String(describing: PhotoCell.self)
    
     let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return imageView
    }()
    
    
    var unsplashPhoto: UnsplashPhoto! {
        didSet {
            let photoURL = unsplashPhoto.urls.thumb
            imageView.sd_setImage(with: photoURL, completed: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        //contentView.addSubview(label)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        //label.text = nil
    }
    
    func configure(with url: URL, title: String?) {
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }

            DispatchQueue.main.async {
                let image = UIImage(data: data)

                if let topicTitle = title {
                    //self?.label.text = topicTitle
                    self?.imageView.image = image?.darkened()
                    self?.imageView.layer.cornerRadius = 10.0
                    print(topicTitle)
                } else {
                    self?.imageView.image = image
                }
            }
        }
        task.resume()
        
    }
    
}





