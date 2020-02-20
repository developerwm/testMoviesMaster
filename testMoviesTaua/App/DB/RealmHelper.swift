
import Foundation
import RealmSwift

class RealmHelper  {
    
    static func mountMovie(movie: MovieResponse.ItemMovie)  {
        let dataDB = MovieDB()
        dataDB.id = UUID().uuidString
        dataDB.name = movie.original_title ?? ""
        dataDB.image = movie.poster_path ?? ""
        dataDB.average = movie.vote_average?.description  ?? ""
        dataDB.total = movie.vote_count?.description ?? ""
        dataDB.favorite = movie.favorite ?? false
        
        RealmHelper.addFavorite(data: dataDB)
    }
    
    static func addFavorite(data: MovieDB) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(data, update: Realm.UpdatePolicy.modified)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    static func listFavorites() -> [MovieResponse.ItemMovie]? {
        var listObjects: [MovieResponse.ItemMovie] = []
        do {
            let realm = try Realm()
            let objects = realm.objects(MovieDB.self)
            
            for object in objects{
                let data = MovieResponse.ItemMovie()
                data.original_title = object.name
                data.favorite = object.favorite
                data.poster_path = object.image
                data.vote_average = Int(object.average)
                data.vote_count =  Int(object.total)
                
                listObjects += [data]
            }
        } catch let error as NSError {
            print(error)
        }
        return listObjects
    }
    
}
