//
//  MovieDetailsViewController.swift
//  Flicks
//

import AFNetworking
import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var detailsScrollView: UIScrollView!
    @IBOutlet weak var detailsContainerView: UIView!
    
    var movieSummary: MovieSummary?
    var posterImageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = movieSummary!.title
        descriptionTextView.text = movieSummary!.description
        if let posterURL: URL = posterImageURL {
            posterImageView.setImageWith(posterURL)
        }
        releaseDateLabel.text = movieSummary!.releaseDate
        if let voteAverage: Int = movieSummary!.voteAverage {
            durationLabel.text = String("\(voteAverage) / 10 (\(movieSummary!.voteCount!) votes)")
        }
        
        self.descriptionTextView.sizeToFit()
        self.detailsContainerView.sizeToFit()
        
        let contentWidth = detailsContainerView.bounds.width
        let contentHeight = detailsContainerView.bounds.height * 1.5
        detailsScrollView.contentSize = CGSize.init(width: contentWidth, height: contentHeight)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
