//
//  DestinationViewController.swift
//  URBNSwiftCarousel
//
//  Created by Kevin Taniguchi on 4/25/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import URBNSwiftCarousel

class DestinationViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var destinationVC: URBNScrollSyncCollectionView!
    
    var data: [String] {
        var mutable = [String]()
        for index in 1...20 {
            mutable.append("\(index)")
        }
        return mutable
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = URBNHorizontalPagedFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 100)
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
 
        destinationVC.registerClass(CVCell.self, forCellWithReuseIdentifier: "desCell")
        destinationVC = URBNScrollSyncCollectionView(frame: CGRectZero, collectionViewLayout: layout)
        destinationVC.frame = view.bounds
        view.addSubview(destinationVC)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("desCell", forIndexPath: indexPath) as? CVCell else { return CVCell() }
        cell.label.text = data[indexPath.item]
        return cell
    }
}
