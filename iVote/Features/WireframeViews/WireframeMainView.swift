//
//  WireframeMainView.swift
//  iVote
//
//  Created by Nick on 5/23/25.
//

import SwiftUI

struct WireframeMainView: View {
    var body: some View {
        WireFrameCreatePollView()
        WireFrameFetchPollsView()
        WireFrameVoteByIDView()
        WireFrameVoteTallyView()
    }
}

#Preview {
    WireframeMainView()
}
