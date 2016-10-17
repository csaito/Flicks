//
//  MovieDataLoader.swift
//  Flicks
//

import Foundation

class MovieDataLoader {
    
    static let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    class func fetchNowPlayingData(pageNum: Int, successCallback: @escaping ([MovieSummary]) -> Void, errorCallback: ((NSError?) -> Void)?) {
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&page=\(pageNum)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let requestError = error {
                errorCallback?(requestError as NSError?)
            }
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    //NSLog("response: \(responseDictionary)")
                    createMovieSummaryList(responseDictionary: responseDictionary, successCallback: successCallback)
                } else {
                    errorCallback?(nil)
                }
            }
        });
        task.resume()
    }
    
    class func createMovieSummaryList(responseDictionary: NSDictionary, successCallback: ([MovieSummary]) -> Void) {
        let results = responseDictionary["results"] as! NSArray
        var movieSummaryList = [MovieSummary]()
        for result in results {
            let movieData = result as! NSDictionary
            
            if let movieId = movieData["id"] as? NSNumber {
                let movieSummary = MovieSummary(id: movieId,
                                                posterImagePath: movieData["poster_path"] as? String,
                                                title: movieData["title"] as? String,
                                                description: movieData["overview"] as? String,
                                                releaseDate: movieData["release_date"] as? String,
                                                backdropPath: movieData["backdrop_path"] as? String,
                                                voteAverage: movieData["vote_average"] as? Int,
                                                voteCount: movieData["vote_count"] as? Int
                );
                movieSummaryList.append(movieSummary)
            }
        }
        successCallback(movieSummaryList)
    }
    
}

struct MovieSummary {
    var id: NSNumber
    var posterImagePath : String?
    var title: String?
    var description: String?
    var releaseDate: String?
    var backdropPath : String?
    var voteAverage: Int?
    var voteCount: Int?
}

struct MovieDetails {
    
}
