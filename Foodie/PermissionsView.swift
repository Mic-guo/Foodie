//
//  PermissionsView.swift
//  Foodie
//
//  Created by Michael Xcode on 2/17/24.
//

import SwiftUI
import UIKit
import AVFoundation
import CoreLocation

struct PermissionsView: View {
    @StateObject private var permissionManager = PermissionManager()
    @State private var showMainView = false

    var body: some View {
        Group {
            if showMainView {
                // MainContentView() // Your main app content view goes here
                CameraView()
            } else {
                VStack {
                    Text("We need some permissions to proceed")
                    Button("Request Permissions") {
                        permissionManager.requestLocationPermission()
                        permissionManager.requestCameraPermission()
                    }
                    Button("Permission status") {
                        printPermissionStatus()
                    }
                }
                .onChange(of: permissionManager.isCameraPermissionGranted) { _ in
                    checkPermissions()
                }
                .onChange(of: permissionManager.isLocationPermissionGranted) { _ in
                    checkPermissions()
                }
            }
        }
    }
    
    func printPermissionStatus() {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let locationStatus = CLLocationManager.authorizationStatus()
        
        let cameraStatusString = permissionManager.statusString(for: cameraStatus)
        let locationStatusString = permissionManager.statusString(for: locationStatus)
        
        print("Camera Permission Status: \(cameraStatusString)")
        print("Location Permission Status: \(locationStatusString)")
    }
    
    private func checkPermissions() {
        if permissionManager.isCameraPermissionGranted || permissionManager.isLocationPermissionGranted {
            showMainView = true
        }
    }
}

#Preview {
    PermissionsView()
}
