//
//  HomeViewController.swift
//  Twitter
//
//  Created by Shuhui Qu on 5/5/15.
//  Copyright (c) 2015 Shuhui Qu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayLeftCenter: CGPoint!
    var trayRightCenter: CGPoint!
    
    var contentOriginalCenter: CGPoint!
    var contentLeftCenter: CGPoint!
    var contentRightCenter: CGPoint!

    var burgerViewControllers: [String: UIViewController]?
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var mentionButton: UIButton!
    
    var sideTabOn = false
    
    @IBAction func onSwipe(sender: UIPanGestureRecognizer) {
        var point = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        println("taped")
        if sender.state == UIGestureRecognizerState.Began{
            trayOriginalCenter = trayView.center
            contentOriginalCenter = contentView.center
        }else if sender.state == UIGestureRecognizerState.Changed{
            if(trayView.center.x < trayRightCenter.x + 10 && trayView.center.x > trayLeftCenter.x - 10){
                trayView.center = CGPoint(x: trayView.center.x + translation.x, y: trayView.center.y)
                contentView.center = CGPoint(x: contentView.center.x + translation.x, y: contentView.center.y)
                sender.setTranslation(CGPointZero, inView: self.view)
            }
            
        }else if sender.state == UIGestureRecognizerState.Ended{
            var a: CGFloat
            var b: CGFloat
            if velocity.x < 0 {
                a = self.trayLeftCenter.x
                b = self.contentLeftCenter.x
            }else{
                a = self.trayRightCenter.x
                b = self.contentRightCenter.x
            }
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.trayView.center.x = a
                self.contentView.center.x = b
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//
        
        trayOriginalCenter = trayView.center
        trayLeftCenter = CGPoint(x: trayView.center.x - 160, y: trayView.center.y)
        trayRightCenter = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y)
        
        trayView.center = trayLeftCenter
        
        contentOriginalCenter = contentView.center
        contentLeftCenter = CGPoint(x: contentOriginalCenter.x + 30, y: contentOriginalCenter.y)
        contentRightCenter = CGPoint(x: contentOriginalCenter.x + 190, y: contentOriginalCenter.y)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var homeNC = storyBoard.instantiateViewControllerWithIdentifier("LoginNaviController") as! UIViewController
        var profileNC = storyBoard.instantiateViewControllerWithIdentifier("profileNC") as! UIViewController
        var mentionNC = storyBoard.instantiateViewControllerWithIdentifier("LoginNaviController") as! UIViewController
        
        var homeVC = homeNC.childViewControllers[0] as! TweetsViewController
        var profileVC = profileNC.childViewControllers[0] as! ProfileViewController
        var mentionVC = mentionNC.childViewControllers[0] as! TweetsViewController
        mentionVC.viewMode = "mentions"
        self.burgerViewControllers = ["home": homeNC, "profile": profileNC, "mention": mentionNC]
        
//        sleep(10)
        self.cycleFromViewController = self.burgerViewControllers!["home"]

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTap(sender: UIButton) {
        self.sideTabOn = false
        if sender == homeButton {
            homeButton.setTitleColor(UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
            mentionButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            profileButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            NSLog("Home button")
            self.cycleFromViewController = self.burgerViewControllers!["home"]
        } else if sender == profileButton {
            profileButton.setTitleColor(UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
            homeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            mentionButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            NSLog("Profile button")
            self.cycleFromViewController = self.burgerViewControllers!["profile"]
        } else if sender == mentionButton {
            mentionButton.setTitleColor(UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
            homeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            profileButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            NSLog("Mentions button")
            self.cycleFromViewController = self.burgerViewControllers!["mention"]
        }
        
        self.trayView.center.x = trayLeftCenter.x
        self.contentView.center.x = self.contentLeftCenter.x
        self.view.layoutIfNeeded()

        
        UIView.animateWithDuration(0.35, animations: {
            //            self.contentView.transform = CGAffineTransformScale(self.contentView.transform, 1.0/0.6, 1.0/0.6)
            //            self.contentViewXAlignmentConstraint.constant = 0
            //            self.sideBarXHorizontalSpaceConstraint.constant = -180
        })
        
        
        
        
    }
    
    var cycleFromViewController: UIViewController? {
        didSet(oldViewControllerOrNil) {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                if let oldVC = oldViewControllerOrNil {
                    oldVC.willMoveToParentViewController(nil)
                    oldVC.view.removeFromSuperview()
                    oldVC.removeFromParentViewController()
                }
                if let newVC =  self.cycleFromViewController {
                    self.addChildViewController(newVC)
                    newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                    newVC.view.frame = self.contentView.bounds
                    self.contentView.addSubview(newVC.view)
//                    self.contentView.center.y = self.contentRightCenter.y
                    newVC.didMoveToParentViewController(self)
                }
            })
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
