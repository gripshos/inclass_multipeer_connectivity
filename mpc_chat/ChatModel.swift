//
//  ChatModel.swift
//  mpc_chat
//
//  Created by Corey Baker on 11/3/18.
//  Copyright © 2018 University of Kentucky - CS 485G. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ChatModel: NSObject{
    
    let appDelagate = UIApplication.shared.delegate as! AppDelegate
    var peerUUIDHash:[String:Int]!
    var peerHashUUID:[Int:String]!
    
    override init() {
        super.init()
    }
    
    convenience init(peerUUIDHashDictionary: [String:Int], peerHashUUIDDictionary: [Int:String]) {
        self.init()
        
        peerUUIDHash = peerUUIDHashDictionary
        peerHashUUID = peerHashUUIDDictionary
    }

    func getAllMessagesFrom(_ room: Room?, completion : (_ sortedMessages:[Message]?) -> ()){
        
        var messageUUIDs = [String]()
        
        guard let messages = room?.messages else {
            completion(nil)
            return
        }
        
        //These messages are coming from a Set and are probably not sorted the way we want them, so we need to get the UUID's and ask CoreData to give it to us sorted
        for message in messages {
            messageUUIDs.append(message.uuid)
        }
        
        findMessages(messageUUIDs, completion: {
            
            (messagesFound) -> Void in
            
            guard let messages = messagesFound else{
                completion(nil)
                return
            }
            
            completion(messages)
        })
    }
    
    func foundPeer(_ peerHash:Int, info: [String:String]?) -> () {
        //Add peers to both dictionaries
        
        guard let uuid = info?[kAdvertisingUUID] else{
            return
        }
        
        peerUUIDHash[uuid] = peerHash
        peerHashUUID[peerHash] = uuid
    }
    
    func lostPeer(_ peerHash:Int, room: Room, completion: (_ lostPeerInThisRoom: Bool) -> ()){
        //Remove from both dictionaries
        guard let uuid = peerHashUUID.removeValue(forKey: peerHash) else{
            completion(false)
            return
        }
        
        _ = peerUUIDHash.removeValue(forKey: uuid)
        
        //Check to see if the peer lost was in this room
        var predicateArray = [NSPredicate]()
        predicateArray.append(NSPredicate(format: "\(kCoreDataPeerAttributepeerUUID) IN %@", [uuid]))
        
        let compoundQuery = NSCompoundPredicate(andPredicateWithSubpredicates: predicateArray)
        
        appDelagate.coreDataManager.queryCoreDataPeers(compoundQuery, completion: {
            (peers) -> Void in
            
            guard let peer = peers?.first else{
                completion(false)
                return
            }
            
            if room.peers.contains(peer){
                completion(true)
            }else{
                completion(false)
            }
        })
    
    }
    
    func getPeerUUIDFromHash(_ peerHash: Int) -> String?{
        return peerHashUUID[peerHash]
    }
    
    func getPeerHashFromUUID(_ peerUUID: String) -> Int?{
        return peerUUIDHash[peerUUID]
    }
    
    func findMessages(_ messageUUIDs: [String], completion : (_ messagesFound:[Message]?) -> ()){
        
        var predicateArray = [NSPredicate]()
        predicateArray.append(NSPredicate(format: "\(kCoreDataMessageAttributeUUID) IN %@", messageUUIDs))
        
        let compoundQuery = NSCompoundPredicate(andPredicateWithSubpredicates: predicateArray)
        
        //This is how you find sorted data
        appDelagate.coreDataManager.queryCoreDataMessages(compoundQuery, sortBy: kCoreDataMessageAttributeCreatedAt, inDescendingOrder: false, completion: {
            (messagesFound) -> Void in
            
            completion(messagesFound)
            
        })
    }
    
    func storeNewMessage(_ uuid: String?=nil, content: String, fromPeer: String, inRoom room: Room, completion : (_ rooms:Message?) -> ()){
        
        //Find peer in CoreData
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "\(kCoreDataPeerAttributepeerUUID) IN %@", [fromPeer]))
        
        let compoundQuery = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        appDelagate.coreDataManager.queryCoreDataPeers(compoundQuery, completion: {
            (peerFound) -> Void in
            
            guard let peer = peerFound?.first else{
                return
            }
            
            let newMessage = NSEntityDescription.insertNewObject(forEntityName: kCoreDataEntityMessage, into: appDelagate.coreDataManager.managedObjectContext) as! Message
            
            newMessage.createNew(uuid, withContent: content, owner: peer)
            room.addToMessages(newMessage)
            
            if save(){
                completion(newMessage)
            }else{
                discard()
                completion(nil)
            }
        
        })
    }
    
    func save()->Bool{
        return appDelagate.coreDataManager.saveContext()
    }
    
    func discard()->(){
        appDelagate.coreDataManager.managedObjectContext.rollback()
    }
}
