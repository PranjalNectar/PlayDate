//
//  Common.swift
//  PlayDate
//
//  Created by Pranjal on 23/04/21.
//

import Foundation
import SwiftUI


class common{
    var AppName = "PlayDate"
    
    // MARK: - Convert  String To date
    
    class func getDateFromString(strDate:String) -> Date{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatterGet.timeZone = TimeZone.current
        var date = Date()
        date = dateFormatterGet.date(from: strDate)!
        return date
    }
    
    class func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    class func getDateInFormate(date : Date) -> String {
        //let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    class func getCurrentTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        let result = formatter.string(from: date)
        return result
    }
    
    class func ChangeDateFormat(Date: String, fromFormat: String, toFormat: String ) -> String  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        let newdate = dateFormatter.date(from: Date)
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: newdate!)
    }
}
struct SUImagePickerView: UIViewControllerRepresentable {

    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var image: UIImage?
    @Binding var isPresented: Bool

    func makeCoordinator() -> ImagePickerViewCoordinator {
        return ImagePickerViewCoordinator(image: $image, isPresented: $isPresented)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = context.coordinator
        return pickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update here
    }

}

class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @Binding var image: UIImage?
    @Binding var isPresented: Bool

    init(image: Binding<UIImage?>, isPresented: Binding<Bool>) {
        self._image = image
        self._isPresented = isPresented
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image =  image
        }
        self.isPresented = false
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }

}


struct LegacyScrollView : UIViewRepresentable {
    // any data state, if needed

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIScrollView {
        let control = UIScrollView()
        control.refreshControl = UIRefreshControl()
        control.refreshControl?.addTarget(context.coordinator, action:
            #selector(Coordinator.handleRefreshControl),
                                          for: .valueChanged)

        // Simply to give some content to see in the app
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        label.text = "Scroll View Content"
        control.addSubview(label)

        return control
    }


    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // code to update scroll view from view state, if needed
    }

    class Coordinator: NSObject {
        var control: LegacyScrollView

        init(_ control: LegacyScrollView) {
            self.control = control
        }

        @objc func handleRefreshControl(sender: UIRefreshControl) {
            // handle the refresh event

            sender.endRefreshing()
        }
    }
}


protocol CustomViewModel {
    func loadPackages()
}


// It is used generic ViewBuilder pattern for content
struct CustomScrollView<Content: View, VM: CustomViewModel> : UIViewRepresentable {
   
    var width : CGFloat
    var height : CGFloat

    let viewModel: VM
    let content: () -> Content

    init(width: CGFloat, height: CGFloat, viewModel: VM, @ViewBuilder content: @escaping () -> Content) {
        self.width = width
        self.height = height
        self.viewModel = viewModel
        self.content = content
    }

    func makeUIView(context: Context) -> UIScrollView {
        let control = UIScrollView()
        control.refreshControl = UIRefreshControl()
        control.refreshControl?.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl), for: .valueChanged)

        let childView = UIHostingController(rootView: content())

        childView.view.frame = CGRect(x: 0, y: 0, width: width, height: height)

        control.addSubview(childView.view)
        return control
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel: viewModel)
    }

    class Coordinator: NSObject {
        var control: CustomScrollView<Content, VM>
        var viewModel: VM

        init(_ control: CustomScrollView, viewModel: VM) {
            self.control = control
            self.viewModel = viewModel
        }

        @objc func handleRefreshControl(sender: UIRefreshControl) {
            sender.endRefreshing()
            viewModel.loadPackages()
        }
    }
}
