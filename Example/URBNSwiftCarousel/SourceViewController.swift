//
//  ViewController.swift
//  URBNSwiftCarousel
//
//  Created by Kevin Taniguchi on 04/25/2016.
//  Copyright (c) 2016 Kevin Taniguchi. All rights reserved.
//

import UIKit
import URBNSwiftCarousel

class SourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, URBNSwCarouselTransitioning {
    
    let transitionController = URBNSwCarouselTransitionController()
    let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    private var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "URBNSwifty Carousel"
        
        tableView.rowHeight = 250
        tableView.estimatedRowHeight = UIScreen.mainScreen().bounds.height/3
        tableView.registerClass(SampleCell.self, forCellReuseIdentifier: "tbvCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        let lbl = UILabel()
        lbl.text = "Touch a cell to see the transition animation"
        lbl.sizeToFit()
        tableView.tableHeaderView = lbl
        tableView.tableHeaderView?.frame = lbl.frame
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tbv]|", options: [], metrics: nil, views: ["tbv": tableView]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tbv]|", options: [], metrics: nil, views: ["tbv": tableView]))
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("tbvCell", forIndexPath: indexPath) as? SampleCell else { return SampleCell() }
        cell.cellSelectedCallback = {[weak self] index in
            guard let weakSelf = self else { return }
            weakSelf.selectedIndex = index
            
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    // MARK: URBNSwCarouselTransitioning
    
    /*
     Required methods for the custom zoom view controller transition
    */
    
    func imageForGalleryTransition() -> UIImage {
        return UIImage()
    }
    
    func fromImageFrameForGalleryTransitionWithContainerView(containerView: UIView) -> CGRect {
        return CGRectZero
    }
    
    func toImageFrameForGalleryTransitionWithContainerView(containerView: UIView, sourceImageFrame: CGRect) -> CGRect {
        return CGRectZero
    }
    
    // MARK: Present the Destination View Controller
    func presentDestinationViewController() {
        let destinationViewController = DestinationViewController()
        
    }
    
}

