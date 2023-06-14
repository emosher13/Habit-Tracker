//
//  QuoteViewController.swift
//  Habit Tracker
//
//  Created by Ethan Mosher on 5/17/23.
//

import Foundation
import UIKit

class QuoteViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    var quoteViewModel = QuoteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quoteLabel.textColor = .white
        
        quoteViewModel.delegate = self
        quoteViewModel.fetchRandomQuote()
    }
}

extension QuoteViewController: QuoteViewModelDelegate {
    func didFetchRandomQuote(quote: String, author: String) {
        DispatchQueue.main.async {
            self.quoteLabel.text = "\(quote) - \(author)"
        }
    }
    
    func didFailToFetchQuote(with error: Error) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
