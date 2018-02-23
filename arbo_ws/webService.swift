//
//  ScheduleFetcher.swift
//  webService
//
//  Created by Yann SIVERT on 14/02/2018.
//  Copyright © 2018 Yann SIVERT. All rights reserved.
//


/*
	Classe permettrant d'appeler un webService et de renvoyer un résultat
	Documentation utilisée
		https://icodealot.com/sending-http-post-requests-to-ords-from-swift/
		https://stackoverflow.com/questions/41997641/how-to-make-nsurlsession-post-request-in-swift
		https://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method
		https://stackoverflow.com/questions/43779111/http-request-in-swift-with-post-method-in-swift3

	Cette classe est spécialisée dans l'appel aux webService PHP et charger la variable $_POST
		avec la création d'une chaine qui est envoyée via request.httpBody
	Sinon Avec un dictionary enovyé en JSON il faut utiliser ceci dans le code PHP pour que le $_POST contienne les données
		$_POST = json_decode(file_get_contents('php://input'), true);

	Coté swift
		let dicParams = ["cle1":"valeur1", "cle2":"valeur2", "cle3":"valeur3", "cle4":valeur4]
		let jsonParams = try? JSONSerialization.data(withJSONObject: dicParams, options: [])
		request.setValue("application/json", forHTTPHeaderField: "Accept")
		request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
		request.httpBody = jsonParams

 	Source
		https://stackoverflow.com/questions/18866571/receive-json-post-with-php/18867369#18867369
*/


import Foundation

class WebService {
	
	//l'enum sera concidérée comme un type imbriqué à la classe
	// Il sera facile de l'appeler comme [objetWebService].appel
	enum RequestResult {
		case Success(Data)
		case Failure(NSError)
	}
	
	let session: URLSession
	
	init() {
		let config = URLSessionConfiguration.default
		session = URLSession(configuration: config)
		//session = URLSession.shared
	}


	func request(url: String, method: String, params: Dictionary<String, Any>,completionHandler: @escaping (RequestResult) -> (Void)) {
		
		let url = URL(string: url)
		var request = URLRequest(url: url!)
		
		//Constitution de la chaine
		var chaineParams = ""
		for (cleParam, valeurParam) in params {
			if(chaineParams != ""){
				chaineParams+="&"
			}
			chaineParams+=cleParam+"="+String(describing: valeurParam)
		}

		request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
		request.httpMethod = method
		request.httpBody = chaineParams.data(using: String.Encoding.utf8)
		
		let task = session.dataTask(with: request, completionHandler: { data, response, error in
			var result: RequestResult
			
			if data == nil {
				result = .Failure(error! as NSError)
			}
			else if  let response = response as? HTTPURLResponse {
				if response.statusCode == 200 {
					result = .Success(data!)
				}
				else {
					let error = self.errorWithCode(code: 1, localizedDescription: "Bad status code \(response.statusCode)")
					result = .Failure(error)
				}
			}
			else {
				let error = self.errorWithCode(code: 1, localizedDescription: "Unexpected response")
				result = .Failure(error)
			}
			
			OperationQueue.main.addOperation({
				completionHandler(result)
			})
		})
		task.resume()
	}
	
	
	
	func errorWithCode(code: Int, localizedDescription: String) -> NSError {
		return NSError(domain: "WebService", code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
	}
}
