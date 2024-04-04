//
//  QuickActionsCell.swift
//  BankingApp
//
//  Created by Fatima Abdinli on 08.02.24.
//

import UIKit

class QuickActionsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var quickActionCollection: UICollectionView!

    var quickActionCallBack: ((Int) -> Void)?
    var quickActionList: [QuickAction] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    
    fileprivate func setUpView() {
        quickActionCollection.register(UINib(nibName: "QuickActionCell", bundle: nil),forCellWithReuseIdentifier: "QuickActionCell")
    }
}

extension QuickActionsCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        quickActionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickActionCell", for: indexPath) as! QuickActionCell
        cell.actionImage.image = UIImage(systemName: quickActionList[indexPath.row].image ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = quickActionList[indexPath.row].id else {return}
        print(quickActionList[indexPath.row].id ?? 0)
        quickActionCallBack?(id)
    }
}
