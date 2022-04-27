

import Foundation
import UIKit
import SwiftUI

struct PageControl: UIViewRepresentable {
    
    var numberOfPages: Int
    
    @Binding var currentPageIndex: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.currentPageIndicatorTintColor = UIColor.systemPink
        control.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.2)
        control.transform = CGAffineTransform(scaleX: 2, y: 2)
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPageIndex
    }
    
}
