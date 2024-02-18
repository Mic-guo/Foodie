//
//  FriendsFeedView.swift
//  Foodie
//
//  Created by Michael Xcode on 2/18/24.
//

import SwiftUI
import UIKit

struct ShareSheetView: UIViewControllerRepresentable {
    var items: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct FriendsFeedView: View {
    @State var photoUrls: [String] = []
    @State var foods: [FoodDatabase] = []

    @State private var showingHeart: [String: Bool] = [:]
    @State private var showingShareSheet = false
    @State private var selectedImage: UIImage?
    
    
    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    Text("Explore around you!")
                        .font(.system(size: 25))
                        .fontDesign(.monospaced)
                    ForEach(photoUrls, id: \.self) { url in
                        //                    print(url)
                        ZStack(alignment: .bottomTrailing) {
                            AsyncImage(url: URL(string: url)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 400) // Set the frame of the image
                                        .clipShape(RoundedRectangle(cornerRadius: 50))
                                        .padding()
                                        .ignoresSafeArea()
                                case .failure:
                                    Text("Could not load image")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            
                            .overlay(
                                Group {
                                    if showingHeart[url, default: false] {
                                        Image(systemName: "heart.fill")
                                            .shadow(radius: 5)
                                            .foregroundColor(.red)
                                        //                                        .padding(.bottom, 5)
                                            .padding([.bottom, .leading], 30)
                                            .transition(.scale)
                                            .scaleEffect(showingHeart[url, default: false] ? 2 : 1)
                                            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0), value: showingHeart[url, default: false])
                                    }
                                },
                                alignment: .bottomLeading
                            )
                            .onTapGesture(count: 2, perform: {
                                withAnimation {
                                    showingHeart[url] = !(showingHeart[url] ?? false)
                                }
                            })
                            
                            Button(action: {
                                loadImageFromURLAsync(urlString: url) { image in
                                    DispatchQueue.main.async {
                                        self.selectedImage = image
                                        self.showingShareSheet = true
                                    }
                                }
                            }) {
                                if showingHeart[url, default: false] {
                                    Image(systemName: "square.and.arrow.up")
                                        .padding()
                                        .background(Color.black.opacity(0.5))
                                        .clipShape(Circle())
                                        .foregroundColor(.white)
                                        .padding([.bottom, .trailing], 25)
                                        .padding(.trailing, 10)
                                }
                            }
                            //                        .padding() // Add padding to position the button inside the image's bottom-right corner
                        }
                    }
                    
                }
            }
            .frame(maxWidth: .infinity)
            .scrollIndicators(.hidden)
        }
        .onAppear {
            getAllUrls()
        }
        .sheet(isPresented: $showingShareSheet) {
            if let imageToShare = selectedImage {
                ShareSheetView(items: [imageToShare])
            }
        }
//        .edgesIgnoringSafeArea(.horizontal)
//        .background(.gray)
    }

    func loadImageFromURLAsync(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
    }

    func getAllUrls() {
        Task {
            do {
                print("getting urls")
                let response = try await supabase.database
                    .from("foods")
                    .select()
                    .execute()
                let decodedResponse = try JSONDecoder().decode([FoodDatabase].self, from: response.data)
                for food in decodedResponse {
                    do {

                        let signedURLResponse = try await supabase.storage
                            .from("photos")
                            .createSignedURL(path: food.url, expiresIn: 604800)
                        // Assuming the signed URL is directly accessible or within a property of the response
    //                            print(signedURLResponse)
                        let signedURL = signedURLResponse.absoluteString
//                        print(signedURL)
                        DispatchQueue.main.async {
                            // Append the signed URL to the photoUrls array
                            self.photoUrls.append(String(signedURL))
                        }

                    } catch {
                        print("Failed to create signed URL for \(food.url): \(error)")
                    }
                }
                    
            } catch {
                print("Failed to fetch foods: \(error)")
            }
        }
    }
}

    
    

#Preview {
    FriendsFeedView()
}
