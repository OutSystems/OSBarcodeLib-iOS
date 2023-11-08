import SwiftUI

/// The library's main view.
struct OSBARCScannerView: View {
    /// The object containing the scanned value.
    @Binding var scanResult: String
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Camera Stream
            OSBARCScannerViewControllerRepresentable(result: $scanResult)
            
            // Cancel Button
            Button {
                scanResult = "" // cancelling translates in scanResult being empty.
            } label: {
                Image(systemName: "xmark")  // SF Symbols value.
                    .imageScale(.large)
                    .foregroundStyle(forColour: .white)
                    .padding(32)
            }
        }
    }
}
