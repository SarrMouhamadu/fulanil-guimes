import Foundation
import CoreLocation
import MapKit
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var userLocation: CLLocation? = nil
    @Published var userAddress: String = ""
    @Published var isLocating: Bool = false
    @Published var locationError: String? = nil
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = manager.authorizationStatus
    }
    
    func requestLocation() {
        isLocating = true
        locationError = nil
        
        let status = manager.authorizationStatus
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        } else {
            isLocating = false
            locationError = "Accès à la géolocalisation désactivé."
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        } else if authorizationStatus == .denied || authorizationStatus == .restricted {
            isLocating = false
            locationError = "Accès à la géolocalisation refusé."
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            isLocating = false
            return
        }
        
        userLocation = location
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // Reverse Geocoding via MapKit (MKLocalSearch) pour 0 avertissement de dépréciation
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "\(latitude), \(longitude)"
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLocating = false
                
                if let item = response?.mapItems.first {
                    var addressComponents: [String] = []
                    
                    if let name = item.name, !name.isEmpty, !name.contains(",") {
                        addressComponents.append(name)
                    }
                    if let subLocality = item.placemark.subLocality, !subLocality.isEmpty, !addressComponents.contains(subLocality) {
                        addressComponents.append(subLocality)
                    }
                    if let locality = item.placemark.locality, !locality.isEmpty, !addressComponents.contains(locality) {
                        addressComponents.append(locality)
                    }
                    
                    if addressComponents.isEmpty {
                        self.userAddress = String(format: "GPS: %.4f, %.4f", latitude, longitude)
                    } else {
                        self.userAddress = addressComponents.joined(separator: ", ")
                    }
                } else {
                    self.userAddress = String(format: "GPS: %.4f, %.4f", latitude, longitude)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isLocating = false
            self.locationError = "Impossible de déterminer la position GPS."
        }
    }
}
