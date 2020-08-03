//
//  ShareSheetVIew.swift
//  artbum
//
//  Created by shreyas gupta on 01/08/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI
import UIKit


struct ShareSheetView: UIViewControllerRepresentable{
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = [.assignToContact, .print]
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //TO-DO
    }
}

struct ShareSheetVIew_Previews: PreviewProvider {
    static var previews: some View {
        ShareSheetView(activityItems: ["A String" as NSString])
    }
}
