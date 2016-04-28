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
    private var selectedCellForTransition: CVCell?
    private var selectedCollectionViewForTransition: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "URBNSwifty Carousel"
        
        definesPresentationContext = true
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
        cell.cellSelectedCallback = {[weak self] cvCell in
            guard let weakSelf = self else { return }
            weakSelf.selectedCollectionViewForTransition = cell.sourceCV
            weakSelf.selectedCellForTransition = cvCell
            weakSelf.presentDestinationViewController()
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
        guard let img = selectedCellForTransition?.imageView.image else { return UIImage() }
        return img
    }
    
    func fromImageFrameForGalleryTransitionWithContainerView(containerView: UIView) -> CGRect {
        guard let imgFrame = selectedCellForTransition?.imageView.urbn_imageFrame() else { return CGRectZero }
        return containerView.convertRect(imgFrame, fromView: selectedCellForTransition)
    }
    
    func toImageFrameForGalleryTransitionWithContainerView(containerView: UIView, sourceImageFrame: CGRect) -> CGRect {
        guard let frameToReturnTo = selectedCellForTransition?.imageView.frame, selectedCell = selectedCellForTransition else { return CGRectZero }
        let size = UIImageView.urbn_aspectFitSizeForImageSize(sourceImageFrame.size, rect: frameToReturnTo)
        let toImageWidth = size.width
        let toImageHeight = size.height
        let convertedRect = containerView.convertRect(selectedCell.frame, fromView: selectedCollectionViewForTransition)
        let originX = CGRectGetMidX(convertedRect) - size.width/2
        let originY = CGRectGetMidY(convertedRect) - size.height/2
        return CGRectMake(originX, originY, toImageWidth, toImageHeight)
    }
    
    // MARK: Present the Destination View Controller
    func presentDestinationViewController() {
        let destinationViewController = DestinationViewController()
        destinationViewController.transitioningDelegate = transitionController
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        
        presentViewController(destinationViewController, animated: true) { 
            // sync action here
        }
    }
    
}