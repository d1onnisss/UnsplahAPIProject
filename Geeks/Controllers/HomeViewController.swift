//  ViewController.swift
//  Geeks
//
//  Created by Alexey Lim on 12/8/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private var unsplashPhotos: [UnsplashPhoto] = []
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var verticalCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let verticalCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        verticalCV.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        verticalCV.dataSource = self
        verticalCV.delegate = self
        verticalCV.alwaysBounceVertical = true
        return verticalCV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        getData()
        NetworkManager.shared.authentication()
        verticalCV.refreshControl = refreshControl
    }
    
    @objc private func refreshData(sender: UIRefreshControl) {
        getData()
    }
    
    func getData() {
        NetworkManager.shared.fetchPhotos { photos in
            DispatchQueue.main.async {
                self.unsplashPhotos = photos
                self.verticalCV.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func setupConstraints() {
        view.addSubview(verticalCV)
        verticalCV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        let photo = unsplashPhotos[indexPath.item]
        cell.configure(with: photo)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20) / 2
        return CGSize(width: width, height: width)
    }
}
