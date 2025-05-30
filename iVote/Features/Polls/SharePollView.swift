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
    
    var qrImage: Image {
        generateQRCode(from: "iVote://vote?id=\(pollID)")
    }
    //Haptic feedback when tapping the copy pollID label
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        
        VStack(spacing: 24) {
            Text("Share this poll")
                .font(.title)

            qrImage
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 240)
            
            Text("Scan this code to vote")
                .foregroundColor(.secondary)
            
            ShareLink(item: qrImage, preview: SharePreview("QR Code for Poll", image: qrImage)) {
                Label("Share QR Code", systemImage: "square.and.arrow.up")
            }
            
            Text("Copy Poll ID to clipboard")
                .foregroundColor(.blue)
                .onTapGesture {
                    generator.impactOccurred()
                    UIPasteboard.general.string = pollID
                }
            
        }
        .padding()
    }
    
    func generateQRCode(from string: String) -> Image {
        
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return Image(cgImage, scale: 1.0, label: Text("Poll Link"))
            }
        }
        return Image(systemName: "xmark.circle")
    }
}

#Preview {
    SharePollView(pollID: "262C430F-38B1-4063-A436-BBCB8E58113A")
}
