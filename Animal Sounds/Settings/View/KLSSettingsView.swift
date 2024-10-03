//
//  KLSSettingsView.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 13.05.2024.
//

import SwiftUI

struct KLSSettingsView: View {
    @State private var selectedOption: KLSSettingsOption? = nil
    
    let viewModel: KLSSettingsViewModel
    
    init(viewModel: KLSSettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            ForEach(viewModel.cellViewModels) { cellViewModel in
                KLSSettingsRowView(cellViewModel: cellViewModel, isSelected: self.selectedOption == cellViewModel.type)
                    .onTapGesture {
                        self.selectedOption = cellViewModel.type
                        cellViewModel.onTapHandler(cellViewModel.type)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.selectedOption = nil
                        }
                    }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(PlainListStyle())
        .background(Color(Constants.mainBackgroundColor!))
    }
}

struct KLSSettingsRowView: View {
    let cellViewModel: KLSSettingsCellViewModel
    let isSelected: Bool
    
    var body: some View {
        HStack {
            if let image = cellViewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.white)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding(8)
                    .background(Color(Constants.mainAppColor!))
                    .cornerRadius(8)
            }
            Text(cellViewModel.title)
                .padding(.leading, 10)
                .foregroundStyle(.black)
            Spacer()
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 15)
        .background(isSelected ? Color.gray.opacity(0.3) : Color(Constants.mainBackgroundColor!))
        .cornerRadius(8)
    }
}


#Preview {
    KLSSettingsView(viewModel: .init(cellViewModels: KLSSettingsOption.allCases.compactMap({
        return KLSSettingsCellViewModel(type: $0) { option in
            
        }
    })))
}

