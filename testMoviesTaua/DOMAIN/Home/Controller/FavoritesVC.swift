
import UIKit
import RxSwift
import RxCocoa

class FavoritesVC: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    
    private let disposeBag = DisposeBag()
    private var listMovies = [MovieResponse.ItemMovie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI(collection: collection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listMovies.removeAll()
        populateList()
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
    
    private func populateList() {
        listMovies = RealmHelper.listFavorites() ?? [MovieResponse.ItemMovie()]
        collection.reloadData()
    }

}


extension FavoritesVC: UICollectionViewDataSource, UICollectionViewDelegate {
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
}


extension FavoritesVC: MovieCellDelegate {
    func actionFavorite(cell: MovieCell) {
        guard let indexPath = self.collection.indexPath(for: cell) else {
                 return
             }
          
        listMovies[indexPath.item].favorite = !(listMovies[indexPath.item].favorite ?? false)
        cell.setFavorite(favorite: listMovies[indexPath.item].favorite ?? false)
        
        if (listMovies[indexPath.item].favorite == false) {
           // RealmHelper.mountMovie(movie: listMovies[indexPath.item])
        }
    }
}


