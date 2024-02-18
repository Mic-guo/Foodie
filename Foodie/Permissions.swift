//
//  Permissions.swift
//  Foodie
//
//  Created by Michael Xcode on 2/17/24.
//

import Foundation
import AVFoundation
import CoreLocation

class PermissionManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var isLocationPermissionGranted: Bool = false
    @Published var isCameraPermissionGranted: Bool = false

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.isCameraPermissionGranted = granted
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                self.isLocationPermissionGranted = true
            default:
                self.isLocationPermissionGranted = false
        }
    }
    
    func statusString(for status: CLAuthorizationStatus) -> String {
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                return "Authorized"
            case .denied:
                return "Denied"
            case .restricted:
                return "Restricted"
            case .notDetermined:
                return "Not Determined"
            @unknown default:
                return "Unknown"
        }
    }

    func statusString(for status: AVAuthorizationStatus) -> String {
        switch status {
            case .authorized:
                return "Authorized"
            case .denied:
                return "Denied"
            case .restricted:
                return "Restricted"
            case .notDetermined:
                return "Not Determined"
            @unknown default:
                return "Unknown"
        }
    }
}
