//
//  SharePollViewModel.swift
//  iVote
//
//  Created by Nick on 5/30/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

@MainActor
class SharePollViewModel: ObservableObject {
    @Published var pollID: String
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    init(pollID: String) {
        self.pollID = pollID
    }
    
    var qrImage: Image {
        generageQRCode(from: "iVote://vote?id=\(pollID)")
    }
    
    func copyPollIdrtoClipboard() {
        UIPasteboard.general.string = pollID
        generator.impactOccurred()
    }
    
    private func generageQRCode(from string: String) -> Image {
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
