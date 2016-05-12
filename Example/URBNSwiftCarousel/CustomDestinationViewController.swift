//
//  CustomDestinationViewController.swift
//  URBNSwiftCarousel
//
//  Created by Kevin Taniguchi on 5/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import URBNSwiftCarousel

class CustomDestinationViewController: BaseDestinationViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, URBNSwCarouselTransitioning {
    
    var selectedCellForTransition: NonZoomingCustomLayoutCollectionViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        destinationCollectionView.registerClass(NonZoomingCustomLayoutCollectionViewCell.self, forCellWithReuseIdentifier: "desCell")
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
        guard let cell = destinationCollectionView.visibleCells().first as? NonZoomingCustomLayoutCollectionViewCell else { return }
        selectedCellForTransition = cell
        selectedPath = destinationCollectionView.indexPathForCell(cell)
        dismissCallback?()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("desCell", forIndexPath: indexPath) as? NonZoomingCustomLayoutCollectionViewCell else { return NonZoomingCustomLayoutCollectionViewCell() }
        
        cell.configure("Item: \(indexPath.item)", customImage: UIImage.testingImages()[indexPath.item])
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: UIScreen.mainScreen().bounds.width, height: 600)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exampleData.count
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
        
        var targetRect = CGRectZero
        
        if let protoTypeCell = destinationCollectionView.dequeueReusableCellWithReuseIdentifier("desCell", forIndexPath: NSIndexPath(forItem: 0, inSection: 0)) as? NonZoomingCustomLayoutCollectionViewCell {
            protoTypeCell.configure("Text", customImage: UIImage.testingImages()[0])
            protoTypeCell.layoutIfNeeded()
            targetRect = containerView.convertRect(protoTypeCell.imageView.frame, fromView: protoTypeCell)
        }
        
        let size = UIImageView.urbn_aspectFitSizeForImageSize(sourceImageFrame.size, rect: targetRect)
        let originX = CGRectGetMidX(targetRect) - size.width/2
        let originY = CGRectGetMidY(targetRect) - size.height/2
        let frame = CGRectMake(originX, originY, targetRect.width, targetRect.height)
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
}
