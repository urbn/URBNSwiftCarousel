//
//  URBNScrollSyncCollectionView.swift
//  Pods
//
//  Created by Kevin Taniguchi on 4/26/16.
//
//

import UIKit

public class URBNScrollSyncCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    
    public var animateScrollSync = false
    public var didSyncBlock: ((collectionView: UICollectionView, indexpath: NSIndexPath) -> Void)?
    
    private(set) var syncedCollectionView: URBNScrollSyncCollectionView?

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    public func didSyncBlock( didSyncBlock: (collectionView: UICollectionView, indexpath: NSIndexPath) -> Void) {
        
    }
    
    public func registerForSynchronizationWithCollectionView(collectionView: URBNScrollSyncCollectionView) {
        syncedCollectionView = collectionView
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}