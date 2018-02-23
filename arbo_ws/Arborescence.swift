//
//  Arborescence.swift
//  arbo_ws
//
//  Created by Yann SIVERT on 18/02/2018.
//  Copyright © 2018 Yann SIVERT. All rights reserved.
//

import Cocoa

class Arborescence: NSObject {

	private let kIconSmallImageSize: CGFloat = 16.0
	
	@objc dynamic var id: String
	@objc dynamic var pid: String
	@objc dynamic var proprietaire: String
	@objc dynamic var statut: String
	@objc dynamic var nomProfil: String
	@objc dynamic var table: String
	@objc dynamic var champ: String
	@objc dynamic var lectureSeuleAutresUtilisateurs: String
	@objc dynamic var text: String
	@objc dynamic var leaf: Bool
	@objc dynamic var icon: NSImage
	@objc dynamic var children = [Arborescence]()
	
	init(id:String, pid:String, nomProfil:String, text:String, leaf: Bool = false){
		
		self.id = id
		self.pid = pid
		self.nomProfil = nomProfil
		self.proprietaire = ""
		self.statut = ""
		self.table = ""
		self.champ = ""
		self.lectureSeuleAutresUtilisateurs = ""
		self.text = text
		self.leaf = leaf
		if(leaf == false){
			icon = NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(OSType(kGenericFolderIcon)))
			icon.size = NSMakeSize(kIconSmallImageSize, kIconSmallImageSize)
		}
		else{
			icon = NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(OSType(kGenericEditionFileIcon)))
			icon.size = NSMakeSize(kIconSmallImageSize, kIconSmallImageSize)
		}
	}
}
