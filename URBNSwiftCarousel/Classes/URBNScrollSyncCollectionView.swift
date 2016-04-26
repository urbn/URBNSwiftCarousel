//
//  URBNScrollSyncCollectionView.swift
//  Pods
//
//  Created by Kevin Taniguchi on 4/26/16.
//
//

import UIKit

class URBNScrollSyncCollectionView: UICollectionView, UICollectionViewDelegate {

    var animateScrollSync = false
    var didSyncBlock: ((collectionView: UICollectionView, indexpath: NSIndexPath) -> Void)?
    private(set) var syncedCollectionView: URBNScrollSyncCollectionView?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        delegate = self
    }
    
    func didSyncBlock( didSyncBlock: (collectionView: UICollectionView, indexpath: NSIndexPath) -> Void) {
        
    }
    
    func registerForSynchronizationWithCollectionView(collectionView: URBNScrollSyncCollectionView) {
        syncedCollectionView = collectionView
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        print("CV: \(collectionView) ITEM: \(indexPath.item)")
        
        guard let syncCV = syncedCollectionView else { return }
        print("SYNCED CV: \(syncCV) CURRENT ITEM \(syncCV.indexPathForItemAtPoint(syncCV.contentOffset)?.item)")
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let path = indexPathForItemAtPoint(contentOffset) else { return }
        
        print("CV: \(collectionView) ITEM: \(path.item)")
        
        guard let syncCV = syncedCollectionView else { return }
        print("SYNCED CV: \(syncCV) CURRENT ITEM \(syncCV.indexPathForItemAtPoint(syncCV.contentOffset)?.item)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
