
import Foundation
import ObjectMapper
import RealmSwift

class MovieResponse: Object, Mappable {
    
    var results: [ItemMovie]?
  
    required init?(map: Map){
    }
    
    required init() {
        
    }
    
    func mapping(map: Map) {
        results <- map["results"]
    }

  class ItemMovie: Mappable {
    
    var poster_path: String?
    var backdrop_path: String?
    var original_title: String?
    var overview: String?
    var release_date: String?
    var popularity: Int?
    var vote_count: Int?
    var vote_average: Int?
    var favorite: Bool?
    
    required init?(map: Map){
    }
    
    init() {
    }
    
    func mapping(map: Map) {
      poster_path <- map["poster_path"]
      backdrop_path <- map["backdrop_path"]
      original_title <- map["name"]
      overview <- map["overview"]
      release_date <- map["release_date"]
      popularity <- map["popularity"]
      vote_count <- map["vote_count"]
      vote_average <- map["vote_average"]
     }
    }
}


