/*==============================================================================
 Authored by Raman Suliman
 Email: Raman.suliman1997@gmail.com
 Copyright 2022
 University of Salford

Copyright (c) 2022. All Rights Reserved.
==============================================================================*/

import UIKit

private let reuseIdentifier = "BloodTypeCell"

class MyViewCollection: UICollectionViewController
{
    private let distanceBetweenCells = 10
    private var dataArray = [BloodType]()
    private var listOfCollectionViewCells = [BloodTypeCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //Get the active model from the delegate instance.
        dataArray = appDelegate.dataModel.getBloodTypes()
        // self.clearsSelectionOnViewWillAppear = false
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        // Register cell classes
        self.collectionView!.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        //collectionView.reloadData()
        collectionView.performBatchUpdates(nil, completion: nil)
        view.backgroundColor = .clear
    }

    public func getCollectionViewCells()-> [BloodTypeCell]
    {
        return listOfCollectionViewCells
    }
    
    public func getCellAtIndex(index: Int) -> BloodTypeCell
    {
        let indexPather = IndexPath(row: index, section: 0)
        return collectionView.cellForItem(at: indexPather) as! BloodTypeCell
    }
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BloodTypeCell
        //Add new cell into the list of live cells.
        listOfCollectionViewCells.append(cell)
        return cell
    }
}

extension MyViewCollection: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10, left: CGFloat(distanceBetweenCells), bottom: 1, right: CGFloat(distanceBetweenCells))
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            //Get the size of collection view frame area.
            let size = collectionView.frame.size
            //The width of cell should exclude the space value between cells.
            let cellWidth = distanceBetweenCells * dataArray.count
            //To divide the cells evenlly in the width, remove the cell spaces from the collection view width then divide the remianing width by the number of cells.
            return CGSize(width: (size.width - CGFloat(cellWidth)) / CGFloat(dataArray.count), height: size.height - 10)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0.0
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0.0
        }
}
