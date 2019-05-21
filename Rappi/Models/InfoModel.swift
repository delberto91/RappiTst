//
//  InfoModel.swift
//  Rappi
//
//  Created by Delberto Martinez on 5/17/19.
//  Copyright © 2019 Delberto Martinez. All rights reserved.
//

import Foundation

//MovieData model
open class MovieData {
    var title: String = ""
    var release_date: String = ""
    var overview: String = ""
    var poster_path: String = ""
    var vote_average: String = ""
    var backdrop_path: String = ""
    var original_language: String = ""
}

open class MovieDataResponse {
    var code: Int = 0
    var  data : [MovieData] = [MovieData]()
}

