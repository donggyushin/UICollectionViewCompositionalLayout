//
//  ViewController.swift
//  CompositionalLayout
//
//  Created by 신동규 on 2022/02/11.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    private let cellId = "cellID"
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: ViewController.createLayout())
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        view.register(Header.self, forSupplementaryViewOfKind: ViewController.categoryHeaderId, withReuseIdentifier: Header.identifier)
        view.register(Header.self, forSupplementaryViewOfKind: ViewController.playlistHeaderId, withReuseIdentifier: Header.identifier)
        view.dataSource = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, env in
            
            if sectionNumber == 0 {
                let item: NSCollectionLayoutItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                return section
            } else if sectionNumber == 1 {
                let item: NSCollectionLayoutItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(0.25), heightDimension: .absolute(150)))
                item.contentInsets.bottom = 16
                item.contentInsets.trailing = 16
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.leading = 16
                section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: ViewController.categoryHeaderId, alignment: .topLeading)]
                return section
            } else if sectionNumber == 2 {
                let item: NSCollectionLayoutItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)))
                item.contentInsets.trailing = 32
                let group: NSCollectionLayoutGroup = .horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .estimated(200)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets.leading = 16
                section.contentInsets.top = 16
                return section
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 16
                item.contentInsets.bottom = 16
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(300)), subitem: item, count: 5)
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: ViewController.playlistHeaderId, alignment: .topLeading)]
                section.contentInsets.leading = 16
                section.orthogonalScrollingBehavior = .groupPaging
                return section
            }
        }
    }
    
    static let categoryHeaderId = "categoryHeaderId"
    static let playlistHeaderId = "playlistHeaderId"
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Header.identifier, for: indexPath) as? Header ?? Header()
        view.label.text = "categories"
        
        if kind == ViewController.playlistHeaderId {
            view.label.text = "playlist"
        }
        
        return view
    }

}

class Header: UICollectionReusableView {
    
    static let identifier = "header"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    override func layoutSubviews() {
        label.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 8
        } else if section == 2 {
            return 4
        } else {
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = indexPath.row.isMultiple(of: 2) ? .red : .blue
        return cell
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return ViewController()
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
        typealias UIViewControllerType = UIViewController
    }
}
