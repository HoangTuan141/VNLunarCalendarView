//
//  ExtensionCollectionView.swift
//  VNLunarCalendarView
//
//  Created by Hoàng Tuấn on 02/03/2021.
//

import Foundation
import UIKit

extension UICollectionView {
    func isValid(indexPath: IndexPath) -> Bool {
        guard indexPath.section < numberOfSections,
              indexPath.row < numberOfItems(inSection: indexPath.section)
            else { return false }
        return true
    }
}
