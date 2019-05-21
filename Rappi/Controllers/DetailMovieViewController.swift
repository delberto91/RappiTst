//
//  DetailMovieViewController.swift
//  Rappi
//
//  Created by Delberto Martinez on 5/19/19.
//  Copyright © 2019 Delberto Martinez. All rights reserved.
//

import UIKit

class DetailMovieViewController: UIViewController {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieOverview: UITextView!
    @IBOutlet weak var bckgImage: UIImageView!
    
    
    var movieName : String = ""
    var movieImage : String = "" 
    var overView : String = ""
    var releaseDt: String = ""
    var lngage: String = "" 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set navigation title.
        self.navigationItem.title = "Movie Review"
        
        //Create animation when the view Loads.
        UIView.animate(withDuration: 2.0, animations: {
            self.language.alpha = 1.0
            self.movieOverview.alpha = 1.0
            self.bckgImage.alpha = 0.3
            self.titleLabel.alpha = 1.0
            self.moviePoster.alpha = 1.0
        })
        
       //Assign the outlets to the passed values.
        language.text! = lngage
        releaseDate.text! = releaseDt
        movieOverview.text! = overView
        titleLabel.text! = movieName
        
        moviePoster.downloadImage(downloadURL: APIManager.sharedInstance.posterURL + movieImage) { (response) in
            
        }
        bckgImage.downloadImage(downloadURL: APIManager.sharedInstance.posterURL + movieImage) { (response) in
            
        }
        
    }
    
    
    
}

