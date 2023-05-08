//
//  GameModelMO+CoreDataProperties.swift
//  Super Tic-Tac-Toe
//
//  Created by Someone on 08.05.2023.
//
//

import Foundation
import CoreData


extension GameModelMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameModelMO> {
        return NSFetchRequest<GameModelMO>(entityName: "GameModelMO")
    }
    @NSManaged public var board: [String]?
    @NSManaged public var title: String?
    @NSManaged public var id: String?
    @NSManaged public var lastY: Int32
    @NSManaged public var lastX: Int32
    @NSManaged public var lastPlayer: String?
    @NSManaged public var isFinished: Bool

}

extension GameModelMO : Identifiable {

}
