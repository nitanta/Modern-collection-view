//
//  ViewController.swift
//  Diffable_ds
//
//  Created by Nitanta Adhikari on 12/30/21.
//

import UIKit

struct Section: Hashable {
    var name: String
    var data: [Meta]
}

struct Meta: Hashable {
    var name: String
}

class ViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Meta>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Meta>

    @IBOutlet weak var collectionView: UICollectionView!
    
    let ds: [Section] = [
        Section(name: "X", data: [Meta(name: "A"), Meta(name: "B"), Meta(name: "C"), Meta(name: "D")]),
        Section(name: "Y", data: [Meta(name: "E"), Meta(name: "F"), Meta(name: "G"), Meta(name: "H")])
    ]
    
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        collectionView.delegate = self
        collectionView.register(UINib(nibName: MetaCollectionViewCell.identifier, bundle: nibBundle), forCellWithReuseIdentifier: MetaCollectionViewCell.identifier)
        collectionView.register(SectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderReusableView.identifier)
        collectionView.collectionViewLayout = generateLayout()
        applySnapshot(animatingDifferences: false)
    }

}

extension ViewController {
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, metadata) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MetaCollectionViewCell", for: indexPath) as? MetaCollectionViewCell
                cell?.titleLabel.text = metadata.name
                return cell
            })
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderReusableView.identifier, for: indexPath) as? SectionHeaderReusableView
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            view?.titleLabel.text = section.name
            return view
        }
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(ds)
        ds.forEach { section in
            snapshot.appendItems(section.data, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func generateLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(60)
            )
            
            let itemCount = 4
            
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 10

            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(20)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        })
        return layout
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //guard let meta = dataSource.itemIdentifier(for: indexPath) else {
         // return
        //}
    }
}

