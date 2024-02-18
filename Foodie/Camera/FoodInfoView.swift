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
import Combine

// Define simplified model structures
struct AnalysisResponse: Codable {
    let items: [Foods]
}

struct Foods: Codable {
    let food: [FoodItem]
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
            }
            
            DispatchQueue.main.async {
                let (names, confidences) = self.parseJSON(data: data)
                self.displayNames = names
                self.confidences = confidences
            }
        }
        task.resume()
        
    }
    
    func parseJSON(data: Data) -> ([String], [Double]) {
        let decoder = JSONDecoder()
        var displayNames: [String] = []
        var confidences: [Double] = []

        do {
            let response = try decoder.decode(AnalysisResponse.self, from: data)
            
            for item in response.items {
                for foodItem in item.food {
                    if foodItem.confidence > 0.5 {
                        displayNames.append(foodItem.foodInfo.displayName)
                        confidences.append(foodItem.confidence)
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.uploadResult = "Failed to decode JSON: \(error)"
            }
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

//struct InputField: View {
//    @State private var inputText: String = ""
//    var onSubmit: (String) -> Void
//
//    var body: some View {
//        HStack {
//            TextField("Enter new item", text: $inputText)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .onReceive(Just(inputText)) { inputValue in
//                    print("Current input: \(inputValue)")
//                }
//            Button(action: {
//                // Call the closure with the current input text
//                onSubmit(inputText)
//                // Clear the input field after submission
//                inputText = ""
//            }) {
//                Text("Add")
//            }
//        }
//        .padding()
//    }
//}


struct FoodInfoView: View {
    @ObservedObject var viewModel: FoodInfoViewModel
    @State private var selectedRows: [Bool] = []
    @State private var inputText: String = ""
    @Environment(\.presentationMode) var presentationMode // Add this line

    var body: some View {
        List {
            imageView
            itemCountView
            ForEach(Array(zip(viewModel.displayNames.indices, viewModel.displayNames)), id: \.0) { index, name in
                foodItemRow(forIndex: index, name: name)
            }
            HStack {
                TextField("Enter new item", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .onReceive(Just(inputText)) { inputValue in
                        print("Current input: \(inputValue)")
                    }
                Spacer()
                Button(action: {
                    print("Button Pressed")
                    // This closure is called when the "Add" button is pressed.
                    // Ensure selectedRows is updated to include the new item.
                    self.selectedRows.append(false)
                    // Add the new item to the viewModel's displayNames list.
                    viewModel.displayNames.append(inputText)
                    // Clear the input field after submission
                    inputText = ""
                }) {
                    Text("Add")
                }
            }
            .padding()
            .foregroundColor(Color.white)
            .listRowSeparator(.hidden)
//            .listRowBackground(Color.gray)
            .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                Spacer()
                Button("Submit photo info") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(3)
                .background(Color.gray)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
//        .background(.gray)
        .navigationTitle("Food Info")
//        .onAppear {
//            // Initialize or update selectedRows when the view appears
//            // This assumes that displayNames is populated before the view appears
//            self.selectedRows = Array(repeating: false, count: viewModel.displayNames.count)
//        }
        .onChange(of: viewModel.displayNames) { _ in
            // If displayNames has more items, append false to selectedRows for each new item
            if viewModel.displayNames.count > self.selectedRows.count {
                self.selectedRows.append(contentsOf: Array(repeating: false, count: viewModel.displayNames.count - self.selectedRows.count))
            }
            // If displayNames has fewer items, remove the excess from selectedRows
            else if viewModel.displayNames.count < self.selectedRows.count {
                self.selectedRows.removeSubrange(viewModel.displayNames.count..<self.selectedRows.count)
            }
            // If they are equal, no update is needed
        }
    }

    // Extracted image view
    private var imageView: some View {
        Group {
            if let image = viewModel.displayImage {
                image
                    .resizable()
                    .scaledToFit()
                    .padding()
            } else {
                Text("No image selected")
                    .padding()
            }
        }
    }

    // Extracted item count view
    private var itemCountView: some View {
        Text("Total items: \(viewModel.displayNames.count)")
    }

    // Extracted view for a single row in the food list
    private func foodItemRow(forIndex index: Int, name: String) -> some View {
        HStack {
            Text(name)
            Spacer()
//            Text(String(format: "%.2f", viewModel.confidences[index]))
            Image(systemName: self.selectedRows.indices.contains(index) && self.selectedRows[index] ? "checkmark.square.fill" : "checkmark.square")
        }
        .onTapGesture {
            if index < self.selectedRows.count {
                self.selectedRows[index].toggle()  // Ensure index is in bounds
            }
        }
        .padding(5)
        .background(self.selectedRows.indices.contains(index) && self.selectedRows[index] ? Color.gray.opacity(0.3) : Color.clear)
        .cornerRadius(10) // Apply corner radius to background
    }
}

