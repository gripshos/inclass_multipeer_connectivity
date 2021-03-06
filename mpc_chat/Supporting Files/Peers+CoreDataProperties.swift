//
//  Peers+CoreDataProperties.swift
//  mpc_chat
//
//  Created by Corey Baker on 11/1/18.
//  Copyright © 2018 University of Kentucky - CS 485G. All rights reserved.
//
//

import Foundation
import CoreData


extension Peers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Peers> {
        return NSFetchRequest<Peers>(entityName: "Peer")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var lastConnected: NSDate?
    @NSManaged public var lastSeen: NSDate?
    @NSManaged public var modifiedAt: NSDate?
    @NSManaged public var peerHash: Int64
    @NSManaged public var peerName: String?
    @NSManaged public var messages: NSSet?
    @NSManaged public var rooms: NSSet?
    @NSManaged public var peersInRooms: NSSet?

}

// MARK: Generated accessors for messages
extension Peers {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

// MARK: Generated accessors for rooms
extension Peers {

    @objc(addRoomsObject:)
    @NSManaged public func addToRooms(_ value: Room)

    @objc(removeRoomsObject:)
    @NSManaged public func removeFromRooms(_ value: Room)

    @objc(addRooms:)
    @NSManaged public func addToRooms(_ values: NSSet)

    @objc(removeRooms:)
    @NSManaged public func removeFromRooms(_ values: NSSet)

}

// MARK: Generated accessors for peersInRooms
extension Peers {

    @objc(addPeersInRoomsObject:)
    @NSManaged public func addToPeersInRooms(_ value: Room)

    @objc(removePeersInRoomsObject:)
    @NSManaged public func removeFromPeersInRooms(_ value: Room)

    @objc(addPeersInRooms:)
    @NSManaged public func addToPeersInRooms(_ values: NSSet)

    @objc(removePeersInRooms:)
    @NSManaged public func removeFromPeersInRooms(_ values: NSSet)

}
