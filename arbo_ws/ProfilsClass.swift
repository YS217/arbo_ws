//
//  profils.swift
//  arbo_ws
//
//  Created by Yann SIVERT on 23/02/2018.
//  Copyright © 2018 Yann SIVERT. All rights reserved.
//

import Cocoa
@objc(ProfilsClass)
class ProfilsClass: NSOutlineView {

	var treeController = NSTreeController()
	var menuContextProfil = NSMenu()
	var menuContextDossier = NSMenu()
	
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
	
	
	
	override func menu(for event: NSEvent) -> NSMenu? {
		let point = self.convert(event.locationInWindow, from: nil)
		let row = self.row(at: point)
		let node = self.item(atRow: row) as! NSTreeNode
		let item = node.representedObject as! Arborescence
		
		/*let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
		let ctrl = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "VC1")) as! ViewController
		*/
		
		//Permet la sélection de l'item dans le NSTreeController quand le clic-droit est effectué
		treeController.setSelectionIndexPath(node.indexPath)
	
		if item.leaf == true{
			return menuContextProfil
		}
		else {
			return menuContextDossier
		}
		
	}

	
	
}
