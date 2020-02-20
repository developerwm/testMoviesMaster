
import UIKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionMovies: UICollectionView!
    
    private let disposeBag = DisposeBag()
    private var listMovies = [MovieResponse.ItemMovie]()
    private var pagination: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(collection: collectionMovies)
        getMovies(page: pagination)
    }
    
    private func setupUI(collection: UICollectionView) {
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .white
        collection.register(UINib(nibName: MovieCell.cellName, bundle: nil), forCellWithReuseIdentifier: MovieCell.cellId)
        
        let layout = UICollectionViewFlowLayout()
        let screenSize = UIScreen.main.bounds.size
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenSize.width / 2, height: 372)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collection.collectionViewLayout = layout
    }
    
    func getMovies(page: Int) {
        Network.getMovies(page: page).subscribe(
            onNext: { [weak self] movies in
                guard movies.count > 0 else {
                    return
                }
                for data in movies {
                    self?.listMovies.append(data)
                }
                self?.collectionMovies.reloadData()
            },
            onError: { [weak self] error in
        }).disposed(by: disposeBag)
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.cellId,
                                                            for: indexPath as IndexPath) as? MovieCell else {
                                                                return UICollectionViewCell()
        }
        
        cell.delegate = self
        cell.setup(data: self.listMovies[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == listMovies.count - 1 {
            self.pagination += 1
            self.getMovies(page: pagination)
        }
    }
    
}


extension HomeVC: MovieCellDelegate {
    func actionFavorite(cell: MovieCell) {
        guard let indexPath = self.collectionMovies.indexPath(for: cell) else {
                 return
             }
          
        listMovies[indexPath.item].favorite = !(listMovies[indexPath.item].favorite ?? false)
        cell.setFavorite(favorite: listMovies[indexPath.item].favorite ?? false)
        
        if (listMovies[indexPath.item].favorite ?? false) {
            RealmHelper.mountMovie(movie: listMovies[indexPath.item])
        }
    }
}
