//
//  DateLocationView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 23/06/21.
//

import SwiftUI
import MapKit
import Combine
struct DateLocationView: View {
    @State var isFindParnerFirst = false
    @State var isFindParnerSecond = false
    @State var isFindParnerRestaurant = false
    @State var txtLocation = "Getting your location..."
    
    @ObservedObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 22.7196 , longitude: 75.8577 ), latitudinalMeters: 100, longitudinalMeters: 100)//MKCoordinateRegion.defaultRegion
    @State private var cancellable: AnyCancellable?
    
    private func setCurrentLocation() {
        cancellable = locationManager.$location.sink { location in
            region = //MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 500, longitudinalMeters: 500)
            
MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 22.7196 , longitude: 75.8577 ), latitudinalMeters: 500, longitudinalMeters: 500)
            
           
        }
    }
    
    var body: some View {
        ZStack{

            
            VStack {
                        //if locationManager.location != nil {
                            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil)
                
                       // } else {
//Text("Locating user location...")
                        //}
                    }
            
            VStack{
                HStack{
                    BackButton()
                    Spacer()

                    Image("smallCross")
                        .padding(.trailing,10)
                        .onTapGesture{

                        }
                } .padding()
                .padding(.top, 10)

                Spacer()
                HStack{
                    if isFindParnerFirst{
                        Image("whiteTicks")

                    }else {
                        Image("pin1")
                            .onTapGesture {
                                self.isFindParnerFirst = true
                                txtLocation = "Use a nice cologne"
                            }
                    }


                    LottieView(name: .constant("lineDots"))
                        .frame(height: 50, alignment: .center)

                    if isFindParnerSecond{
                        Image("pinkTicks")

                    }else {
                        Image("pin2")
                            .onTapGesture {
                                self.isFindParnerSecond = true
                                txtLocation = "Please be patient..."
                            }
                    }


                    LottieView(name: .constant("lineDots"))
                        .frame(height: 50, alignment: .center)

                    if isFindParnerRestaurant{
                        Image("blueTicks")

                    }else {
                        Image("pin3")
                            .onTapGesture {
                                self.isFindParnerRestaurant = true
                                txtLocation = "We found you..."
                            }
                    }

                }.padding(.all)
                Text(txtLocation)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.custom("Antarctican Mono", size: 24.0))
                    .padding(.bottom,16)
                Spacer()

            }
     
        }.ignoresSafeArea()
        .navigationBarHidden(true)
        .preferredColorScheme(.dark)
        .onAppear{
          
            setCurrentLocation()
        }
    }
}

struct DateLocationView_Previews: PreviewProvider {
    static var previews: some View {
        DateLocationView()
    }
}
