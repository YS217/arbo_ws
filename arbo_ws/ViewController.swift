//
//  ViewController.swift
//  arbo_ws
//
//  Created by Yann SIVERT on 18/02/2018.
//  Copyright © 2018 Yann SIVERT. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {

	@IBOutlet weak var profilsTreeController: NSTreeController!
	@IBOutlet weak var profilsOutlineView: ProfilsClass!
	@IBOutlet weak var menuContextProfil: NSMenu!
	@IBOutlet weak var menuContextDossier: NSMenu!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		
		let racine = Arborescence(id: "65535", pid: "", nomProfil: "", text: "Racine")
		profilsTreeController.addObject(racine)
		
		profilsOutlineView.treeController = profilsTreeController
		profilsOutlineView.menuContextProfil = menuContextProfil
		profilsOutlineView.menuContextDossier = menuContextDossier
		
	}

	
	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	
	
	//
	// MARK: - Delegate du NSOutlineView
	//
	//Déclenché quand un élément est ouvert
	func outlineViewItemWillExpand(_ notification: Notification) {
		
		//Récupération du NSOutlineView qui a déclenché l'événement
		guard let outlineView = notification.object as? NSOutlineView else {
			return
		}
		
		//Si présence de plusieurs NSOutlineView on contrôle celle qui a déclenché le traitement
		switch outlineView {
		case profilsOutlineView:
			let noeud = notification.userInfo!["NSObject"] as! NSTreeNode
			profilsTreeController.setSelectionIndexPath(noeud.indexPath)
			let node = (notification.userInfo!["NSObject"] as! NSTreeNode).representedObject as! Arborescence
			if node.children.count == 0{
				chargerProfils(node: node)
			}
		default: break
		}
		
	}
	
	
	//
	// MARK: - Actions
	//
	@IBAction func creerSousDossier(_ sender: NSMenuItem) {

		if self.profilsTreeController.selectedNodes.count>0{
			let node = self.profilsTreeController.selectedObjects[0] as! Arborescence
			print(node.text)
		}
		
	}
	
	@IBAction func suppirmerProfil(_ sender: NSMenuItem) {
		
		if self.profilsTreeController.selectedNodes.count>0{
			let node = self.profilsTreeController.selectedObjects[0] as! Arborescence
			print(node.text)
		}
	}
	
	//
	// MARK: - Mes methodes
	//
	func chargerProfils(node: Arborescence){
		
		let webService = WebService()
		
		webService.request(
			url: "http://localhost/~yann/DEV/tamara217/ressources/php/gestion/profiler/recup_profils.php",
			method: "POST",
			params: ["idUtilisateur":"1", "affichageDatas":false, "node":node.id],
			completionHandler: { (result) in
				switch result {
				case .Success(let data):
					//Permet de récupérer les datas sous la forme d'une chaine Json
					//let jsonString = String(data: data, encoding: .utf8)
					//print("data:", jsonString!)
					
					//Conversion des données sous la format d'un objet
					let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
					
					//print("JSON: ", json)
					
					
					for elementJson in json {
						
						//Suppression des balises html contenues dans le tootips
						var toolTip = (elementJson["qtip"] ?? "") as! String
						toolTip = toolTip.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<br/>", with: "\n")
						
						let element = Arborescence(
							id: elementJson["id"] as! String,
							pid: elementJson["pid"] as! String,
							nomProfil: "",
							text: elementJson["text"] as! String,
							qtip: toolTip  ,
							leaf: Bool((elementJson["leaf"] ?? false) as! Bool)
						)
						
						node.children.append(element)
					}
					
					
				case .Failure(let error):
					NSAlert(error: error).runModal()
				}
		}
		)
	}
	
}

