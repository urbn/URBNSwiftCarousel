//
//  ViewController.swift
//  URBNSwiftCarousel
//
//  Created by Kevin Taniguchi on 04/25/2016.
//  Copyright (c) 2016 Kevin Taniguchi. All rights reserved.
//


import UIKit
import URBNSwiftCarousel

class SourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, URBNSwCarouselTransitioning, URBNSynchronizingDelegate {
    
    /*
        The transitionController is declared in the view controller that is the source of the transition.
    */
    let transitionController = URBNSwCarouselTransitionController()
    
    /*
        Collection views nested inside the cells of a tableView are a fairly common jawn, so we demonstrate one here.
    */
    let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    
    private var selectedCellForTransition: URBNCarouselZoomableCell?
    private var selectedCollectionViewForTransition: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "URBNSwifty Carousel"
        
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        definesPresentationContext = true
        tableView.rowHeight = 250
        tableView.estimatedRowHeight = UIScreen.mainScreen().bounds.height/3
        tableView.registerClass(SampleCell.self, forCellReuseIdentifier: "tbvCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        let lbl = UILabel()
        lbl.textAlignment = .Center
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
        cell.cellSelectedCallback = {[weak self] selectedCell in
            guard let weakSelf = self else { return }
            weakSelf.selectedCollectionViewForTransition = cell.sourceCV
            weakSelf.selectedCellForTransition = selectedCell
            weakSelf.presentDestinationViewController()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    // MARK: Present the Destination View Controller
    func presentDestinationViewController() {
        
        /*
         This is the view controller we are going to transition to.
        */
        let destinationViewController = DestinationViewController()
        
        /*
         Set this property if your view controller is a child of a navigation controller.  
         */
        transitionController.presentationController?.maskingNavBarColor = navigationController?.navigationBar.barTintColor
        
        /*
         The destinationViewController must be set as the transitioning delegate of the transitionController to trigger the transition controller's methods
        */
        destinationViewController.transitioningDelegate = transitionController
        /*
         In order to use URBNSwiftCarousel, the modalPresentationStyle must be set to .Custom
         */
        destinationViewController.modalPresentationStyle = .Custom
        
        presentViewController(destinationViewController, animated: true , completion: nil)
        
        destinationViewController.dismissCallback = { [weak self] in
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: URBNSwCarouselTransitioning
    /*
     Required methods for the custom zoom view controller transition
    */
    func imageForGalleryTransition() -> UIImage {
        guard let img = selectedCellForTransition?.imageView.image else { return UIImage() }
        return img
    }
    
    /*
     When your SourceViewController calls presentViewController(destinationViewController), the SOURCE view controller calls this method.
     
     When dismissViewController is called by either the source or destination, the DESTINATION view controller calls this method.
     
     Calculate and return the frame you want the animating imageView to return to.
     */
    func fromImageFrameForGalleryTransitionWithContainerView(containerView: UIView) -> CGRect {
        guard let imgFrame = selectedCellForTransition?.imageView.urbn_imageFrame() else { return CGRectZero }
        return containerView.convertRect(imgFrame, fromView: selectedCellForTransition)
    }
    
    /*
     When your SourceViewController calls presentViewController(destinationViewController), the DESTINATION view controller calls this method.
     
     When dismissViewController is called by either the source or destination, the SOURCE view controller calls this method.
     
     Calculate and return the frame you want the animating imageView to zoom out to.
     */
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
    
    // MARK URBNSynchronizingDelegate Delegate Methods
    
    /*
     Here we tell the UIPresentationController that is managing the animation transitions what index path was the origin of the transition.  This path is passed to the destination collection view so it can scroll to the corresponding cell.
    */
    func sourceIndexPath() -> NSIndexPath? {
        guard let cv = selectedCollectionViewForTransition, cell = selectedCellForTransition else { return nil }
        return cv.indexPathForCell(cell)
    }
    
    func toCollectionView() -> UICollectionView? {
        return selectedCollectionViewForTransition
    }
    
    func updateSourceSelectedCell(cell: URBNCarouselZoomableCell) {
        selectedCellForTransition = cell
    }
}