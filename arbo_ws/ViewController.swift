//
//  ViewController.swift
//  arbo_ws
//
//  Created by Yann SIVERT on 18/02/2018.
//  Copyright © 2018 Yann SIVERT. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {

	@IBOutlet var profilsTreeController: NSTreeController!

	@IBOutlet weak var profilsOutlineView: NSOutlineView!
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		
		let racine = Arborescence(id: "65535", pid: "", nomProfil: "", text: "Racine")
		/*let profil = Arborescence(id: "P333", pid: "65535", nomProfil: "Mon profil", text: "Mon Profil", leaf: true)
		racine.children = [profil]*/
		
		
		profilsTreeController.addObject(racine)
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

		//Si présence de plusieurs NSOutlineView on contrôle celle qui à déclenché le traitement
		switch outlineView {
		case profilsOutlineView:
			let node = (notification.userInfo!["NSObject"] as! NSTreeNode).representedObject as! Arborescence
			if node.children.count == 0{
				chargerProfils(node: node)
			}
			
		default: break
			//texteNode.stringValue = ""
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
			//idUtilisateur=1&affichageDatas=false&node=65535
			params: ["idUtilisateur":"1", "affichageDatas":false, "node":node.id],
			completionHandler: { (result) in
				switch result {
				case .Success(let data):
					//Permet de récupérer les datas sous la forme d'une chaine Json
					//let jsonString = String(data: data, encoding: .utf8)
					//print("data:", jsonString!)
					
					//Conversion des données sous la format d'un objet
					let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
					
					print("JSON: ", json)
					
					
					for elementJson in json {
						
						let element = Arborescence(
							id: elementJson["id"] as! String,
							pid: elementJson["pid"] as! String,
							nomProfil: "",
							text: elementJson["text"] as! String,
							leaf: Bool((elementJson["leaf"] ?? false) as! Bool)
						)
						
						node.children.append(element)
					}
					
					
				case .Failure(let error):
					NSAlert(error: error).runModal()
				}
			}
		)
		print("AAAAAA")
		
	}
}

