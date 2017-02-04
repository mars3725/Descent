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

var adBannerView = ADBannerView(adType: .banner)
var playSound = true

class GameViewController: UIViewController, ADBannerViewDelegate {
    
    let scene = MenuScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scene.size = self.view.frame.size
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.ignoresSiblingOrder = true
        skView.showsNodeCount = true
        //skView.showsPhysics = true
        scene.scaleMode = .resizeFill
        loadAds()
        skView.presentScene(scene)
        adBannerView?.frame = CGRect()
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.portrait
        } else {
            return UIInterfaceOrientationMask.all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    //iAd Stuff
    func loadAds() {
        adBannerView = ADBannerView(frame: CGRect.zero)
        adBannerView?.center = CGPoint(x: (adBannerView?.center.x)!, y: view.bounds.size.height - (adBannerView?.frame.size.height)! / 2)
        adBannerView?.delegate = self
        adBannerView?.isHidden = true
        view.addSubview(adBannerView!)
    }
    
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        if banner.isHidden {
        banner.isHidden = false
        print("Ad shown")
        }
    }
    
    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        banner.isHidden = true
        print("Ad failed. error: \(error.localizedDescription)")
    }
    
}
