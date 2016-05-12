//
//  DestinationViewController.swift
//  URBNSwiftCarousel
//
//  Created by Kevin Taniguchi on 4/25/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import URBNSwiftCarousel

/*
 This is an example class for a larger, "zoomed out" version of the image tapped in the source view controller.
*/

class DestinationViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, URBNSwCarouselTransitioning, URBNSynchronizingDelegate {
    
    let destinationCollectionView: UICollectionView
    var selectedCellForTransition: URBNCarouselZoomableCell?
    var exampleData = UIImage.testingImages()
    var selectedPath: NSIndexPath?
    var dismissCallback: (Void -> Void)?
    
    init() {
        let layout = URBNHorizontalPagedFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        
        destinationCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        destinationCollectionView.registerClass(URBNCarouselZoomableCell.self, forCellWithReuseIdentifier: "desCell")
        destinationCollectionView.frame = view.bounds
        destinationCollectionView.delegate = self
        destinationCollectionView.dataSource = self
        destinationCollectionView.frame = view.bounds
        view.addSubview(destinationCollectionView)
        destinationCollectionView.reloadData()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
    }
    
    func viewTapped() {
        guard let cell = destinationCollectionView.visibleCells().first as? URBNCarouselZoomableCell else { return }
        selectedCellForTransition = cell
        selectedPath = destinationCollectionView.indexPathForCell(cell)
        dismissCallback?()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exampleData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("desCell", forIndexPath: indexPath) as? URBNCarouselZoomableCell else { return URBNCarouselZoomableCell() }
        cell.imageView.image = UIImage.testingImages()[indexPath.item]
        cell.scrollView.userInteractionEnabled = true
        return cell
    }
    
    // MARK URBNSwCarouselTransitioning Delegate
    
    /*
     Required methods for transitioning
    */
    func imageForGalleryTransition() -> UIImage? {
        guard let img = selectedCellForTransition?.imageView.image else { return nil }
        return img
    }
    
    /*
     This is called when the destination view controller is being presented.  Here we are specifying the frame of the image we want to zoom out to.
     */
    func toImageFrameForGalleryTransitionWithContainerView(containerView: UIView, sourceImageFrame: CGRect) -> CGRect {
        let size = UIImageView.urbn_aspectFitSizeForImageSize(sourceImageFrame.size, rect: view.bounds)
        let originX = CGRectGetMidX(view.bounds) - size.width/2
        let originY = CGRectGetMidY(view.bounds) - size.height/2
        let frame = CGRectMake(originX, originY, size.width, size.height)
        return frame
    }
    
    /*
     This is called when the destination view controller is being dismissed.  here we are specifying the frame of the image we are zooming from.
    */
    func fromImageFrameForGalleryTransitionWithContainerView(containerView: UIView) -> CGRect {
        guard let cell = selectedCellForTransition, img = selectedCellForTransition?.imageView, imgSize = img.image?.size else { return CGRectZero }
        let size = UIImageView.urbn_aspectFitSizeForImageSize(imgSize , rect: img.frame)
        var frame = cell.frame
        frame.origin.x = 0
        frame.origin.y = 0
        let originX = CGRectGetMidX(frame) - size.width/2
        let originY = CGRectGetMidY(frame) - size.height/2
        let xframe = CGRectMake(originX, originY, size.width, size.height)
        return xframe
    }
    
    // MARK Sync Delegate
    func sourceIndexPath() -> NSIndexPath? {
        guard let path = selectedPath else { return NSIndexPath(forItem: 0, inSection: 0) }
        return path
    }
    
    func toCollectionView() -> UICollectionView? {
        return destinationCollectionView
    }
}
