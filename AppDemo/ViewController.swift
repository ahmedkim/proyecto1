//
//  ViewController.swift
//  AppDemo
//
//  Created by STI on 05/12/16.
//  Copyright © 2016 Integra IT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DetalleViewControllerDelegate {
    var datos = [("Enrique", 31), ("Bulmaro", 28)]
    var filaseleccionada = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Vista cargada")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: DetalleView Delegates
    func numeroCambiado(numero: Int) {
        print("Numero cambiado: \(numero)")
        datos[numero].1 = datos[numero].1 + 1
    }
    
    //MARK: - UIView Delegates
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let view = segue.destination as! DetalleViewController
        
        view.numerofila = filaseleccionada
        view.dato = datos[filaseleccionada].0
        view.datoNumero = datos[filaseleccionada].1
        
        view.delegado = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datos.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let proto = (indexPath.row % 2 == 0) ? "proto2" : "proto1"
        let vista = tableView.dequeueReusableCell(withIdentifier: proto, for: indexPath) as! FilaTableViewCell
        
        vista.lblIzquierda.text = "\(datos[indexPath.row].1)"
        vista.lblDerecha.text = datos[indexPath.row].0
        
//        if indexPath.row % 2 == 0{
//            vista.lblDerecha.text = "\(datos[indexPath.row].1)"
//            vista.lblIzquierda.text = datos[indexPath.row].0
//        }
//        else{
//            vista.lblIzquierda.text = "\(datos[indexPath.row].1)"
//            vista.lblDerecha.text = datos[indexPath.row].0
//        }
        
        
        
        return vista
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Detalle Segue
        filaseleccionada = indexPath.row
        performSegue(withIdentifier: "Detalle Segue", sender: self)
        
    }



}

