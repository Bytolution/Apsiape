//
//  HorizontalFlowLayout.m
//  Apsiape
//
//  Created by Dario Lass on 03.09.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "HorizontalFlowLayout.h"

@implementation HorizontalFlowLayout

-(id)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(100, 100);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:[[self.collectionView indexPathsForVisibleItems] firstObject]];
//    
//    CGFloat targetOffset;
//    
//    if (attributes.center.x > proposedContentOffset.x) {
//        targetOffset = attributes.indexPath.row * self.itemSize.width;
//    } else {
//        targetOffset = attributes.indexPath.row * self.itemSize.width;
//    }
//    
//    return CGPointMake(targetOffset, proposedContentOffset.y);
//}




@end
