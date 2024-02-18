/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct CameraView: View {
    @StateObject private var model = DataModel()
 
    private static let barHeightFactor = 0.15
    
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                ViewfinderView(image:  $model.viewfinderImage )
//                    .overlay(alignment: .top) {
//                        Color.white
//                            .opacity(0.75)
//                            .frame(height: geometry.size.height * Self.barHeightFactor)
//                    }
//                    .overlay(alignment: .center)  {
//                        Color.black
//                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
//                            .frame(height: geometry.size.height * (1 - (Self.barHeightFactor * 2)))
//                            .padding(.top, 10)
//                            .padding([.leading, .trailing], 25)
//                            .accessibilityElement()
//                            .accessibilityLabel("View Finder")
//                            .accessibilityAddTraits([.isImage])
//                    }
//                    .overlay(alignment: .bottom) {
//                        buttonsView()
//                            .frame(height: geometry.size.height * Self.barHeightFactor)
//                            .background(.gray)
//                    }
//                    .background(.gray)
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
    
    private func foodButton() -> some View {
        NavigationLink {
            FoodInfoView(viewModel: model.camera.viewModel ?? FoodInfoViewModel())
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

#Preview {
    CameraView()
}
