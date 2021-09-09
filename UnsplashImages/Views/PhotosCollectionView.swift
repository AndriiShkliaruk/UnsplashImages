////
////  PhotosCollectionView.swift
////  UnsplashImages
////
////  Created by Andrii Shkliaruk on 09.09.2021.
////
//
//import UIKit
//
//class PhotosCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
//
//    init(spacing: CGFloat) {
//        let layout = UICollectionViewFlowLayout()
//        
//        
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = spacing
//        layout.minimumInteritemSpacing = spacing
//        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
//        layout.itemSize = CGSize(width: self.frame.size.width / 2 - spacing * 1.5, height: self.frame.size.width / 2 - 15)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        
//        collectionView.register(PhotoCollectionViewCell.self,
//                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.backgroundColor = .systemBackground
//        collectionView.frame = self.bounds
//        self.addSubview(collectionView)
//    }
//    
//    
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return UICollectionViewCell()
//    }
//
//}
