/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A table view controller that displays filtered strings (used by other view controllers for simple displaying and filtering of data).
*/

import UIKit

class SearchControllerBaseViewController: UITableViewController {
    // MARK: - Properties

    var allResults: [Product] = []

    lazy var visibleResults: [Product] = self.allResults
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.register(MainTableViewCell.self)
        self.tableView.estimatedRowHeight = 225
        self.tableView.rowHeight = 225
    }

    /// A `nil` / empty filter string means show all results. Otherwise, show only results containing the filter.
    var filterString: String? = nil {
        didSet {
            if filterString == nil || filterString!.isEmpty {
                visibleResults = allResults
            } else {
                // Filter the results using a predicate based on the filter string.
                let filterPredicate = NSPredicate(format: "self contains[c] %@", argumentArray: [filterString!])

                visibleResults = allResults.filter { filterPredicate.evaluate(with: $0) }
            }

            tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MainTableViewCell
        
        let product = visibleResults[indexPath.row]
        cell.nameLabel.text = product.name
        cell.locationLabel.text = product.city
        
        cell.backgroundImage.sd_setImage(with: URL(string: product.productImageUrl!), placeholderImage: #imageLiteral(resourceName: "show_1"))
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        self.present(vc!, animated: true, completion: nil)
    }
}
