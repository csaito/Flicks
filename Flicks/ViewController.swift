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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var movieSummaryList = [MovieSummary]()
    @IBOutlet weak var movieTableView: UITableView!
    let CellIdentifier = "MovieItemTableViewCell"
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.estimatedRowHeight = 100
        initializeRefreshView()
        CircularSpinner.show(animated: true, type: CircularSpinnerType.indeterminate, showDismissButton: false, delegate: nil)
        MovieDataLoader.fetchNowPlayingData(successCallback: self.successCallback, errorCallback: self.failureCallback)
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
        MovieDataLoader.fetchNowPlayingData(successCallback: self.successCallback, errorCallback: self.failureCallback)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath as IndexPath) as! MovieItemTableViewCell
        
        cell.titleLabel?.text = String("\(movieSummaryList[indexPath.row].title!)")
        cell.descriptionTextView.text = String("\(movieSummaryList[indexPath.row].description!)")

        if let posterPath: String = movieSummaryList[indexPath.row].posterImagePath {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w92"
            let posterUrl = URL(string: posterBaseUrl + posterPath)
            cell.posterImageView.setImageWith(posterUrl!)
        }
        else if let backdropPath: String = movieSummaryList[indexPath.row].backdropPath {
            let backdropBaseUrl = "http://image.tmdb.org/t/p/w780"
            let backdropUrl = URL(string: backdropBaseUrl + backdropPath)
            cell.posterImageView.setImageWith(backdropUrl!)
        } else {
            cell.posterImageView.image = nil
        }
        
        //cell.posterImageView.setImageWith(URL(string: "http://image.tmdb.org/t/p/w92/z6BP8yLwck8mN9dtdYKkZ4XGa3D.jpg")!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieSummaryList.count
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                 sender: Any?){
        let vc = segue.destination as! MovieDetailsViewController
        let selectedIndex = movieTableView.indexPath(for: sender as! UITableViewCell)!
        let movieSummary = movieSummaryList[selectedIndex.row]
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
        self.movieSummaryList = list
        self.movieTableView.reloadData()
        self.refreshControl.endRefreshing()
        CircularSpinner.hide()

    }
    
    func failureCallback(_ error: NSError?) -> Void {
        NSLog("data retrieval failed")
        self.refreshControl.endRefreshing()
        CircularSpinner.hide()
        self.displayAlert()
        
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
    
}

