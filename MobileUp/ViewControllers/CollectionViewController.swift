//
//  CollectionViewController.swift
//  MobileUp
//
//  Created by Artur Bilalov on 12.04.2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class CollectionViewController: UIViewController {
    
    var accessToken = ""
    
    var photoLoadDate = ""
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    private enum Constant {
        static let itemCount: CGFloat = 2
    }
    
    
    var photos = [String]()
    
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 4
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        getPhotos() // Получение данных о фотографиях
        
        collectionView.collectionViewLayout = layout
        view.addSubview(collectionView)
        
        
        // Создание кнопки "Выход" в Navigation Bar
            let logoutButton = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(logout))
            navigationItem.rightBarButtonItem = logoutButton
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        
        
        let topConstraint = self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let leadingConstraint = self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailingConstraint = self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let bottomConstraint = self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        NSLayoutConstraint.activate([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
        
    }
    
    
    
    private func itemSize(for width: CGFloat, with spacing: CGFloat) -> CGSize {
        let neededWidth = width - 4 * spacing
        let itemWidth = floor(neededWidth / Constant.itemCount)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    
    
    // Метод для выхода из аккаунта
    @objc func logout() {
        // Удаление токена доступа
        accessToken = ""
        
        // Переход на LoginViewController
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    // Функция для получения данных о фотографиях из VK API
    func getPhotos() {
        
        guard !accessToken.isEmpty else {
            print("Error: access token is empty")
            
            return
        }
        // ID альбома
        let albumId = "266276915"
        let ownerId = "-128666765"
        
        // URL для запроса данных о фотографиях
        let url = "https://api.vk.com/method/photos.get?access_token=\(accessToken)&owner_id=\(ownerId)&album_id=\(albumId)&v=5.81"
        
        // Запрос данных о фотографиях из VK API с использованием Alamofire
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                guard let items = json["response"]["items"].array else {
                    print("Error: response does not contain items array")
                    return
                }
                
                // Проход по всем элементам (фотографиям) и добавление URL в массив photos
                for item in items {
                    let photoUrl = item["sizes"][3]["url"].stringValue
                    self.photos.append(photoUrl)
                }
                
                
                
                // Получение даты загрузки каждой фотографии
                for item in items {
                    guard let photoId = item["id"].int else {
                        print("Error: could not get photo id")
                        continue
                    }
                    let photoUrl = "https://api.vk.com/method/photos.getById?access_token=\(self.accessToken)&photos=\(ownerId)_\(photoId)&v=5.81"
                    AF.request(photoUrl).responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            guard let uploadDate = json["response"][0]["date"].int else {
                                print("Error: could not get upload date")
                                return
                            }
                            let date = Date(timeIntervalSince1970: TimeInterval(uploadDate))
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd.MM.yyyy"
                            let dateString = formatter.string(from: date)
                            print("Photo id \(photoId) uploaded on \(dateString)")
                            self.photoLoadDate = dateString
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                
                
                // Обновление данных в коллекции
                self.collectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}



extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotosCollectionViewCell
        
        // Загрузка фотографии с помощью AlamofireImage и установка ее в imageView ячейки
        cell.photoView.af.setImage(withURL: URL(string: photos[indexPath.row])!)
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing
        return self.itemSize(for: collectionView.frame.width, with: spacing ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let expandedCell = ExpandedPhotoCell()
        expandedCell.delegate = self
        self.view.addSubview(expandedCell)
        expandedCell.imageExpandedCell.af.setImage(withURL: URL(string: photos[indexPath.item])!)
        expandedCell.photoUploadDate = photoLoadDate
        
        NSLayoutConstraint.activate([
            expandedCell.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expandedCell.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expandedCell.topAnchor.constraint(equalTo: view.topAnchor),
            expandedCell.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                expandedCell.buttonCancel.alpha = 1
                expandedCell.backgroundColor = .white
            }
        }
    }
}

extension CollectionViewController: ExpandedCellDelegate {
    func pressedButton(view: ExpandedPhotoCell) {
        view.removeFromSuperview()
    }
}

