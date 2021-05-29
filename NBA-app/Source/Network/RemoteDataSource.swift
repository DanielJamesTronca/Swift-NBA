//
//  RemoteDataSource.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation

class RemoteDataSource {
    
    // Static shared var to access RemoteDataSource
    static let shared: RemoteDataSource = RemoteDataSource()
    
    // Simple method to execute our network calls
    // We can improve this with Alamofire
    func execute<T: Decodable>(_ endpoint: String, requestType: HTTPMethodEnum, completion: @escaping (Result<T, Error>) -> Void) {
        
        let headers: [String:String] = [
            "x-rapidapi-key": "32799daa0dmsh5605c4a71af5876p174602jsnaa555ac3ba30",
            "x-rapidapi-host": "free-nba.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(
            url: NSURL(string: endpoint)! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )

        request.httpMethod = requestType.rawValue
        request.allHTTPHeaderFields = headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            do {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    preconditionFailure("No data")
                }
                
                // Return generics T after json decode
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
