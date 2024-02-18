//
//  Home.swift
//  Foodie
//
//  Created by Michael Xcode on 2/17/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var model = DataModel()
    private static let barHeightFactor = 0.15
    init() {
        UINavigationBar.applyCustomAppearance()
    }
    var body: some View {
//        PermissionsView()
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: ExploreView().navigationBarHidden(true)) {
                        Image(systemName: "person.2.fill")
                            .padding(.leading, 10)
                            .font(.system(size: 24))
                    }
                    Spacer()
                    LogoView()
                    Spacer()
                    NavigationLink(destination: ProfileView().navigationBarHidden(false).navigationBarTitle("Profile")) {
                        Image(systemName: "person.circle")
                            .padding(.trailing, 10)
                            .font(.system(size: 30))
                    }
                    
                }
                Spacer()
                NavigationStack {
                    GeometryReader { geometry in
                        ViewfinderView(image:  $model.viewfinderImage )
                            .inverseMask(
                                        RoundedRectangle(cornerRadius: 25)
                                            .frame(width: max(geometry.size.width - 50, 0), height: max(geometry.size.width, 0))
        //                                    .padding(.top, 10)
                                            .padding([.leading, .trailing], 25)
                                            .padding(.bottom, 20)
                                            
                                    )
                            .background(.gray)

                        // Your bottom buttons view
                        VStack {
                            Spacer()
                            foodButton()
                                .foregroundColor(.white)
                                .font(.system(.callout, design: .monospaced))
                            buttonsView()
                                .frame(height: geometry.size.height * Self.barHeightFactor)
                                .background(.gray)
                        }
                    }
                    .task {
                        model.camera.viewModel = model.viewModel
                        await model.camera.start()
                        await model.loadPhotos()
                        await model.loadThumbnail()
                    }
                    .navigationTitle("Camera")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .statusBar(hidden: true)
                }
            }
            .background(.gray)
            .foregroundColor(.white)
        }
    }
    private func foodButton() -> some View {
        NavigationLink {
            FoodInfoView(viewModel: model.camera.viewModel ?? FoodInfoViewModel())
                .background(.gray)
        } label: {
            Label {
                Text("Get Info")
            } icon: {
                Image(systemName: "info.circle")
            }
        }
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            
            Spacer()
            
            NavigationLink {
                PhotoCollectionView(photoCollection: model.photoCollection)
                    .onAppear {
                        model.camera.isPreviewPaused = true
                    }
                    .onDisappear {
                        model.camera.isPreviewPaused = false
                    }
            } label: {
                Label {
                    Text("Gallery")
                } icon: {
                    ThumbnailView(image: model.thumbnailImage)
                }
            }
            
            Button {
                model.camera.takePhoto()
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 62, height: 62)
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
        
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
}

fileprivate extension UINavigationBar {
    
    static func applyCustomAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .gray
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    HomeView()
}

