//
//  DestinationViewController.swift
//  URBNSwiftCarousel
//
//  Created by Kevin Taniguchi on 4/25/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import URBNSwiftCarousel

class DestinationViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, URBNSwCarouselTransitioning {
    var destinationCollectionView: URBNScrollSyncCollectionView!
    var swTransitionController: URBNSwCarouselTransitionController?
    
    var selectedCellForTransition: CVCell?
    
    var data = UIImage.testingImages()
    
    convenience init(transitionController: URBNSwCarouselTransitionController) {
        self.init()
        
        swTransitionController = transitionController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = URBNHorizontalPagedFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 100)
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
 
        destinationCollectionView = URBNScrollSyncCollectionView(frame: view.bounds, collectionViewLayout: layout)
        destinationCollectionView.registerClass(CVCell.self, forCellWithReuseIdentifier: "desCell")
        destinationCollectionView.frame = view.bounds
        destinationCollectionView.delegate = self
        destinationCollectionView.dataSource = self
        view.addSubview(destinationCollectionView)
        
        destinationCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("desCell", forIndexPath: indexPath) as? CVCell else { return CVCell() }
        cell.imageView.image = UIImage.testingImages()[indexPath.item]
        cell.scrollView.userInteractionEnabled = true
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CVCell else { return }
        selectedCellForTransition = cell
    }
    
    // MARK URBNSwCarouselTransitioning Delegate
    func imageForGalleryTransition() -> UIImage {
        guard let img = selectedCellForTransition?.imageView.image else { return UIImage() }
        return img
    }
    
    func toImageFrameForGalleryTransitionWithContainerView(containerView: UIView, sourceImageFrame: CGRect) -> CGRect {
        return CGRectZero
        
        
        
        //    self.destinationCollectionView.hidden = YES;
        //    CGSize size = [UIImageView urbn_aspectFitSizeForImageSize:sourceImageFrame.size inRect:self.view.bounds];
        //    CGFloat originX = CGRectGetMidX(self.view.bounds) - (size.width / 2);
        //    CGFloat originY = CGRectGetMidY(self.view.bounds) - (size.height / 2);
        //    CGRect frame = CGRectMake(originX, originY, size.width, size.height);
        //    return frame;
        
        //    CGSize size = [UIImageView urbn_aspectFitSizeForImageSize:self.selectedCell.imageView.image.size inRect:self.selectedCell.imageView.frame];
        //
        //    CGFloat originX = CGRectGetMidX(self.selectedCell.frame) - (size.width / 2);
        //    CGFloat originY = CGRectGetMidY(self.selectedCell.frame) - (size.height / 2);
        //    CGRect frame = CGRectMake(originX, originY, size.width, size.height);
        //    frame = [containerView convertRect:frame fromView:self.destinationCollectionView];
        //    return frame;
    }
    
    func fromImageFrameForGalleryTransitionWithContainerView(containerView: UIView) -> CGRect {
        return CGRectZero
        
        //    NSAssert(self.selectedCell, @"Cell should be selected for \"from\" transition");
        //    CGSize size = [UIImageView urbn_aspectFitSizeForImageSize:self.selectedCell.imageView.image.size inRect:self.selectedCell.imageView.frame];
        //
        //    CGFloat originX = CGRectGetMidX(self.selectedCell.frame) - (size.width / 2);
        //    CGFloat originY = CGRectGetMidY(self.selectedCell.frame) - (size.height / 2);
        //    CGRect frame = CGRectMake(originX, originY, size.width, size.height);
        //    frame = [containerView convertRect:frame fromView:self.destinationCollectionView];
        //    return frame;
    }
}
