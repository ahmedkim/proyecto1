//
//  ViewController.swift
//  AppDemo
//
//  Created by STI on 05/12/16.
//  Copyright © 2016 Integra IT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DetalleViewControllerDelegate, AgregarViewControllerDelegate {
    var datos = [("Enrique", 31), ("Bulmaro", 28)]
    var filaseleccionada = -1
    var esEdicion = false
    @IBOutlet weak var tblTablas: UITableView!
    
    
    @IBAction func btnAgregar_Click(_ sender: Any) {
        performSegue(withIdentifier: "Agregar Segue", sender: self)
    }
    
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
        tblTablas.reloadData()
    }
    
    //MARK: - UIView Delegates
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "Detalle Segue":
            let view = segue.destination as! DetalleViewController
            
            view.numerofila = filaseleccionada
            view.dato = datos[filaseleccionada].0
            view.datoNumero = datos[filaseleccionada].1
            
            view.delegado = self
            break
        case "Agregar Segue":
            let view = segue.destination as! AgregarViewController
            
            if (esEdicion)
            {
                view.Fila = filaseleccionada
                view.Nombre = datos[filaseleccionada].0
                view.Edad = datos[filaseleccionada].1
                esEdicion = false
            }
            
            view.delegado = self
            break
            
        default:
            break
        }
        
    }
    
    //MARK: - Agregar Delegates
    func agregarRegistro(nombre: String, edad: Int){
        datos.append(nombre, edad)
        tblTablas.reloadData()
    }
    
    func modificarRegistro(nombre: String, edad: Int, fila: Int){
        datos[fila].0 = nombre
        datos[fila].1 = edad
        tblTablas.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datos.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let eliminar = UITableViewRowAction(style: .destructive, title: "Borrar", handler: BorrarFila)
        
        let editar = UITableViewRowAction(style: .normal, title: "Editar", handler: editarFila)
        
        return [eliminar, editar]
    }
    
    func BorrarFila(sender: UITableViewRowAction, indexPath: IndexPath)
    {
        datos.remove(at: indexPath.row)
        tblTablas.reloadData()
    }
    
    func editarFila(sender: UITableViewRowAction, indexPath: IndexPath)
    {
        esEdicion = true
        filaseleccionada = indexPath.row
        performSegue(withIdentifier: "Agregar Segue", sender: sender)
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

