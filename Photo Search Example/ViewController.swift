//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Kyle Scholl on 1/11/16.
//  Copyright © 2016 Patronus LLC. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController {

	@IBOutlet var scrollView: UIScrollView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let manager = AFHTTPSessionManager()
		
		// "https://api.instagram.com/v1/tags/kscholl16/media/recent?client_id=c4fc61c4704949baab8825cf178e13fe"
		// 787b724208d04670bb11a4e5fe22aef2
		// need an access_code, not client_id
		
		//	Mine
		//	https://api.instagram.com/v1/tags/latergram/media/recent?client_id=787b724208d04670bb11a4e5fe22aef2
		
		// Mr. Day's
		//
		
		// Thinkful's
		// https://api.instagram.com/v1/tags/clararockmore/media/recent?client_id=c4fc61c4704949baab8825cf178e13fe
		
		let myID : String = "787b724208d04670bb11a4e5fe22aef2"
		let mrDayID : String =    "c4fc61c4704949baab8825cf178e13fe"
		let thinkfulID : String = "c4fc61c4704949baab8825cf178e13fe"
		
		var searchString : String = "kscholl16"
		searchString = "clararockmore"
		let url = "https://api.instagram.com/v1/tags/\(searchString)/media/recent?client_id=\(thinkfulID)"
		
		manager.GET(url,
			parameters: nil,
			progress: nil,
			success: { (operation: NSURLSessionDataTask,responseObject: AnyObject?) in
				print("Success")
				if let responseObject = responseObject {
					print("Response: " + responseObject.description)
				}
				
				if let dataArray = responseObject!["data"] as? [AnyObject] {
					var urlArray:[String] = []
					for dataObject in dataArray {
						if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
							urlArray.append(imageURLString)
						}
					}
					
					self.scrollView.contentSize = CGSizeMake(320, 320 * CGFloat(dataArray.count))
					
					for var i = 0; i < urlArray.count; i++ {
						let imageData = NSData(contentsOfURL: NSURL(string: urlArray[i])!)
						if let imageDataUnwrapped = imageData {
							let imageView = UIImageView(image: UIImage(data: imageDataUnwrapped))
							imageView.frame = CGRectMake(0, 320 * CGFloat(i), 320, 320)
							self.scrollView.addSubview(imageView)
						}
					}
				}
			},
			
			failure: { (operation: NSURLSessionDataTask?,error: NSError) in
				print("Failure")
				print("Error: " + error.localizedDescription)
		})
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

