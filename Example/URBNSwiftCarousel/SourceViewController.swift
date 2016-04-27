//
//  ViewController.swift
//  URBNSwiftCarousel
//
//  Created by Kevin Taniguchi on 04/25/2016.
//  Copyright (c) 2016 Kevin Taniguchi. All rights reserved.
//

import UIKit
import URBNSwiftCarousel

class SourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let controller = URBNSwCarouselTransitionController()
    let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
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
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}


class SampleCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var sourceCV: URBNScrollSyncCollectionView!
    var data: [String] {
        var mutable = [String]()
        for index in 1...7 {
            mutable.append("\(index)")
        }
        return mutable
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = URBNHorizontalPagedFlowLayout()
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(150, 249)
        sourceCV = URBNScrollSyncCollectionView(frame: CGRectZero, collectionViewLayout: layout)
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
        cell.label.text = data[indexPath.item]
        cell.label.backgroundColor = UIColor.colorForIndex(indexPath.item)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CVCell: UICollectionViewCell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[lbl]|", options: [], metrics: nil, views: ["lbl": label]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[lbl]|", options: [], metrics: nil, views: ["lbl": label]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    static var colors: [UIColor] {
        return [UIColor.redColor(), UIColor.orangeColor(), UIColor.purpleColor(), UIColor.cyanColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.yellowColor()]
    }
    
    static func colorForIndex(index: Int) -> UIColor {
        return colors[index]
    }
}