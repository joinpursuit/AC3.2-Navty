//
//  OnboardingViewController.swift
//  Navty
//
//  Created by Edward Anchundia on 3/17/17.
//  Copyright © 2017 Edward Anchundia. All rights reserved.
//

import UIKit
import SnapKit
import paper_onboarding

class OnboardingViewController: UIViewController, PaperOnboardingDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        let onboarding = PaperOnboarding(itemsCount: 3)
        onboarding.dataSource = self
        onboarding.delegate = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let backgroundColorOne = UIColor.blue
        let backgroundColorTwo = UIColor.brown
        let backgroundColorThree = UIColor.darkGray
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        
        return [("location_icon", "Would you take shortest or safest route?", "Where ever you go, Navty help you to keep you safe by connecting with your loved ones", "", backgroundColorOne, UIColor.white, UIColor.white, titleFont, descriptionFont),
                ("Search_icon", "Search Your Destination", "Search your destination by zip-code and choose the safest route to take", "", backgroundColorTwo, UIColor.white, UIColor.white, titleFont, descriptionFont),
                ("board_icon", "Get there safely", "Where ever you go, Navty help you to keep you safe by connecting with your loved ones", "", backgroundColorThree, UIColor.white, UIColor.white, titleFont, descriptionFont)][index]
    }
    
    internal lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Get Started", for: .normal)
        button.alpha = 0
        return button
    }()

}
