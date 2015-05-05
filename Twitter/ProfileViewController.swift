//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Shuhui Qu on 5/5/15.
//  Copyright (c) 2015 Shuhui Qu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet weak var tweetTableView: UITableView!

    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!

    @IBOutlet weak var backButton: UIBarButtonItem!
    
    
    var user: User?
    var tweets: [Tweet] = [Tweet]()
    
    @IBAction func onBack(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.user == nil {
            self.user = User.currentUser
            backButton.enabled = false
        } else {
            backButton.enabled = true
        }
        
        if let url = self.user!.backgroundImageUrl {
            bannerView.setImageWithURL(NSURL(string: url))
        } else {
            bannerView.setImageWithURL(NSURL(string: "https://pbs.twimg.com/profile_banners/6253282/1347394302/mobile_retina"))
        }
        profileView.setImageWithURL(NSURL(string: self.user!.profileImageUrl!))
        profileView.layer.cornerRadius = 5;
        profileView.clipsToBounds = true;

        
        nameLabel.text = user!.name!
        usernameLabel.text = "@\(user!.screenname!)"
        tweetsLabel.text = "\(self.user!.numberOfTweets!)"
        followerLabel.text = "\(self.user!.numberOfFollowers!)"
        followingLabel.text = "\(self.user!.numberFollowing!)"
        
        
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        tweetTableView.estimatedRowHeight = 90.0;
        
        TwitterClient.sharedInstance.getUserTimeline(user!.screenname!, completion: {(tweets: [Tweet]?, error: NSError?) -> Void in
            if (tweets != nil) {
                self.tweets = tweets!
                self.tweetTableView.reloadData()
            } else {
                println("Failed to get the tweets \(error!)")
            }
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.index = indexPath.row
        return cell

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
