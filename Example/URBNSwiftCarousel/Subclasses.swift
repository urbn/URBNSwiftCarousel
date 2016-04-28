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
    var cellSelectedCallback: (CVCell -> Void)?
    
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
        sourceCV.registerClass(CVCell.self, forCellWithReuseIdentifier: "cvCell")
        contentView.addSubview(sourceCV)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cv]|", options: [], metrics: nil, views: ["cv": sourceCV]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[cv]|", options: [], metrics: nil, views: ["cv": sourceCV]))
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cvCell", forIndexPath: indexPath) as? CVCell else { return CVCell() }
        cell.imageView.image = UIImage.testingImages()[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CVCell else { return }
        cellSelectedCallback?(cell)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CVCell: URBNCarouselZoomableCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
