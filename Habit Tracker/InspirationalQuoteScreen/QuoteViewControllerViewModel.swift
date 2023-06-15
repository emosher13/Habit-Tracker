//
//  QuoteViewControllerViewModel.swift
//  Habit Tracker
//
//  Created by Ethan Mosher on 5/30/23.
//

import Foundation

import Foundation

//MARK: - Quote View Model Delegate

protocol QuoteViewModelDelegate: AnyObject {
    func didFetchRandomQuote(quote: String, author: String)
    func didFailToFetchQuote(with error: Error)
}

//MARK: - Quote Struct

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
