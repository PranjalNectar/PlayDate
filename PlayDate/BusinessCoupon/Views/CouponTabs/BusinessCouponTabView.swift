//
//  BusinessCouponTabView.swift
//  PlayDate
//
//  Created by Pranjal on 21/07/21.
//

import SwiftUI

extension MainBusinessCouponView{
    
    public var BusinessCouponTabView: some View {
        
        VStack{
            HStack(spacing : 20){
                ForEach(tabs,id: \.self){ tabData in
                    InboxRequestButton(title: tabData, selectedTab: $selectedTab)
                    if tabData != tabs.last {
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.leading,20)
            .padding(.trailing,20)
            .background(Color.clear)
            
            if selectedTab == "Active" {
                ScrollView(showsIndicators: false){
                    
                    LazyVStack{
                        
                        ForEach(self.arrBusinessCouppon.filter{$0.couponTitle!.contains(self.txtSearch.lowercased()) || txtSearch.isEmpty} ) { item in
                            // ForEach(self.arrBusinessCouppon){ item in
                            BusinessCouponActiveTabView(ComeFrom: "Active", CouponData: item).tag("Active")
                                //.padding(.top, 8)
                                .onAppear{
                                    if self.arrBusinessCouppon.last?.id == item.id{
                                        if self.arrBusinessCouppon.count >= limit{
                                            self.page += 1
                                            self.GetBusinessCouponService()
                                        }
                                    }
                                }
                                
                                .addButtonActions(leadingButtons: [.edit],
                                                  trailingButton:  [.delete], onClick: { button in
                                                    print("clicked: \(button)")
                                                    if button == .edit{
                                                        self.selectedData = item
                                                        self.isGenerateActive = true
                                                    }
                                                    else if button == .delete{
                                                        self.DeleteBusinessCouponService(couponid: item.couponId ?? "")
                                                    }
                                                  })
                        }
                    }
                }
                .padding(.horizontal)
            }else {
                ScrollView(showsIndicators: false){
                   // ForEach(self.arrBusinessCouppon){ item in
                    ForEach(self.arrBusinessCouppon.filter{$0.couponTitle!.contains(self.txtSearch.lowercased()) || txtSearch.isEmpty} ) { item in
                        BusinessCouponActiveTabView(ComeFrom: "Expired", CouponData: item).tag("Expired")
                            //.padding(.top, 8)
                            .onAppear{
                                if self.arrBusinessCouppon.last?.id == item.id{
                                    if self.arrBusinessCouppon.count >= limit{
                                        self.page += 1
                                        self.GetBusinessCouponService()
                                    }
                                }
                            }
                            .addButtonActions(leadingButtons: [],
                                              trailingButton:  [.delete], onClick: { button in
                                                print("clicked: \(button)")
                                                if button == .delete{
                                                    self.DeleteBusinessCouponService(couponid: item.couponId ?? "")
                                                }
                                              })
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
    }
}


let buttonWidth: CGFloat = 60

enum CellButtons: Identifiable {
    case edit
    case delete
    case save
    case info
    
    var id: String {
        return "\(self)"
    }
}

struct CellButtonView: View {
    let data: CellButtons
    let cellHeight: CGFloat
    
    func getView(for image: String, title: String) -> some View {
        VStack {
            Image(image)
            Text(title)
        }
        .padding(8)
        .foregroundColor(.primary)
        .font(.subheadline)
        .frame(width: buttonWidth, height: cellHeight)
       
    }
    
    var body: some View {
        switch data {
        case .edit:
            getView(for: "bsc_edit", title: "")
                .background(Constants.AppColor.appPink)
                .cornerRadius(radius: 8, corners: [.topLeft, .bottomLeft])
                //.cornerRadius(8)
               
        case .delete:
            getView(for: "bsc_delete", title: "")
                .background(Constants.AppColor.appPink)
                .cornerRadius(radius: 8, corners: [.topRight, .bottomRight])
                //.cornerRadius(8)
        case .save:
            getView(for: "square.and.arrow.down", title: "Save")
                .background(Color.blue)
        case .info:
            getView(for: "info.circle", title: "Info")
                .background(Color.green)
        }
    }
}


struct SwipeContainerCell: ViewModifier  {
    enum VisibleButton {
        case none
        case left
        case right
    }
    @State private var offset: CGFloat = 0
    @State private var oldOffset: CGFloat = 0
    @State private var visibleButton: VisibleButton = .none
    let leadingButtons: [CellButtons]
    let trailingButton: [CellButtons]
    let maxLeadingOffset: CGFloat
    let minTrailingOffset: CGFloat
    let onClick: (CellButtons) -> Void
    
    init(leadingButtons: [CellButtons], trailingButton: [CellButtons], onClick: @escaping (CellButtons) -> Void) {
        self.leadingButtons = leadingButtons
        self.trailingButton = trailingButton
        maxLeadingOffset = CGFloat(leadingButtons.count) * buttonWidth
        minTrailingOffset = CGFloat(trailingButton.count) * buttonWidth * -1
        self.onClick = onClick
    }
    
    func reset() {
        visibleButton = .none
        offset = 0
        oldOffset = 0
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .contentShape(Rectangle()) ///otherwise swipe won't work in vacant area
                .offset(x: offset)
                .gesture(DragGesture(minimumDistance: 15, coordinateSpace: .local)
                            .onChanged({ (value) in
                                let totalSlide = value.translation.width + oldOffset
                                if  (0...Int(maxLeadingOffset) ~= Int(totalSlide)) || (Int(minTrailingOffset)...0 ~= Int(totalSlide)) { //left to right slide
                                    withAnimation{
                                        offset = totalSlide
                                    }
                                }
                                ///can update this logic to set single button action with filled single button background if scrolled more then buttons width
                            })
                            .onEnded({ value in
                                withAnimation {
                                    if visibleButton == .left && value.translation.width < -20 { ///user dismisses left buttons
                                        reset()
                                    } else if  visibleButton == .right && value.translation.width > 20 { ///user dismisses right buttons
                                        reset()
                                    } else if offset > 25 || offset < -25 { ///scroller more then 50% show button
                                        if offset > 0 {
                                            visibleButton = .left
                                            offset = maxLeadingOffset
                                        } else {
                                            visibleButton = .right
                                            offset = minTrailingOffset
                                        }
                                        oldOffset = offset
                                        ///Bonus Handling -> set action if user swipe more then x px
                                    } else {
                                        reset()
                                    }
                                }
                            }))
            GeometryReader { proxy in
                HStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(leadingButtons) { buttonsData in
                            Button(action: {
                                withAnimation {
                                    reset()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { ///call once hide animation done
                                    onClick(buttonsData)
                                }
                            }, label: {
                                CellButtonView.init(data: buttonsData, cellHeight: proxy.size.height - 7)
                            })
                        }
                    }.offset(x: (-1 * maxLeadingOffset) + offset)
                    Spacer()
                    HStack(spacing: 0) {
                        ForEach(trailingButton) { buttonsData in
                            Button(action: {
                                withAnimation {
                                    reset()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { ///call once hide animation done
                                    onClick(buttonsData)
                                }
                            }, label: {
                                CellButtonView.init(data: buttonsData, cellHeight: proxy.size.height - 7)
                            })
                        }
                    }.offset(x: (-1 * minTrailingOffset) + offset)
                }
            }
        }
    }
}


extension View {
    func addButtonActions(leadingButtons: [CellButtons], trailingButton: [CellButtons], onClick: @escaping (CellButtons) -> Void) -> some View {
        self.modifier(SwipeContainerCell(leadingButtons: leadingButtons, trailingButton: trailingButton, onClick: onClick))
    }
}
