//
//  MovieDetailLayout.swift
//  MilitaryChannel
//
//  Created by Fumitoshi Ogata on 2015/12/24.
//  Copyright © 2015年 Fumitoshi Ogata. All rights reserved.
//

import UIKit

class MovieDetailLayout: UITableViewCell {
    
    @IBOutlet weak var movieView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(titleText:String,videoId:String){
        self.titleLabel.text = titleText
        self.detailLabel.text = "aaaaaaaaa"
        let url_string = "https://www.youtube.com/embed/" + videoId + "?feature=player_detailpage"
        let url:NSURL = NSURL(string: url_string)!
        let urlRequest: NSURLRequest = NSURLRequest(URL: url)
        self.movieView.allowsInlineMediaPlayback = true;
        self.movieView.loadRequest(urlRequest)
    }
}

