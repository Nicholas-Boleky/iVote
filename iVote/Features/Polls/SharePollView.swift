//
//  SharePollView.swift
//  iVote
//
//  Created by Nick on 5/27/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct SharePollView: View {
    @EnvironmentObject var appRouter: AppRouter
    @ObservedObject var viewModel: SharePollViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Button {
                appRouter.navigate(to: .landingPage)
            } label: {
                Label("Home", systemImage: "chevron.left")
            }
            .padding()
            
            VStack(spacing: 24){
                Text("Share this poll")
                    .font(.title)
                
                viewModel.qrImage
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
                
                Text("Scan this code to vote")
                    .foregroundColor(.secondary)
                
                ShareLink(item: viewModel.qrImage, preview: SharePreview("QR Code for Poll", image: viewModel.qrImage)) {
                    Label("Share QR Code", systemImage: "square.and.arrow.up")
                }
                
                Text("Copy Poll ID to clipboard")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        viewModel.copyPollIdrtoClipboard()
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    SharePollView(viewModel: SharePollViewModel(pollID: "262C430F-38B1-4063-A436-BBCB8E58113A"))
}
