//
//  ImageCollectionViewCell.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 05.09.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        label.frame = contentView.bounds.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        label.center = contentView.center
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = nil
    }
    
    func configure(with urlString: URL, title: String = "", cellType: PhotoCellType) {
        
        let task = URLSession.shared.dataTask(with: urlString) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                
                switch cellType {
                case .photo:
                    self?.imageView.image = image
                    self?.label.isHidden = true
                case .topic:
                    self?.imageView.image = image?.darkened()
                    self?.imageView.layer.cornerRadius = 10.0
                    self?.label.text = title
                }
                
                print(title)
            }
        }
        task.resume()
    }
    
}

enum PhotoCellType {
    case topic, photo
}

extension UIImage {
    
    fileprivate func darkened() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }

        guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
            return nil
        }

        // flip the image, or result appears flipped
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.translateBy(x: 0, y: -size.height)

        let rect = CGRect(origin: .zero, size: size)
        ctx.draw(cgImage, in: rect)
        UIColor(white: 0, alpha: 0.5).setFill()
        ctx.fill(rect)

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


