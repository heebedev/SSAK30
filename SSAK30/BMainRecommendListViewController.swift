//
//  RecommendListViewController.swift
//  MyNetflix
//
//  Created by joonwon lee on 2020/04/02.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit

class BMainRecommendListViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var lblrecentSellProduct: UILabel!
    let viewModel = RecommentListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        lblrecentSellProduct.text = viewModel.type.title
    }
    
    // UICollectionViewDelegate
    // 셀이 클릭되었을때 어쩔꺼야? >> DetailView로 연결해야함!! //////////
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath.item)
    }
}//---


// UICollectionViewDataSource
extension BMainRecommendListViewController: UICollectionViewDataSource {
    // 몇개 보여줄까요?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfItems
    }
    
    //셀은 어떻게 표현할거야?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommendCell else {
            return UICollectionViewCell()
        }
        
        let movie = viewModel.item(at: indexPath.item)
        cell.updateUI(movie: movie)
        return cell
    }
}


class RecommentListViewModel {
    enum RecommendingType {
        case recent
        case hot
        case interest
        
        var title: String {
            switch self {
            case .recent: return "최근 등록된 떠리"
            case .hot: return "우리동네 인기 매장"
            case .interest: return "관심매장 최근 떠리"
            
            }
        }
    }
    
    private (set) var type: RecommendingType = .interest
    private var items: [DummyItem] = []
    
    var numOfItems: Int {
        return items.count
    }
    
    func item(at index: Int) -> DummyItem {
        return items[index]
    }
    
    func updateType(_ type: RecommendingType) {
        self.type = type
    }
    
    func fetchItems() {
        self.items = MovieFetcher.fetch(type)
    }
}

class RecommendCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    func updateUI(movie: DummyItem) {
        thumbnailImage.image = movie.thumbnail
    }
    
    
    
    
}

class MovieFetcher {
    static func fetch(_ type: RecommentListViewModel.RecommendingType) -> [DummyItem] {
        switch type {
        case .recent:
            let movies = (1..<10).map { DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!) }
            return movies
        case .hot:
            let movies = (10..<19).map { DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!) }
            return movies
        case .interest:
            let movies = (1..<10).map { $0 * 2 }.map { DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!) }
            return movies
        }
    }
}

struct DummyItem {
    let thumbnail: UIImage
}
