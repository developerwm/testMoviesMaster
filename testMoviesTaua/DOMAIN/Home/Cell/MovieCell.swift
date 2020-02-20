
import UIKit
import Kingfisher

protocol MovieCellDelegate: class {
    func actionFavorite(cell: MovieCell)
}


class MovieCell: UICollectionViewCell {

    static let cellId = "cellMovieId"
    static let cellName = "MovieCell"
    var delegate: MovieCellDelegate?
    var movie = MovieResponse.ItemMovie()
    
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labeName: UILabel!
    @IBOutlet weak var labelAverage: UILabel!
    
    func setup(data: MovieResponse.ItemMovie) {
         self.movie = data
         viewBackground.layer.cornerRadius = 10
         labeName.text = self.movie.original_title
         labelGender.text = "Média: " + (self.movie.vote_average?.description ?? "0")
         labelAmount.text = "Quantidade: " + (self.movie.vote_count?.description ?? "0")
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgStar.isUserInteractionEnabled = true
        imgStar.addGestureRecognizer(tapGestureRecognizer)
        imgStar.image = imgStar.image?.withRenderingMode(.alwaysTemplate)
        
        if let image = self.movie.poster_path {
            let urlImage : String = Network.urlImage + image
            let url = URL(string: urlImage)
            
            img.kf.indicatorType = .activity
            img.kf.setImage(with: url)
        }
        
        self.setFavorite(favorite: data.favorite ?? false)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        delegate?.actionFavorite(cell: self)
    }
    
    func setFavorite(favorite: Bool) {
        if (favorite) {
            imgStar.tintColor = UIColor.red
        } else {
            imgStar.tintColor = UIColor.yellow
        }
    }
}
