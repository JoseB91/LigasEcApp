//
//  ButtonView.swift
//  LigasEcApp
//
//  Created by José Briones on 31/7/25.
//

import SwiftUI

struct ButtonView: View {
    let url: URL
    let table: Table
    let text: String
    let imageViewLoader: (URL, Table) -> ImageView
    
    var body: some View {
        HStack {
            imageViewLoader(url, table)
                .frame(width: 96, height: 48)
            Text(text)
                .font(.title)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

#Preview {
    ButtonView(url: URL(string: "https://www.flashscore.com/res/image/data/2g15S2DO-GdicJTVi.png")!,
               table: .league,
               text: "LigaPro Serie B",
               imageViewLoader: MockImageComposer().composeImageView)
}
