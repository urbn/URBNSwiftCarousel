//
//  Subclasses.swift
//  URBNSwiftCarousel
//
//  Created by Kevin Taniguchi on 4/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//


import UIKit
import URBNSwiftCarousel

class SampleCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var sourceCV: UICollectionView!
    let data = UIImage.testingImages()
    var cellSelectedCallback: (URBNCarouselZoomableCell -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = URBNHorizontalPagedFlowLayout()
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(150, 249)
        sourceCV = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        sourceCV.translatesAutoresizingMaskIntoConstraints = false
        sourceCV.delegate = self
        sourceCV.dataSource = self
        sourceCV.registerClass(URBNCarouselZoomableCell.self, forCellWithReuseIdentifier: "URBNCarouselZoomableCell")
        contentView.addSubview(sourceCV)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cv]|", options: [], metrics: nil, views: ["cv": sourceCV]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[cv]|", options: [], metrics: nil, views: ["cv": sourceCV]))
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("URBNCarouselZoomableCell", forIndexPath: indexPath) as? URBNCarouselZoomableCell else { return URBNCarouselZoomableCell() }
        cell.imageView.image = UIImage.testingImages()[indexPath.item]
        cell.index = indexPath.item
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? URBNCarouselZoomableCell else { return }
        cellSelectedCallback?(cell)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
