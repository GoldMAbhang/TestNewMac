//
//  TimelineVC.swift
//  TestNewMac
//
//  Created by Abhang on 17/03/26.
//

import UIKit

struct TimelineItem {
    let title: String
    let subtitle: String
    let isCompleted: Bool
}

class TimelineVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var items: [TimelineItem] = []
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollection()
        loadData()
    }
    
    func setupCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isUserInteractionEnabled = true
        
        collectionView.register(TimelineCell.self, forCellWithReuseIdentifier: "cell")
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    func loadData() {
        items = [
            TimelineItem(title: "", subtitle: "", isCompleted: true),
            TimelineItem(title: "", subtitle: "", isCompleted: true),
            TimelineItem(title: "", subtitle: "", isCompleted: true),
            TimelineItem(title: "", subtitle: "", isCompleted: true)
        ]
    }
    
    
    
    // MARK: DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TimelineCell
        
        let item = items[indexPath.item]
        
        cell.configure(item: item, index: indexPath.item)
        
        return cell
    }
    
    // MARK: Layout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 140, height: collectionView.frame.height)
    }
}
