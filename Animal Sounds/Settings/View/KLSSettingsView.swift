//
//  KLSSettingsView.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 13.05.2024.
//

import SwiftUI

struct KLSSettingsView: View {
    let viewModel: KLSSettingsViewModel
    
    init(viewModel: KLSSettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.red)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
                
                Spacer()
            }
            .padding(.bottom, 3)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}

#Preview {
    KLSSettingsView(viewModel: .init(cellViewModels: KLSSettingsOption.allCases.compactMap({
        return KLSSettingsCellViewModel(type: $0) { option in
            
        }
    })))
}
