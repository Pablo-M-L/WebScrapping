//
//  Song.swift
//  WebScrapping
//
//  Created by admin on 20/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class Song{
    
    var title: String
    var authorName: String
    var iTunesUrl: String
    var imageUrl: String
    var uuid: String
    var downLoaded = false
    
    /*
    //constructor en el caso de usar el filtrado por expresion regular buscando en el enlace de la cancion.
    init(title: String, authorName: String, iTunesUrl: String) {
        self.uuid = UUID().uuidString// crea un identificador unico a cada objeto que crea
        self.title = title
        self.authorName = authorName
        self.iTunesUrl = iTunesUrl
        self.imageUrl = "renlace recurso por defecto"
    }
    */

    //el enlace del imageUrl seria la imagen por defecto, con esto se evita el primer iniciador sin imageUrl
init(title: String, authorName: String, iTunesUrl: String, imageUrl: String = "https://www.apple.com/autopush/us/itunes/charts/songs/images/2018/8/a0148f4996589b831bc7d0bbbdbcdac946fb4ca4e6642566e0a69fe126e9492c.jpg"){
    
    self.uuid = UUID().uuidString// crea un identificador unico a cada objeto que crea
    self.title = title
    self.authorName = authorName
    self.iTunesUrl = iTunesUrl
    self.imageUrl = imageUrl
}

}
