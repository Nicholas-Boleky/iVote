//
//  SharePollView.swift
//  iVote
//
//  Created by Nick on 5/27/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct SharePollView: View {
    let pollID: String
    @State private var isSharing: Bool = false
    
    var qrImage: UIImage? {
        generateQRCode(from: "iVote://vote?id=\(pollID)")
    }
    
    var body: some View {
        
        VStack(spacing: 24) {
            Text("Share this poll")
                .font(.title)
            
//             if let image = qrImage {
            Image(uiImage: qrImage ?? UIImage())
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
   //         }
            
            Text("Scan this code to vote")
                .foregroundColor(.secondary)
            
            Button("Share QR Code") {
                isSharing = true
            }
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $isSharing) {
                ShareLink(item: qrImage ?? UIImage(), preview: SharePreview("QR Code for Poll", image: qrImage ?? UIImage()))
                //ShareLink(items: [qrImage])
                //ShareSheet(activityItems: [qrImage])
            }
        }
        .padding()
    }
    
    func generateQRCode(from string: String) -> UIImage {
        
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

#Preview {
    SharePollView(pollID: "262C430F-38B1-4063-A436-BBCB8E58113A")
}
//taken from https://developer.apple.com/forums/thread/747078
//uiImage must conform to tranferable in order to be shared
//TODO: future refactor
extension UIImage: Transferable {
        
        public static var transferRepresentation: some TransferRepresentation {
            
            DataRepresentation(exportedContentType: .png) { image in
                if let pngData = image.pngData() {
                    return pngData
                } else {
                    // Handle the case where UIImage could not be converted to png.
                    throw ConversionError.failedToConvertToPNG
                }
            }
        }
        
        enum ConversionError: Error {
            case failedToConvertToPNG
        }
    }
