//
//  ArticleViewController.swift
//  MilitaryChannel
//
//  Created by Fumitoshi Ogata on 2015/12/17.
//  Copyright © 2015年 Fumitoshi Ogata. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArticleViewController: UIViewController {
    
    var activityIndicator : UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backButtonDidTouch(sender: AnyObject){
        //開いたmodalをまとめて閉じる
        self.delegate.window!.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var loadedArticles : Array<Dictionary<String,AnyObject>> = []
    var loadedArticles2 : Array<Dictionary<String,AnyObject>> = []
    var lvideoId : String = ""
    var firstLoadTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //xibからテンプレートを読み込みして、Identifierに登録する
        let nib_detail:UINib = UINib(nibName: "MovieDetailLayout", bundle: nil)
        self.tableView.registerNib(nib_detail, forCellReuseIdentifier: "movie_detail_layout")
        let nib_cell:UINib = UINib(nibName: "CustomCellLayout", bundle: nil)
        self.tableView.registerNib(nib_cell, forCellReuseIdentifier: "custom_cell_layout")
        
        //動画の詳細データを取得する
        let localVideoId2 :String = self.delegate.videoId2
        let url = Const.API_ENDPOINT_VIDEOS + "?key=" + Const.API_KEY + "&part=snippet&id=" + localVideoId2
        Alamofire.request(.GET, url).responseJSON { response in
            let json = JSON(response.result.value!)
            for (_,subJson):(String, JSON) in json["items"] {
                var dic = Dictionary<String, AnyObject>()
                dic["videoId"] = subJson["id"].string!
                dic["title"] = subJson["snippet"]["title"].string!
                dic["description"] = subJson["snippet"]["description"].string!
                dic["url"] = subJson["snippet"]["thumbnails"]["default"]["url"].string!
                dic["width"] = 120
                dic["height"] = 90
                dic["published_at"] = subJson["snippet"]["publishedAt"].string!
                dic["channelId"] = subJson["snippet"]["channelId"].string!
                self.loadedArticles.append(dic)
            }
        }
        
        //関連動画リストを作成する
        let url2 = Const.API_ENDPOINT_SEARCH + "?part=snippet&order=viewCount&key=" + Const.API_KEY + "&q=" + "f16,f22" + "&maxResults=50"
        Alamofire.request(.GET, url2).responseJSON { response in
            let json = JSON(response.result.value!)
            for (_,subJson):(String, JSON) in json["items"] {
                var dic = Dictionary<String, AnyObject>()
                dic["videoId"] = String(subJson["id"]["videoId"])
                dic["title"] = subJson["snippet"]["title"].string!
                dic["description"] = subJson["snippet"]["description"].string!
                dic["url"] = subJson["snippet"]["thumbnails"]["default"]["url"].string!
                dic["width"] = 120
                dic["height"] = 90
                dic["published_at"] = subJson["snippet"]["publishedAt"].string!
                self.loadedArticles2.append(dic)
            }
            self.tableView.reloadData()
        }
        
        
        let view1 = UIView(frame: UIScreen.mainScreen().bounds)
        view1.tag = 103
        self.view.addSubview(view1)
                
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 32,height: 32))
        activityIndicator.center = view.center
        activityIndicator.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.White
        view.addSubview(activityIndicator)
    }
    
    func videoStarted(notification:NSNotification) {
        print("video started------------------------------")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.isFull = true
        //self.view.transform = CGAffineTransformScale(self.view.transform, 1, -1);
    }
    
    
    func videoFinished(notification:NSNotification) {
        print("video finished------------------------------")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.isFull = false
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView:UIWebView){
        activityIndicator.stopAnimating()
        let view = self.view.viewWithTag(103)
        view?.removeFromSuperview()
        firstLoadTime = 1
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        if firstLoadTime == 0{
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }

    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.loadedArticles.count + self.loadedArticles2.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath:NSIndexPath!) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("movie_detail_layout") as! MovieDetailLayout
            cell.setCell(
                self.loadedArticles[0]["title"] as! String,
                videoId: self.loadedArticles[0]["videoId"] as! String
            )
            return cell
        }else{
            let cell2 = tableView.dequeueReusableCellWithIdentifier("custom_cell_layout") as! CustomCellLayout
            cell2.setCell(
                self.loadedArticles2[indexPath.row-1]["title"] as! String,
                descriptionText: "description",
                published_at: "aaaa",
                thumbnailUrl: self.loadedArticles2[indexPath.row-1]["url"] as! String
            )
            return cell2
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 380
        }else{
            return 100
        }
    }
    
    // Cell が選択された場合
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        let localVideoId : String = self.loadedArticles2[indexPath.row-1]["videoId"] as! String
        self.delegate.videoId2 = localVideoId
        var nex = UIViewController()
        let selfStoryboard = self.storyboard
        nex = selfStoryboard!.instantiateViewControllerWithIdentifier("SID_article_view_controller") as UIViewController
        self.presentViewController(nex, animated: true, completion: nil)
    }
}
