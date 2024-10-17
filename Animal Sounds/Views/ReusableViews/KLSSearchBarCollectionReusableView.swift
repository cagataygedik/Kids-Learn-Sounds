//
//  KLSSearchBarCollectionReusableView.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 17.10.2024.
//

import UIKit
import SnapKit

final class KLSSearchBarCollectionReusableView: UICollectionReusableView {
    static let reuseID = "KLSSearchBarCollectionReusableView"
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = NSLocalizedString("search", comment: "Search placeholder text")
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
