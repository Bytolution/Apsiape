//
//  PickerFlowLayout.m
//  Apsiape
//
//  Created by Dario Lass on 28.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "PickerFlowLayout.h"

@implementation PickerFlowLayout

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3

-(id)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(320, 100);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsZero;
        self.minimumLineSpacing = 1;
        self.minimumInteritemSpacing = 0;
    }
    return self;
}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
//{
//    return YES;
//}
//
//-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSArray* array = [super layoutAttributesForElementsInRect:rect];
//    CGRect visibleRect;
//    visibleRect.origin = self.collectionView.contentOffset;
//    visibleRect.size = self.collectionView.bounds.size;
//    
//    for (UICollectionViewLayoutAttributes* attributes in array) {
//        if (CGRectIntersectsRect(attributes.frame, rect)) {
//            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.y;
//            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
//            if (ABS(distance) < ACTIVE_DISTANCE) {
//                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
//                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
//                attributes.zIndex = 1;
//            }
//        }
//    }
//    return array;
//}

//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    CGFloat offsetAdjustment = MAXFLOAT;
//    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
//    
//    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
//    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
//    
//    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
//        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
//        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
//            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
//        }
//    }
//    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
//}

@end
