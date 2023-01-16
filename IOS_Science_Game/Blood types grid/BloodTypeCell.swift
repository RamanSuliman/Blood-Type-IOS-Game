/*==============================================================================
 Authored by Raman Suliman
 Email: Raman.suliman1997@gmail.com
 Copyright 2022
 University of Salford

Copyright (c) 2022. All Rights Reserved.
==============================================================================*/

import UIKit

class BloodTypeCell: UICollectionViewCell
{
    //let defaultImage = UIImage(named: "background.jpeg")
    private let myReuseIdentifier = "MyTableCell"
    private var listOfTableCells = [MyTableCell]()
    
    @IBOutlet weak var bloodTypesTable: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //To get rid of the extra empty cells.
        bloodTypesTable.tableFooterView = UIView()
        //Setup table background image.
        bloodTypesTable.backgroundView = UIImageView(image: UIImage(named: "table.png"))
        //Define the separator line style between cells.
        bloodTypesTable.separatorStyle = .singleLine
        //Set the vertical scrolling option into false.
        bloodTypesTable.showsVerticalScrollIndicator = false
        //Register the XIB custom cell as the default cell for the tableview.
        bloodTypesTable!.register(UINib(nibName: myReuseIdentifier, bundle: nil), forCellReuseIdentifier: myReuseIdentifier)
        bloodTypesTable.dataSource = self
        bloodTypesTable.delegate = self
    }
    /**
                -This method returns the list of cells the table is holder to allow other class objects to access and modify cell content.
     */
    public func getTableCells()-> [MyTableCell]
    {
        return listOfTableCells
    }
}

extension BloodTypeCell: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myReuseIdentifier) as! MyTableCell
        //cell.setBloodTypeImages(imageLeft: defaultImage!, imageRight: defaultImage!)
        //Add the cell to the list
        listOfTableCells.append(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //let currentImage = images[indexPath.row]
        return bloodTypesTable.frame.height / CGFloat(4)
    }
}

extension BloodTypeCell: UITableViewDelegate
{
    
}

