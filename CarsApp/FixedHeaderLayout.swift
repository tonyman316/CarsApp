//
//  FixedHeaderLayout.swift
//  CarsApp
//
//  Created by Andrea Borghi on 12/4/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import Foundation
import UIKit

class FixedHeaderLayout: UICollectionViewFlowLayout {
//    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
//        return true
//    }
//    
//    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
//        var result = super.layoutAttributesForElementsInRect(rect)
//        
//        var attrKinds = result.
//    }
//}
}

//@interface FixedHeaderLayout : UICollectionViewFlowLayout
//@end
//
//@implementation FixedHeaderLayout
////Override shouldInvalidateLayoutForBoundsChange to require a layout update when we scroll
//- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    return YES;
//    }
//    
//    //Override layoutAttributesForElementsInRect to provide layout attributes with a fixed origin for the header
//    - (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
//        
//        NSMutableArray *result = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
//        
//        //see if there's already a header attributes object in the results; if so, remove it
//        NSArray *attrKinds = [result valueForKeyPath:@"representedElementKind"];
//        NSUInteger headerIndex = [attrKinds indexOfObject:UICollectionElementKindSectionHeader];
//        if (headerIndex != NSNotFound) {
//            [result removeObjectAtIndex:headerIndex];
//        }
//        
//        CGPoint const contentOffset = self.collectionView.contentOffset;
//        CGSize headerSize = self.headerReferenceSize;
//        
//        //create new layout attributes for header
//        UICollectionViewLayoutAttributes *newHeaderAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
//        CGRect frame = CGRectMake(0, contentOffset.y, headerSize.width, headerSize.height);  //offset y by the amount scrolled
//        newHeaderAttributes.frame = frame;
//        newHeaderAttributes.zIndex = 1024;
//        
//        [result addObject:newHeaderAttributes];
//        
//        return result;
//    }
//@end