//
//  ExpandedPhotoCell.swift
//  MobileUp
//
//  Created by Artur Bilalov on 12.04.2023.
//

import UIKit

import UIKit
import AlamofireImage


protocol ExpandedCellDelegate: AnyObject {
    func pressedButton(view: ExpandedPhotoCell)
}

class ExpandedPhotoCell: UIView {
    weak var delegate: ExpandedCellDelegate?
    var pressButtonCancel = UITapGestureRecognizer()
    
    
    var photoUploadDate: String? {
        didSet {
            dateLabel.text = photoUploadDate
        }
    }
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var imageExpandedCell: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.backgroundColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var buttonCancel: UIImageView = {
        let button = UIImageView()
        button.image = UIImage(systemName: "multiply.square")
        button.tintColor = .black
        button.alpha = 1
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var buttonShare: UIImageView = {
        let button = UIImageView()
        button.image = UIImage(systemName: "square.and.arrow.up")
        button.tintColor = .black
        button.alpha = 1
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var buttonSave: UIImageView = {
        let button = UIImageView()
        button.image = UIImage(systemName: "square.and.arrow.down.on.square")
        button.tintColor = .black
        button.alpha = 1
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    private var pinchGesture = UIPinchGestureRecognizer()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        drawSelf()
        setupGesture()
        setupPinchGesture()

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with photoUrl: String, date: String) {
        imageExpandedCell.af.setImage(withURL: URL(string: photoUrl)!)
        dateLabel.text = date
    }
    
    private func drawSelf() {
        self.addSubview(imageExpandedCell)
        self.addSubview(buttonCancel)
        self.addSubview(buttonShare)
        self.addSubview(buttonSave)
        
        self.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            imageExpandedCell.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageExpandedCell.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageExpandedCell.widthAnchor.constraint(equalTo: self.widthAnchor),
            imageExpandedCell.heightAnchor.constraint(equalTo: self.widthAnchor),
            
            
            buttonCancel.topAnchor.constraint(equalTo: self.topAnchor),
            buttonCancel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            buttonCancel.widthAnchor.constraint(equalToConstant: 30),
            buttonCancel.heightAnchor.constraint(equalToConstant: 30),
            
            buttonShare.topAnchor.constraint(equalTo: self.topAnchor),
            buttonShare.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            buttonShare.widthAnchor.constraint(equalToConstant: 30),
            buttonShare.heightAnchor.constraint(equalToConstant: 30),
            
            buttonSave.topAnchor.constraint(equalTo: self.topAnchor),
            buttonSave.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60),
            buttonSave.widthAnchor.constraint(equalToConstant: 30),
            buttonSave.heightAnchor.constraint(equalToConstant: 30),
            
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            
        ])
    }
    
    private func setupPinchGesture() {
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureAction(_:)))
        imageExpandedCell.isUserInteractionEnabled = true
        imageExpandedCell.addGestureRecognizer(pinchGesture)
    }

    @objc func pinchGestureAction(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        view.transform = view.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
        gestureRecognizer.scale = 1.0
    }
    
    
    private func setupGesture() {
        pressButtonCancel.addTarget(self, action: #selector(pressedButton(_:)))
        buttonCancel.addGestureRecognizer(pressButtonCancel)
        buttonSave.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveImage)))
        buttonShare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareImage)))
    }
    
    @objc func pressedButton(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.pressedButton(view: self)
    }
    
    @objc func saveImage() {
        guard let image = imageExpandedCell.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Обработка ошибки сохранения изображения
            print("Ошибка сохранения изображения: \(error.localizedDescription)")
        } else {
            // Оповещение об успешном сохранении изображения
            let alert = UIAlertController(title: "Изображение сохранено", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
        }
    }
    
    @objc func shareImage() {
        guard let image = imageExpandedCell.image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    
}

