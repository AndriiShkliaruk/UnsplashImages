//
//  TopicsGridLayout.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 10.09.2021.
//

import UIKit

class TopicsGridLayout: UICollectionViewFlowLayout {
    
    let cellsInRow: Int
    let spaceBetweenCells: CGFloat
    
    init(cellsInRow: Int, spaceBetweenCells: CGFloat) {
        self.cellsInRow = cellsInRow
        self.spaceBetweenCells = spaceBetweenCells
        super.init()
    }
    
    override func prepare() {
        super.prepare()
        
        self.scrollDirection = .vertical
        self.minimumLineSpacing = spaceBetweenCells
        self.minimumInteritemSpacing = spaceBetweenCells
        self.sectionInset = UIEdgeInsets(top: spaceBetweenCells, left: spaceBetweenCells, bottom: spaceBetweenCells, right: spaceBetweenCells)
        
        guard let collectionView = collectionView else { return }
        let cellWidth = (collectionView.frame.width - (CGFloat(cellsInRow) + 1) * spaceBetweenCells) / CGFloat(cellsInRow)
        self.itemSize = CGSize(width: cellWidth, height: cellWidth)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
