//
//  Extensions.swift
//  WebScrapping
//
//  Created by admin on 20/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension UIImageView{
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit){
        guard let url = URL(string: link) else {
            return
        }
        downloadedFrom(url: url)
    }
    
    //descarga el fichero con url session
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit){
        //data es para los datos de descarga (la imagen), el response es el codigo de respuesta y el codigo de error. los 3 son optionals.
        URLSession.shared.dataTask(with: url){
            (data, response, error) in
            guard
                // comprueba si el codigo de respuesta es correcto (200)
                let httpUrlResponse = response as? HTTPURLResponse,
                    httpUrlResponse.statusCode == 200,
                // comprueba el tipo de datos es una imagen.
                let mimeType = response?.mimeType,
                    mimeType.hasPrefix("image"),
                // si llegamos hasta aqui es que esta todo bien, e igualamos data a data
                // para convertir un dato opcional en obligatorio. y damos a error el valor de nulo
                // porque no hay errores.
                let data = data, error == nil,
                let image = UIImage(data: data)
                else{
                    // si no se cumplen todas las variables anteriores retorna.
                    return }
            
            // congelamos la aplicacion de image para ejecutarla en segundo plano.
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
}
