//
//  MoviesWorker.swift
//  JatAppTest
//
//  Created by Michael Tseitlin on 23.06.2022.
//

import Foundation

protocol MoviesWorkerProtocol {
    func getTopMovies(completion: @escaping CompletionResultHandler<TopMoviesResponseModel>)
}

final class MoviesWorker: MoviesWorkerProtocol {
    
    private enum WorkerError: Error {
        
        case invalidURL
        case emptyData
        
    }
    
    func getTopMovies(completion: @escaping CompletionResultHandler<TopMoviesResponseModel>) {
        guard let url = URL(string: Constants.stringUrl) else {
            completion(.failure(WorkerError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                completion(.failure(WorkerError.emptyData))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(TopMoviesResponseModel.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}
