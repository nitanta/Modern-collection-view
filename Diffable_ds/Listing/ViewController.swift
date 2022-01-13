//
//  ViewController.swift
//  Diffable_ds
//
//  Created by Nitanta Adhikari on 12/30/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<String, LocalMovie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, LocalMovie>

    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<LocalMovie> = {
        let fetchRequest: NSFetchRequest<LocalMovie> = LocalMovie.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coredataManager.managedObjectContext, sectionNameKeyPath: "key", cacheName: nil)

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    private lazy var dataSource = makeDataSource()
    
    //private var updates: [Update] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try? fetchedResultsController.performFetch()
        setup()
        setupUI()
    }
    
    func setup() {
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.register(UINib(nibName: MetaCollectionViewCell.identifier, bundle: nibBundle), forCellWithReuseIdentifier: MetaCollectionViewCell.identifier)
        collectionView.register(SectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderReusableView.identifier)
        collectionView.collectionViewLayout = generateLayout()
        applySnapshot(animatingDifferences: false)
    }
    
    func setupUI() {
        collectionView.accessibilityLabel = AccessibilityIdentifiers.ListView.collectionView
        textField.accessibilityLabel = AccessibilityIdentifiers.ListView.textField
        addButton.accessibilityLabel = AccessibilityIdentifiers.ListView.textField
        removeButton.accessibilityLabel = AccessibilityIdentifiers.ListView.textField
        
        addButton.titleLabel?.font = AppFont.system12
        removeButton.titleLabel?.font = AppFont.system12
        
        addButton.setTitle(Constants.add, for: .normal)
        removeButton.setTitle(Constants.remove, for: .normal)
    }
    
    let coredataManager = CoreDataManager.shared
    @IBAction func addObject(_ sender: Any) {
        guard let name = textField.text, !name.isEmpty else { return }
        addRandomMovie(name: name)
        textField.text = nil
    }
    
    @IBAction func removeObject(_ sender: Any) {
        guard let selectedIndex = collectionView.indexPathsForSelectedItems?.first, let cell = collectionView.cellForItem(at: selectedIndex) as? MetaCollectionViewCell else { return }
        removeRandomMovie(id: cell.id)
    }
}

extension ViewController {
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, metadata) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MetaCollectionViewCell", for: indexPath) as? MetaCollectionViewCell
                cell?.titleLabel.text = metadata.name
                cell?.id = metadata.id
                return cell
            })
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderReusableView.identifier, for: indexPath) as? SectionHeaderReusableView
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            view?.titleLabel.text = section
            return view
        }
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(fetchedResultsController.sectionIndexTitles)
        fetchedResultsController.sections?.forEach({ section in
            snapshot.appendItems(section.objects as? [LocalMovie] ?? [], toSection: section.indexTitle)
        })
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func generateLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(60)
            )
            
            let itemCount = 1
            
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
        //guard let meta = dataSource.itemIdentifier(for: indexPath) else { return }
        
    }
}

extension ViewController {
    func addRandomMovie(name: String) {
        _ = LocalMovie.saveMovies(UUID().uuidString, name: name)
        coredataManager.saveContext()
    }
    
    func removeRandomMovie(id: String) {
        LocalMovie.removeMovie(id)
        coredataManager.saveContext()
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        applySnapshot()
    }
}

extension ViewController {
    struct Constants {
        static let add = "ADD"
        static let remove = "REMOVE"
    }
}

/*
extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError("Index path should be not nil") }
            updates.append(.insert(indexPath, false))
        case .update:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            updates.append(.update(indexPath))
        case .move:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            guard let newIndexPath = newIndexPath else { fatalError("New index path should be not nil") }
            updates.append(.move(indexPath, newIndexPath))
        case .delete:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            updates.append(.delete(indexPath, false))
        @unknown default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.processUpdates(self.updates)
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updates = []
    }
    
    private func processUpdates(_ updates: [Update]?) {
        guard let updates = updates else {
            return collectionView.reloadData()
        }
        self.collectionView.performBatchUpdates({ [weak self] in
            guard let self = self else {return}
            for update in updates {
                switch update {
                case .insert(let indexPath, _):
                    self.collectionView.insertItems(at: [indexPath])
                case .update(let indexPath):
                    self.collectionView.reloadItems(at: [indexPath])
                case .move(let indexPath, let newIndexPath):
                    self.collectionView.deleteItems(at: [indexPath])
                    self.collectionView.insertItems(at: [newIndexPath])
                case .delete(let indexPath, _):
                    self.collectionView.deleteItems(at: [indexPath])
                }
            }
        })
    }
    
}

public enum Update {
    case insert(IndexPath, Bool)
    case update(IndexPath)
    case move(IndexPath, IndexPath)
    case delete(IndexPath, Bool)
}
*/
