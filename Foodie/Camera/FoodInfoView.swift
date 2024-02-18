//
//  FoodInfoView.swift
//  Foodie
//
//  Created by Michael Xcode on 2/17/24.
//

import SwiftUI
import AVFoundation
import CoreImage
import UIKit
import os.log
import Foundation

// Define simplified model structures
struct AnalysisResponse: Codable {
    let items: [Food]
}

struct Food: Codable {
    let foods: [FoodItem]
}

struct FoodItem: Codable {
    let confidence: Double
    let foodInfo: FoodInfo
    
    enum CodingKeys: String, CodingKey {
        case confidence
        case foodInfo = "food_info"
    }
}

struct FoodInfo: Codable {
    let displayName: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
    }
}


class FoodInfoViewModel: ObservableObject {
    @Published var uploadResult: String = "Still loading..."
    @Published var displayImage: Image?
    @Published var displayNames: [String] = []
    @Published var confidences: [Double] = []
    
    func uploadImage(imageData: Data) {
        guard let url = URL(string: "https://vision.foodvisor.io/api/1.0/en/analysis/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("Api-Key ndhsa84A.XcfqXkcDgOcBxfVKqp9RHKCDUVxv4CZM", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpeg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        
        // Additionally, convert imageData to Image for SwiftUI and assign to displayImage
        DispatchQueue.main.async {
            if let uiImage = UIImage(data: imageData) {
                self.displayImage = Image(uiImage: uiImage)
            }
            else {
                print("Failed to convert imageData to UIImage")
            }
        }

        // Sending the request
        let task = URLSession.shared.uploadTask(with: request, from: body) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.uploadResult = "Error: \(error?.localizedDescription ?? "Unknown error")"
                }
                return
            }
            (self.displayNames, self.confidences) = parseJSON(data: data)
//            do {
//                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    DispatchQueue.main.async {
//                        
//                        self.uploadResult = jsonResult.description
//                    }
//                }
//                else {
//                    self.uploadResult = "Nothing as JSON idk why"
//                }
//            } catch {
//                self.uploadResult = "Failed to convert to JSON "
//            }
        }
        task.resume()
        
    }
    
    func parseJSON(data: Data) -> ([String], [Double]) {
        let decoder = JSONDecoder()
        var displayNames: [String] = []
        var confidences: [Double] = []

        do {
            let response = try decoder.decode(AnalysisResponse.self, from: data)
            
            for food in response.items {
                for foodItem in food.foods {
                    displayNames.append(foodItem.foodInfo.displayName)
                    confidences.append(foodItem.confidence)
                }
            }
        } catch {
            print("Failed to decode JSON: \(error)")
        }
        
        return (displayNames, confidences)
    }

}

// Helper extension to easily append strings to Data
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

struct FoodInfoView: View {
    @ObservedObject var viewModel: FoodInfoViewModel

    var body: some View {
        ScrollView {
            if let image = viewModel.displayImage {
                image
                    .resizable() // Make sure the image fits well in your layout
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } else {
                Text("No image selected")
                    .padding()
            }

            Text(viewModel.uploadResult)
                .padding()
        }
        .navigationTitle("Food Info")
    }
}
