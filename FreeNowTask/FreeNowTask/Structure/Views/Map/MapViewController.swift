//
//  MapViewController.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import UIKit
import MapKit
import Combine

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private var cancellables: [AnyCancellable] = []
    private let viewModel: VehicleListViewModelType
    private let appear = PassthroughSubject<(p2Lat: Double, p1Lon: Double, p1Lat: Double, p2Lon: Double), Never>()
    private let selection = PassthroughSubject<Void, Never>()
    private let search = PassthroughSubject<(p2Lat: Double, p1Lon: Double, p1Lat: Double, p2Lon: Double), Never>()
    init(viewModel: VehicleListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = false
        
        
        configureUI()
        bind(to: viewModel)
        appear.send((53.394655, 9.757589, 53.694865, 10.099891))
        
       
        
        let coordinate = CLLocationCoordinate2D(latitude: 53.394655, longitude: 10.099891)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: coordinate, span: coordinateSpan)
    
        self.mapView.setRegion(region, animated: true)
        
        
    }
    private func configureUI() {
        definesPresentationContext = true
        title = "Vehicles Map"
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(_:)))
        panGesture.delegate = self
        mapView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.didDragMap(_:)))
        pinchGesture.delegate = self
        mapView.addGestureRecognizer(pinchGesture)
    }
    private func bind(to viewModel: VehicleListViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    
        let input = VehicleListViewModelInput(appear: appear.eraseToAnyPublisher(),
                                               search: search.eraseToAnyPublisher(),
                                               selection: selection.eraseToAnyPublisher())

        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
    private func render(_ state: VehicleListState) {
        switch state {
        case .idle:
            addAnnotations(with: [], animate: true)
        case .loading:
            addAnnotations(with: [], animate: true)
        case .noResults:
            addAnnotations(with: [], animate: true)
        case .failure:
            addAnnotations(with: [], animate: true)
        case .success(let vehicles):
            mapView.removeAnnotations(mapView.annotations)
            addAnnotations(with: vehicles, animate: true)
            
        }
    }
    private func addAnnotations(with vehicles: [VehicleViewModel], animate: Bool = true) {
      for vehicle in vehicles {
        let coordinate = CLLocationCoordinate2D(latitude: vehicle.coordinate.latitude,
                                                longitude: vehicle.coordinate.longitude)
        let annotation = MapViewModel(coordinate: coordinate, id: vehicle.id, state: vehicle.state, type: vehicle.type)
        mapView.addAnnotation(annotation)
        
      }
    }
}



extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let viewModel = annotation as? MapViewModel else {
          return nil
        }
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }
        return annotationView
    }
    
}
extension MapViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @objc func didDragMap(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            let edgePoints = mapView.edgePoints()
            print(edgePoints)
            appear.send((edgePoints.ne.latitude, edgePoints.sw.longitude, edgePoints.sw.latitude, edgePoints.ne.longitude))

        }
    }
}


typealias Edges = (ne: CLLocationCoordinate2D, sw: CLLocationCoordinate2D)
extension MKMapView {
    func edgePoints() -> Edges {
        let nePoint = CGPoint(x: self.bounds.maxX, y: self.bounds.origin.y)
        let swPoint = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
        let neCoord = self.convert(nePoint, toCoordinateFrom: self)
        let swCoord = self.convert(swPoint, toCoordinateFrom: self)
        return (ne: neCoord, sw: swCoord)
    }
}
