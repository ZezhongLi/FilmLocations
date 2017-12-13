//
//  ViewController.swift
//  FilmLoctions
//
//  Created by Neil Li on 12/12/17.
//  Copyright © 2017 Li Zezhong. All rights reserved.
//
//  This is the main ViewController, displays list of movie informations, supporting sort of list
//  Dependency on ViewModel, TableView, injected by storyboard.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var viewModel : ViewModel!
    @IBOutlet weak var tableView: UITableView!
    private var sortByNameAsc = true // Flag used for sorting
    private var sortByYearAsc = true // Flag used for sorting
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 105
        tableView.rowHeight = UITableViewAutomaticDimension
        
        viewModel.fetchMovies {
            [unowned self] in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Storyboard responses click & segue
    // Call up actionsheet to implement the sort of list
    @IBAction func sortClick(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: "Sort list by following choices", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let byNameTitle = sortByNameAsc ? "By name ascending order" : "By name descending order"
        let byNameAction = UIAlertAction(title: byNameTitle, style: .default) { action in
            self.viewModel.sortMoviesByName(self.sortByNameAsc)
            self.sortByNameAsc = !self.sortByNameAsc
            self.sortByYearAsc = true
            self.tableView.reloadData()
        }
        alertController.addAction(byNameAction)
        
        let byYearTitle = sortByYearAsc ? "By year ascending order" : "By year descending order"
        let byYearAction = UIAlertAction(title: byYearTitle, style: .default) { action in
            self.viewModel.sortMoviesByYear(self.sortByYearAsc)
            self.sortByNameAsc = true
            self.sortByYearAsc = !self.sortByYearAsc
            self.tableView.reloadData()
        }
        alertController.addAction(byYearAction)
        self.present(alertController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! MovieCell
        let controller = segue.destination as! MapViewController
        controller.name = cell.nameLabel.text
        controller.year = cell.yearLabel.text
        controller.location = cell.locationLabel.text
    }
}

// MARK: - Extension UITableViewDataSource
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.nameLabel.text = viewModel.nameAtIndexPath(indexPath: indexPath)
        cell.yearLabel.text = viewModel.yearAtIndexPath(indexPath: indexPath)
        cell.locationLabel.text = viewModel.locationAtIndexPath(indexPath: indexPath)
        return cell
    }
}

// MARK: - Extension UITableViewDelegate
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}






