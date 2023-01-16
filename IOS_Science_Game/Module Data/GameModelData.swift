/*==============================================================================
 Authored by Raman Suliman
 Email: Raman.suliman1997@gmail.com
 Copyright 2022
 University of Salford

Copyright (c) 2022. All Rights Reserved.
==============================================================================*/

import UIKit

class GameModelData
{
    //List of blood types used to be accessed via the AppDelegate to share instances of BloodType objetcs.
    private var bloodTypes = [BloodType]()
    
    init()
    {
        bloodTypes.append(BloodType(imageName: "O+", answers: ["O-", "O+"], cellNumber: bloodTypes.count))
        bloodTypes.append(BloodType(imageName: "O-", answers: ["O-"], cellNumber: bloodTypes.count))
        bloodTypes.append(BloodType(imageName: "A-", answers: ["O-", "A-"], cellNumber: bloodTypes.count))
        bloodTypes.append(BloodType(imageName: "A+", answers: ["O-", "O+", "A+", "A-"], cellNumber: bloodTypes.count))
        bloodTypes.append(BloodType(imageName: "B-", answers: ["O-", "B-"], cellNumber: bloodTypes.count))
        bloodTypes.append(BloodType(imageName: "B+", answers: ["O-", "O+", "B+", "B-"], cellNumber: bloodTypes.count))
        bloodTypes.append(BloodType(imageName: "AB+", answers: ["O-", "O+", "A+", "A-", "B+", "B-", "AB-", "AB+"], cellNumber: bloodTypes.count))
        bloodTypes.append(BloodType(imageName: "AB-", answers: ["O-", "A-", "B-", "AB-"], cellNumber: bloodTypes.count))
    }
    
    open func getBloodTypes()->[BloodType]
    {
        return bloodTypes
    }
}

class BloodType
{
    private var bloodTypeImageName:String
    private var listOfCompatibleAnswers = [String]()
    private var associatedWithCollectionCell:Int
    var getLinkedCell: Int{
        return associatedWithCollectionCell
    }
    var getBloodTypeImageName: String{
        return bloodTypeImageName
    }
    var getCompatibleBloodTypes: [String]{
        return listOfCompatibleAnswers
    }
    init(imageName: String, answers: [String], cellNumber: Int)
    {
        self.bloodTypeImageName = imageName
        listOfCompatibleAnswers = answers
        associatedWithCollectionCell = cellNumber
    }
}
