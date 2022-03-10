//
//  ContentView.swift
//  lekcija3
//
//  Created by karlis.berzins on 09/03/2022.
//

import SwiftUI
import MapKit

struct ContentView: View {
  @State private var isModalPresented = false
  private let locationManager = LocationManager()
  @State private var showsUserLocation = false

  var body: some View {
    VStack {
      Text("Hello, world!")
        .padding()
      Button("Show modal") {
        isModalPresented = true
      }
      Button("Show/hide user location") {
        showsUserLocation.toggle()
      }
      MapView(isUserLocationVisible: $showsUserLocation)
    }
    .sheet(isPresented: $isModalPresented) {
      ModalView(isPresented: $isModalPresented)
    }
  }
}

struct MapView: UIViewRepresentable {
  @Binding var isUserLocationVisible: Bool
  typealias UIViewType = MKMapView

  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    mapView.showsUserLocation = true

    let regionCoordinate = CLLocationCoordinate2D(latitude: 56.955, longitude: 24.255)
    let regionSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: regionCoordinate, span: regionSpan)
    mapView.setRegion(region, animated: true)

    let lidlOne = MKPointAnnotation()
    lidlOne.coordinate = CLLocationCoordinate2D(latitude: 56.944, longitude: 24.222)
    lidlOne.title = "Lidl Deglava"

    let lidlTwo = MKPointAnnotation()
    lidlTwo.coordinate = CLLocationCoordinate2D(latitude: 56.960, longitude: 24.230)
    lidlTwo.title = "Lidl Mežciems"

    mapView.addAnnotations([lidlOne, lidlTwo])

    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: MKPlacemark(coordinate: lidlOne.coordinate))
    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: lidlTwo.coordinate))
    request.transportType = .automobile

    let directions = MKDirections(request: request)
    directions.calculate { response, error in
      guard let route = response?.routes.first else { return }
      mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32), animated: true)
      mapView.addOverlay(route.polyline)
    }

    return mapView
  }

  func // (_ uiView: MKMapView, context: Context) {
    uiView.showsUserLocation = isUserLocationVisible
  }

  func makeCoordinator() -> MapViewCoordinator {
    return MapViewCoordinator()
  }

  class MapViewCoordinator: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      let line = MKPolylineRenderer(overlay: overlay)
      line.strokeColor = .systemRed
      line.lineWidth = 2

      return line
    }
  }
}
