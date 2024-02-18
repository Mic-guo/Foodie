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

class FoodInfoViewModel: ObservableObject {
    @Published var uploadResult: String = "Still loading..."
    @Published var displayImage: Image?
    
    func uploadImage(imageData: Data) {
        let url = URL(string: "https://vision.foodvisor.io/api/1.0/en/analysis/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set additional headers
        request.setValue("Api-Key ndhsa84A.XcfqXkcDgOcBxfVKqp9RHKCDUVxv4CZM", forHTTPHeaderField: "Authorization")
        
        var body = Data()
        
        let boundary = "Boundary-\(UUID().uuidString)"
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
        let task = URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                self.uploadResult = "HTTP Status Code: \(httpResponse.statusCode)"
            }
            guard let data = data, error == nil else {
                self.uploadResult = "Error Unkown error"
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        self.uploadResult = jsonResult.description
                    }
                }
                else {
                    self.uploadResult = "Nothing as JSON idk why"
                }
            } catch {
                self.uploadResult = "Failed to convert to JSON "
                print("Failed to convert data to JSON")
            }
        }
        task.resume()
        
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

//struct FoodInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodInfoView()
//    }
//}
