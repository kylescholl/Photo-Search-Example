//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Kyle Scholl on 1/11/16.
//  Copyright © 2016 Patronus LLC. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController, UISearchBarDelegate {

	@IBOutlet var scrollView: UIScrollView!
	
	
	//MARK: ViewController lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		searchInstagramByHashtag("dogs")
	}
	
	//MARK: Utility methods
	func searchInstagramByHashtag(searchString:String) {
		let manager = AFHTTPSessionManager()
		
		//var myID : String        = "787b724208d04670bb11a4e5fe22aef2"
		//var mrDayID : String     = "c4fc61c4704949baab8825cf178e13fe"
		let thinkfulID : String  = "c4fc61c4704949baab8825cf178e13fe"
		
		manager.GET("https://api.instagram.com/v1/tags/\(searchString)/media/recent?client_id=\(thinkfulID)",
			parameters: nil,
			progress: nil,
			success: { (operation: NSURLSessionDataTask,responseObject: AnyObject?) in
				if let responseObject = responseObject {
					if let dataArray = responseObject["data"] as? [AnyObject] {
						var urlArray:[String] = []
						for dataObject in dataArray {
							if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
								urlArray.append(imageURLString)
							}
						}
						//display urlArray in ScrollView
						self.scrollView.contentSize = CGSizeMake(320, 320 * CGFloat(dataArray.count))
						
						for var i = 0; i < urlArray.count; i++ {
							let imageView = UIImageView(frame: CGRectMake(0, 320*CGFloat(i), 320, 320))
							if let url = NSURL(string: urlArray[i]) {
								imageView.setImageWithURL( url)
								self.scrollView.addSubview(imageView)
							}
						}
						
					}
				}
			},
			failure: { (operation: NSURLSessionDataTask?,error: NSError) in
				print("Error: " + error.localizedDescription)
		})
		
	}
	//MARK: UISearchBarDelegate protocol methods
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		for subview in self.scrollView.subviews {
			subview.removeFromSuperview()
		}
		searchBar.resignFirstResponder()
		if let searchText = searchBar.text {
			searchInstagramByHashtag(searchText)
		}
		
	}
}


	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

