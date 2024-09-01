//
//  FavoritesViewController.swift
//  Geeks
//
//  Created by Alexey Lim on 30/8/24.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private var favoritePhotos: [UnsplashPhoto] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        loadFavoritesFromStorage()
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addFavorite(photo: UnsplashPhoto) {
        if !favoritePhotos.contains(where: { $0.id == photo.id }) {
            favoritePhotos.append(photo)
            saveFavoritesToStorage()
            collectionView.reloadData()
        }
    }
    
    func removeFavorite(photo: UnsplashPhoto) {
        if let index = favoritePhotos.firstIndex(where: { $0.id == photo.id }) {
            favoritePhotos.remove(at: index)
            saveFavoritesToStorage()
            collectionView.reloadData()
        }
    }
    
    private func saveFavoritesToStorage() {
        if let data = try? JSONEncoder().encode(favoritePhotos) {
            UserDefaults.standard.set(data, forKey: "favorites")
        }
    }
    
    private func loadFavoritesFromStorage() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let savedPhotos = try? JSONDecoder().decode([UnsplashPhoto].self, from: data) {
            favoritePhotos = savedPhotos
        }
        collectionView.reloadData()
    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        let photo = favoritePhotos[indexPath.item]
        cell.configure(with: photo)
        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20) / 2
        return CGSize(width: width, height: width)
    }
}
