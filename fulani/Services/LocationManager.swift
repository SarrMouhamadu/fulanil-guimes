import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
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
        reverseGeocode(location: location)
    }
    
    private func reverseGeocode(location: CLLocation) {
        Task {
            do {
                let placemarks = try await geocoder.reverseGeocodeLocation(location)
                if let placemark = placemarks.first {
                    var addressComponents: [String] = []
                    
                    if let name = placemark.name, !name.isEmpty {
                        addressComponents.append(name)
                    }
                    if let subLocality = placemark.subLocality, !subLocality.isEmpty, !addressComponents.contains(subLocality) {
                        addressComponents.append(subLocality)
                    }
                    if let locality = placemark.locality, !locality.isEmpty, !addressComponents.contains(locality) {
                        addressComponents.append(locality)
                    }
                    
                    let formattedAddress = addressComponents.isEmpty ?
                        String(format: "GPS: %.4f, %.4f", location.coordinate.latitude, location.coordinate.longitude) :
                        addressComponents.joined(separator: ", ")
                    
                    await MainActor.run {
                        self.userAddress = formattedAddress
                        self.isLocating = false
                    }
                } else {
                    await MainActor.run {
                        self.userAddress = String(format: "GPS: %.4f, %.4f", location.coordinate.latitude, location.coordinate.longitude)
                        self.isLocating = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.userAddress = String(format: "GPS: %.4f, %.4f", location.coordinate.latitude, location.coordinate.longitude)
                    self.isLocating = false
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
