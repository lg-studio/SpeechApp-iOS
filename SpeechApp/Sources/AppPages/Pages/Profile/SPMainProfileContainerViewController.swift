//
//  SPMainProfileContainerViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 24/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import UIScrollSlidingPages
import AsyncImageView

class SPMainProfileContainerViewController: SPContainerCenterUIViewController, TTSlidingPagesDataSource, TTSliddingPageDelegate {
    // profile view
    @IBOutlet weak var imageViewProfileBackground: UIView!;
    @IBOutlet weak var imageViewProfile: AsyncImageView!;
    @IBOutlet weak var labelName: UILabel!;
    @IBOutlet weak var labelEmail: UILabel!;
    @IBOutlet weak var labelLastSeen: UILabel!;
    
    
    // page VC
    @IBOutlet weak var viewTop: UIView!;
    @IBOutlet weak var viewButtons: UIView!;
    @IBOutlet weak var viewBottomSlider: UIView!;
    @IBOutlet weak var button1: UIButton!;
    @IBOutlet weak var button2: UIButton!;
    @IBOutlet weak var button3: UIButton!;
    @IBOutlet weak var button4: UIButton!;
    @IBOutlet weak var button5: UIButton!;
    var buttonsArray : [UIButton] = [];
    var currentPageIndex : Int = -1;
    
    @IBOutlet weak var viewProfile: UIView!;
    
    var slidingViewController : TTScrollSlidingPagesController;
    var slidingViewControllers : [UIViewController];
    var sliderInited : Bool = false;
    
    // profile information
    var profileBio : ProfileBioModel;    
    weak var failedRequestView : FailedRequestView?;
    var userDetailsModel : UserDetailsModel;
    
    init() {
        self.slidingViewController = TTScrollSlidingPagesController();
        self.slidingViewControllers = [];
        self.profileBio = ProfileBioModel();
        self.userDetailsModel = UserDetailsModel.loadUserDetailsModel();
        super.init(nibName: "SPMainProfileContainerViewController", bundle: nil);
    }
    
    required init(coder aDecoder: NSCoder) {
        self.slidingViewController = TTScrollSlidingPagesController();
        self.slidingViewControllers = [];
        self.profileBio = ProfileBioModel();
        self.userDetailsModel = UserDetailsModel.loadUserDetailsModel();
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.labelName.text = "";
        self.labelEmail.text = "";
        self.labelLastSeen.text = "";
        self.initNavBar("My Profile");
        self.viewProfile.setRoundCorners();
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("didTapProfileImageView:"));
        self.imageViewProfileBackground.addGestureRecognizer(tap);
    }
    override func viewDidAppear(animated: Bool) {
        self.getProfilePageInfo();
    }
    
    func initPageViewControllers() {
        var profileActivitiesVC = SPProfileActivityViewController();
        profileActivitiesVC.containerDelegate = self;
        var profileBioVC = SPProfileBioViewController(bioModel: self.profileBio, userDetailsModel : self.userDetailsModel);
        profileBioVC.containerDelegate = self;
        self.slidingViewControllers = [
            profileActivitiesVC,
            SPProfileTasksViewController(),
            SPProfileCompetencesViewController(),
            SPProfileFeedbackViewController(),
            profileBioVC
        ];
    }
    func initPage() {
        self.buttonsArray = [button1, button2, button3, button4, button5];
        if self.currentPageIndex == -1 {
            self.currentPageIndex = 0;
        }
        
        for index in 0..<self.buttonsArray.count {
            var button = buttonsArray[index];
            button.enabled = true;
            button.alpha = 1.0;
            button.setRoundCorners();
            button.setDefaultMarginColor();
            button.setTitle(self.getPageTitleAtIndex(Int(index)), forState: .Normal);
            button.tag = index;
            button.addTarget(self, action: "didTapButton:", forControlEvents: UIControlEvents.TouchUpInside);
        }
    }
    func didTapButton(sender:UIButton!) {
        self.currentPageIndex = sender.tag;
        self.updatePage();
        self.scrollToCurrentPage();
    }
    func updatePage() {
        for index in 0..<self.buttonsArray.count {
            var button = buttonsArray[index];
            if(button.tag == self.currentPageIndex) {
                button.setBackgroundColor(UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1.0), forState: .Normal);
            }
            else {
                button.setBackgroundColor(UIColor.clearColor(), forState: .Normal);
            }
        }
    }
    
    func initSliderContainer() {
        // only initialize the slider once
        if self.sliderInited == true {
            return;
        }
        self.slidingViewController.titleScrollerHidden = true;
        self.slidingViewController.disableUIPageControl = true;
        self.slidingViewController.zoomOutAnimationDisabled = true;
        
        self.slidingViewController.dataSource = self;
        self.slidingViewController.delegate = self;
        self.slidingViewController.view.frame = self.viewBottomSlider.bounds;
        self.viewBottomSlider.addSubview(self.slidingViewController.view);
        self.addChildViewController(self.slidingViewController);
        
        self.sliderInited = true;
    }

    func scrollToCurrentPage() {
        self.slidingViewController.scrollToPage(Int32(self.currentPageIndex), animated: false);
    }
    
    // MARK : TTSlidingPagesDataSource delegates
    func numberOfPagesForSlidingPagesViewController(source: TTScrollSlidingPagesController!) -> Int32 {
        return Int32(self.slidingViewControllers.count);
    }
    func pageForSlidingPagesViewController(source: TTScrollSlidingPagesController!, atIndex index: Int32) -> TTSlidingPage! {
        return TTSlidingPage(contentViewController: self.slidingViewControllers[Int(index)]);
    }
    func titleForSlidingPagesViewController(source: TTScrollSlidingPagesController!, atIndex index: Int32) -> TTSlidingPageTitle! {
        return TTSlidingPageTitle(headerText: self.getPageTitleAtIndex(Int(index)));
    }
    // MARK : TTSliddingPageDelegate delegate
    func didScrollToViewAtIndex(index: UInt) {
        self.currentPageIndex = Int(index);
        self.updatePage();
    }
    private func getPageTitleAtIndex(index : Int) -> String {
        let viewController = self.slidingViewControllers[Int(index)];
        if let activityVC = viewController as? SPProfileActivityViewController {
            return activityVC.getPageTitle();
        }
        else if let baseProfileVC = viewController as? SPBaseProfileViewController {
            return baseProfileVC.getPageTitle();
        }
        return "";
    }
}
