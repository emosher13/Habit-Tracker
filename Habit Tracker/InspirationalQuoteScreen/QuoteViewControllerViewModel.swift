//
//  QuoteViewControllerViewModel.swift
//  Habit Tracker
//
//  Created by Ethan Mosher on 5/30/23.
//

import Foundation

import Foundation

protocol QuoteViewModelDelegate: AnyObject {
    func didFetchRandomQuote(quote: String, author: String)
    func didFailToFetchQuote(with error: Error)
}

struct QuoteViewModel {
    weak var delegate: QuoteViewModelDelegate?
    
    func fetchRandomQuote() {
        let urlString = "https://zenquotes.io/api/random"
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            delegate?.didFailToFetchQuote(with: error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                delegate?.didFailToFetchQuote(with: error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                delegate?.didFailToFetchQuote(with: error)
                return
            }
            
            do {
                let quotes = try JSONDecoder().decode([Quote].self, from: data)
                if let quote = quotes.first {
                    delegate?.didFetchRandomQuote(quote: quote.text, author: quote.author)
                } else {
                    let error = NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse quote"])
                    delegate?.didFailToFetchQuote(with: error)
                }
            } catch {
                delegate?.didFailToFetchQuote(with: error)
            }
        }
        
        task.resume()
    }
}



//import Foundation
//import UIKit
//
//protocol QuoteManagerDelegate {
//    func didUpdateQuote(quote: QuoteModel)
//}
//
//struct QuoteManager {
//
//    let quoteURL = "https://zenquotes.io/api/random"
//    var delegate: QuoteManagerDelegate?
//
//    func fetchQuote() {
//        let urlString = quoteURL
//        performRequest(urlString: urlString)
//    }
//
//    func performRequest(urlString: String) {
//        if let url = URL(string: urlString) {
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: url) { (data, response, error) in
//                if let error = error {
//                    DispatchQueue.main.async {
//                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    }
//                    print(error)
//                    return
//                }
//                if let safeData = data {
//                    if let quote = self.parseJSON(quoteData: safeData) {
//                        self.delegate?.didUpdateQuote(quote: quote)
//                    }
//                }
//            }
//            task.resume()
//        }
//    }
//
//    func parseJSON(quoteData: Data) -> QuoteModel? {
//        let decoder = JSONDecoder()
//        do {
//            let decodedData = try decoder.decode(QuoteModel.self, from: quoteData)
//            let q = decodedData.q
//            let a = decodedData.a
//
//            let quote = QuoteModel(q: q, a: a)
//            return quote
//        } catch {
//            print(error)
//            return nil
//        }
//    }
//}
