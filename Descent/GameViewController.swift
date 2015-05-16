//
//  GameViewController.swift
//  Descent
//
//  Created by Matthew Mohandiss on 3/3/15.
//  Copyright (c) 2015 Matthew Mohandiss. All rights reserved.
//

import UIKit
import SpriteKit
import iAd

var adBannerView = ADBannerView(adType: .Banner)
var playSound = true

class GameViewController: UIViewController, ADBannerViewDelegate {
    
    let scene = MenuScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scene.size = self.view.frame.size
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        scene.scaleMode = .ResizeFill
        loadAds()
        skView.presentScene(scene)
        adBannerView.frame = CGRect()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    //iAd Stuff
    func loadAds() {
        adBannerView = ADBannerView(frame: CGRect.zeroRect)
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height - adBannerView.frame.size.height / 2)
        adBannerView.delegate = self
        adBannerView.hidden = true
        view.addSubview(adBannerView)
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        banner.hidden = false
        println("Ad shown")
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        banner.hidden = true
        //println("Ad failed. error: \(error.localizedDescription)")
    }
    
}
