
import Foundation
import RxSwift
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class Network {
    
    let networkQueue = DispatchQueue(label: "com.appName.networkQueue")
    static var urlMovie: String = "https://api.themoviedb.org/4/discover/tv?api_key=c5850ed73901b8d268d0898a8a9d8bff&language=pt-BR"
    static var urlImage: String = "https://image.tmdb.org/t/p/w500"
    
    enum GetMoviesFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
    
    typealias GetMoviesResult = Result<[MovieResponse]>
    typealias GetMoviesCompletion = (_ result: GetMoviesResult) -> Void
    
    static func getMovies(page: Int) -> Observable<[MovieResponse.ItemMovie]> {
        let page: String = "&page=" + page.description
        
        return Observable.create { observer -> Disposable in
            Alamofire.request(urlMovie + page, method: .get, parameters: nil).responseObject { (response: DataResponse<MovieResponse>) in
                
                switch response.result {
                case .success:
                    let dataResponse: MovieResponse = response.result.value ?? MovieResponse()
                    observer.onNext(dataResponse.results ?? [MovieResponse.ItemMovie()])
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
            
        }
        
    }
    
}
