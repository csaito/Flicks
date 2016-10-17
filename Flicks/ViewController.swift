//
//  ViewController.swift
//  Flicks
//
//  Created by Chihiro Saito on 10/15/16.
//  Copyright © 2016 Chihiro Saito. All rights reserved.
//

import UIKit
import AFNetworking
import CircularSpinner

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var movieSummaryList = [MovieSummary]()
    var filteredSummaryList = [MovieSummary]()
    var refreshControl: UIRefreshControl!
    var pageNumber = 1
    var isDataLoading = false
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    let CellIdentifier = "MovieItemTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieSearchBar.delegate = self
        movieTableView.estimatedRowHeight = 100
        initializeRefreshView()
        CircularSpinner.show(animated: true, type: CircularSpinnerType.indeterminate, showDismissButton: false, delegate: nil)
        self.isDataLoading = true
        MovieDataLoader.fetchNowPlayingData(pageNum: self.pageNumber, successCallback: self.successCallback, errorCallback: self.failureCallback)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func initializeRefreshView() {
        self.refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        movieTableView.insertSubview(refreshControl, at: 0)
    }
    
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        self.pageNumber = 1;
        MovieDataLoader.fetchNowPlayingData(pageNum: self.pageNumber, successCallback: self.successCallback, errorCallback: self.failureCallback)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath as IndexPath) as! MovieItemTableViewCell
        
        cell.titleLabel?.text = String("\(filteredSummaryList[indexPath.row].title!)")
        cell.descriptionTextView.text = String("\(filteredSummaryList[indexPath.row].description!)")

        if let posterPath: String = filteredSummaryList[indexPath.row].posterImagePath {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w92"
            let posterUrl = URL(string: posterBaseUrl + posterPath)
            cell.posterImageView.setImageWith(posterUrl!)
        }
        else if let backdropPath: String = filteredSummaryList[indexPath.row].backdropPath {
            let backdropBaseUrl = "http://image.tmdb.org/t/p/w780"
            let backdropUrl = URL(string: backdropBaseUrl + backdropPath)
            cell.posterImageView.setImageWith(backdropUrl!)
        } else {
            cell.posterImageView.image = nil
        }
        
        if (indexPath.row == self.movieSummaryList.count-1) {
            self.loadMoreData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSummaryList.count
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                 sender: Any?){
        let vc = segue.destination as! MovieDetailsViewController
        let selectedIndex = movieTableView.indexPath(for: sender as! UITableViewCell)!
        let movieSummary = filteredSummaryList[selectedIndex.row]
        vc.movieSummary = movieSummary
        if let posterPath: String = movieSummary.posterImagePath {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = URL(string: posterBaseUrl + posterPath)
            vc.posterImageURL = posterUrl
        } else if let backdropPath: String = movieSummary.backdropPath {
            let backdropBaseUrl = "http://image.tmdb.org/t/p/w780"
            let backdropUrl = URL(string: backdropBaseUrl + backdropPath)
            vc.posterImageURL = backdropUrl
        }
    }
    
 
    func successCallback(_ list: [MovieSummary]) {
        if (!list.isEmpty) {
            let firstMovie = list[0]
            if (self.movieExists(item: firstMovie)) {
                self.movieSummaryList = list
                self.filteredSummaryList = list
            } else {
                self.movieSummaryList += list
                self.filteredSummaryList += list
            }
        }
        self.movieTableView.reloadData()
        self.refreshControl.endRefreshing()
        CircularSpinner.hide()
        self.isDataLoading = false

    }
    
    func failureCallback(_ error: NSError?) -> Void {
        NSLog("data retrieval failed")
        self.refreshControl.endRefreshing()
        CircularSpinner.hide()
        self.displayAlert()
        self.isDataLoading = false
    }
    
    func movieExists(item: MovieSummary) -> Bool {
        // Inefficient, but reliable, way to get paging working quickly
        for movieSummary in movieSummaryList {
            if (movieSummary.id == item.id) {
                return true
            }
        }
        return false
    }
    
    func displayAlert() {
        
        let alertController = UIAlertController(title: "Oops", message: "Cannot find movie data.  Please try again later.", preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.filteredSummaryList = movieSummaryList
        } else {
            var filteredData = [MovieSummary]()
            for movieSummary in self.movieSummaryList {
                if let title = movieSummary.title {
                    let isRange = (title.range(of: searchText, options: .caseInsensitive) != nil)
                    if (isRange) {
                        filteredData.append(movieSummary)
                    }
                }
            }
            self.filteredSummaryList = filteredData
        }
        movieTableView.reloadData()
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            self.filteredSummaryList = movieSummaryList
        } else {
            var filteredData = [MovieSummary]()
            for movieSummary in self.movieSummaryList {
                if let title = movieSummary.title {
                    let isRange = (title.range(of: searchText, options: .caseInsensitive) != nil)
                    if (isRange) {
                        filteredData.append(movieSummary)
                    }
                }
            }
            self.filteredSummaryList = filteredData
        }
        movieTableView.reloadData()
    }
    
    func loadMoreData() {
        if (!self.isDataLoading) {
            self.isDataLoading = true
            self.pageNumber += 1
            MovieDataLoader.fetchNowPlayingData(pageNum: self.pageNumber, successCallback: self.successCallback, errorCallback: self.failureCallback)
        }
    }
    
}

