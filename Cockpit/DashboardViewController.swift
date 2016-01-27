//
//  DashboardViewController.swift
//  MilitaryChannel
//
//  Created by Fumitoshi Ogata on 2015/12/16.
//  Copyright © 2015年 Fumitoshi Ogata. All rights reserved.
//

import UIKit
import RMPScrollingMenuBarController
import UIKit
import Alamofire
import SwiftyJSON

class DashboardViewController: UITableViewController {
    
    var activityIndicator : UIActivityIndicatorView!
    var localRefreshControl : UIRefreshControl!
    var loadedArticles : Array<Dictionary<String,AnyObject>> = []
    var searchLabel : String!
    var delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //xibからテンプレートを読み込んで、Identifierを名付ける
        let nib_cell:UINib = UINib(nibName: "CustomCellLayout", bundle: nil)
        self.tableView.registerNib(nib_cell, forCellReuseIdentifier: "Nib_Article_View_Cell")
        
        //検索ワードを決める
        for (_,subJson):(String, JSON) in Const.KeyWord["list"] {
            if(subJson["name"].string == self.title)
            {
                self.searchLabel = subJson["q"].string!
            }
        }
        
        self.navigationController?.navigationBarHidden = true
        self.refresh();
        dispatch_async(dispatch_get_main_queue(),{
            self.tableView.reloadData()
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refresh(){
        let url = Const.API_ENDPOINT_SEARCH + "?part=snippet&order=viewCount&key=" + Const.API_KEY + "&q=" + self.searchLabel + "&maxResults=50"
        Alamofire.request(.GET, url).responseJSON { response in
            let json = JSON(response.result.value!)
            for (_,subJson):(String, JSON) in json["items"] {
                var dic = Dictionary<String, AnyObject>()
                dic["videoId"] = String(subJson["id"]["videoId"])
                dic["title"] = subJson["snippet"]["title"].string!
                dic["description"] = subJson["snippet"]["description"].string!
                dic["url"] = subJson["snippet"]["thumbnails"]["high"]["url"].string!
                dic["published_at"] = subJson["snippet"]["publishedAt"].string!
                self.loadedArticles.append(dic)
            }
            self.tableView.reloadData()
        }
    }
    
    // Cell が選択された場合
    override func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        // [indexPath.row] から画像名を探し、UImage を設定
        let localVideoId : String = self.loadedArticles[indexPath.row]["videoId"] as! String
        self.delegate.videoId2 = localVideoId
        if localVideoId != "" {
            performSegueWithIdentifier("SegID_Article_View",sender: nil)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180
    }
    
    // Segue 準備
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "SegID_Article_View") {
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.loadedArticles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("Nib_Article_View_Cell") as! CustomCellLayout
        cell.setCell(
            self.loadedArticles[indexPath.row]["title"] as! String,
            descriptionText: "description",
            published_at: "aaaa",
            thumbnailUrl: self.loadedArticles[indexPath.row]["url"] as! String
        )
        return cell
    }
    
    //スクロール時にヘッダーを隠す制御
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.setNavBarVisibility2(Double(scrollView.contentOffset.y))
    }
    
    func setNavBarVisibility2(scrollY : Double) {
        if (scrollY >= 60) {
            // 表示コンテンツの高さが画面サイズの高さ以上ならhidesBarsOnSwipeにtrueをセット
            parentViewController?.navigationController?.hidesBarsOnSwipe = true
        } else {
            // NavigationBar非表示の際に hidesBarsOnSwipe = false がセットされるとNavigationBarがずっと非表示になるので
            // 強制的にNavigationBarを表示しておく
            parentViewController?.navigationController?.navigationBarHidden = false
            parentViewController?.navigationController?.hidesBarsOnSwipe = false
        }
    }
}

