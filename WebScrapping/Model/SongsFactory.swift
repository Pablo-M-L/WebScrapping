//
//  SongsFactory.swift
//  WebScrapping
//
//  Created by admin on 20/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

class SongsFactory {
    // crea array de objetos tipo Song
    var songs = [Song]()
    
    var songsUrl: String
    
    var completionSongs = 0
    
    var urlString: String = ""
    
    init(songsUrl: String) {
        self.songsUrl = songsUrl
        self.scrapeURL()
    }
    
    func scrapeURL(){
        //peticion a la url(lo hace ensegundo plano)
        Alamofire.request(songsUrl).responseString { response in
            
            if response.result.isSuccess{
                if let htmlString = response.result.value{
                    self.parseHTML(html: htmlString)
                }
            }
            else{
                print("fallo")
            }
        }
    }
    
    func parseHTML(html: String){
        
        do {
            let doc = try Kanna.HTML(html: html, encoding: String.Encoding.utf8)
            //el contador es solo para quitar los numeros que hay delante del titulo,
            //dependiendo de si tiene un digito, dos o tres como en 100
            var contador: Int = 1
            //variable para la subString
            var inicio: String.Index
            
            var title = ""
            var author = ""
            
            //filta por contenido con Kanna
            //recorre y selecciona los div con la propiedad class = section-content
            for div in doc.css("div"){
                if div["class"] == "section-content"{
                    //recorre las listas desordenadas dentro del div.
                    for ul in div.css("ul"){
                        //recorre e imprime el texto de las listas ordenas dentro del ul.
                        for li in ul.css("li"){
                            
                            contador += 1
                            
                            //titulo
                            for h3 in li.css("h3"){
                                title = h3.text!
                                break
                            }
                            
                            //autor
                            for h4 in li.css("h4"){
                                author = h4.text!
                                break
                            }
                            
                            /*
                             //quita los numeros del inicio del string, el inicio depende el numero que sea.
                             //quita el final del string
                             
                             //especificar iniciio
                             if contador > 99 {
                             inicio = liString.index(liString.startIndex, offsetBy: 4)}
                             else if contador > 9 {
                             inicio = liString.index(liString.startIndex, offsetBy: 3)}
                             else  {
                             inicio = liString.index(liString.startIndex, offsetBy: 2)}
                             
                             let final = liString.index(liString.endIndex, offsetBy: -14)
                             
                             //especificar final
                             let rango = inicio ..< final
                             
                             //otra forma de quitar el final que siempre es el mismo.
                             //title = li.text!.replacingOccurrences(of: "Buy Now on iTunes", with: "")
                             //pasamos el subString a un String
                             
                             title = String(liString[rango])
                             */
                            
                            //imagen, busca el enlace que hay en cada lista para alli pode obtener la imagen
                            for a in li.css("a"){
                                //obtiene el enlace a la cancion en ituns
                                if a["class"] == "more"{
                                    urlString = a["href"]!
                                    
                                    //print(urlString)
                                    //obtiene la imagen desde la pagina del enlace href
                                    //self.getImageFromUrl(urlName: urlString, forSong: Song.uuid)
                                    
                                }
                                
                            }
                            
                            //obtine la imagen desde la propia pagina
                            for a in li.css("a"){
                                for img in a.css("img"){
                                    let rutaSrcImageUrl = String(img["src"]!)
                                    let imageUrl = "https://www.apple.com\(rutaSrcImageUrl)"
                                    //print("https://www.apple.com\(imageUrl)")
                                    let song = Song(title: title, authorName: author ,iTunesUrl: urlString, imageUrl: imageUrl)
                                    song.downLoaded = true
                                    self.songs.append(song)
                                    
                                    //emite notificacion al actualizar la lista, para que el controllador
                                    //actualice las celdas del main.storyboard
                                    NotificationCenter.default.post(name: NSNotification.Name("SongsUpdate"), object: nil)
                                    //checkCompletionStatus()
                                }
                            }
                        }
                    }
                }
                
            }
            
            /*
             //filtra por expresion regular
             for li in doc.css("li"){
             // expresion regular
             let regex = "^[0-9]+\\.(\\w|\\s|W)+iTunes$"
             
             if li.text?.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil{
             print("---- \(li.text)")
             }
             }
             */
        } catch  {
            print(error)
        }
    }
    
    func checkCompletionStatus(){
        self.completionSongs += 1
        print("Estado de completacion: \(self.completionSongs) / \(self.songs.count)")
    }
    
    // busca la imagen en la pagina que abre al pulsar en la cancion
    func getImageFromUrl(urlName: String, forSong id: String){
        
        //peticion a la url(lo hace ensegundo plano)
        Alamofire.request(urlName).responseString { response in
            
            if response.result.isSuccess{
                if let htmlString = response.result.value{
                    self.parseImageHTML(htmlString: htmlString,forSong: id)
                }
            }
            
        }
        
    }
    
    func parseImageHTML(htmlString: String, forSong id: String ){
        do{
            let doc = try Kanna.HTML(html: htmlString, encoding: String.Encoding.utf8)
            
            let regexClass = "^we-artwork__image"
            let regexImg = "^(\\w|\\W)+\\/image\\/thumb\\/(\\w|\\W))+\\.jpe?g$"
            for img in doc.css("img"){
                
                if img["class"]?.range(of: regexClass, options: .regularExpression, range: nil, locale: nil) != nil{
                    if img["img"]?.range(of: regexImg, options: .regularExpression, range: nil, locale: nil) != nil{
                        
                        for song in self.songs{
                            if song.uuid == id{
                                //añade la url de la imagen en el objeto
                                song.imageUrl = img["src"]!
                                break
                            }
                        }
                    }
                }
                
            }
            
        }
        catch{
            print(error)
        }
    }
}
