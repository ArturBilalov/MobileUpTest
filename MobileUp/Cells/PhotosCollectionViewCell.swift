//
//  PhotosCollectionViewCell.swift
//  MobileUp
//
//  Created by Artur Bilalov on 12.04.2023.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
   
    
    
    lazy var photoView: UIImageView = {
        let photo = UIImageView()
        photo.contentMode = .scaleAspectFill
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.clipsToBounds = true
        return photo
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.photoView)
        
        let topConstraint = self.photoView.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        let leadingConstraint = self.photoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor)
        let trailingConstraint = self.photoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        let bottomConstraint = self.photoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        
        NSLayoutConstraint.activate([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoView.image = nil
    }
    
    
    
}
