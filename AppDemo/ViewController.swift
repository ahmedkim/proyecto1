//
//  ViewController.swift
//  AppDemo
//
//  Created by STI on 05/12/16.
//  Copyright © 2016 Integra IT. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DetalleViewControllerDelegate, AgregarViewControllerDelegate {
    var rootRef : FIRDatabaseReference?
    
    var datos = [("Enrique", 31), ("Bulmaro", 28), ("Pedro", 18), ("Laura", 25), ("Lupita", 41), ("Sergio", 28), ("Sonia", 45), ("Luis", 28),
    ("Maria", 41), ("Sophie", 28), ("Ivan", 45), ("David", 28)]
    var filaseleccionada = -1
    var esEdicion = false
    @IBOutlet weak var tblTablas: UITableView!
    
//    var arreglo : [(nombre: String, edad: Int, genero: String, foto: String)] = []
    var arreglo : [Persona] = [Persona]()
    
    @IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    
    @IBAction func btnRefresh(_ sender: Any) {
        let idFacebook = FBSDKAccessToken.current().userID
        let cadenaUrl = "http://graph.facebook.com/\(idFacebook!)/picture?type=large"
        //let url = URL(string: "http://graph.facebook.com/\(idFacebook!)/picture?type=large")
        //let dato : Data?
        
        imgFoto.loadPicture(url: cadenaUrl)
        
        /*do{
            dato = try Data(contentsOf: url!)
            imgFoto.image = UIImage(data: dato!)
        } catch {
            print("Error cargando la imagen.! \(error.localizedDescription)")
            dato = nil
            imgFoto.image = UIImage(named: "Mr._Mime")
        }*/
        
        let valor = Int(lblNombre.text!)!
        rootRef?.child("Base").setValue(valor + 1)
        
        sincronizar()
    }
    
    @IBAction func btnAgregar_Click(_ sender: Any) {
        performSegue(withIdentifier: "Agregar Segue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Vista cargada")
        imgFoto.image = UIImage(named: "Mr._Mime")
        lblNombre.text = "Mr. Mime"
        rootRef = FIRDatabase.database().reference()
    
        arreglo = Persona.selectTodos()
        tblTablas.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.rootRef!.child("Base").observe(.value, with: { (snap: FIRDataSnapshot) in
//            print("dato: \(snap.value)")
            self.lblNombre.text = "\(snap.value!)"
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: DetalleView Delegates
    func numeroCambiado(numero: Int) {
        print("Numero cambiado: \(numero)")
        arreglo[numero].edad = arreglo[numero].edad + 1
        tblTablas.reloadData()
    }
    
    //MARK: - UIView Delegates
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "Detalle Segue":
            let view = segue.destination as! DetalleViewController
            
            view.numerofila = filaseleccionada
            view.dato = arreglo[filaseleccionada].nombre!
            view.datoNumero = Int(arreglo[filaseleccionada].edad)
            
            view.delegado = self
            break
        case "Agregar Segue":
            let view = segue.destination as! AgregarViewController
            
            if (esEdicion)
            {
                view.Fila = filaseleccionada
                view.Nombre = arreglo[filaseleccionada].nombre!
                view.Edad = Int(arreglo[filaseleccionada].edad)
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
        return arreglo.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let eliminar = UITableViewRowAction(style: .destructive, title: "Borrar", handler: BorrarFila)
        
        let editar = UITableViewRowAction(style: .normal, title: "Editar", handler: editarFila)
        
        return [eliminar, editar]
    }
    
    func BorrarFila(sender: UITableViewRowAction, indexPath: IndexPath)
    {
        //datos.remove(at: indexPath.row)
        //tblTablas.reloadData()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        context.delete(self.arreglo[indexPath.row])
        self.arreglo.remove(at: indexPath.row)
        self.tblTablas.deleteRows(at: [indexPath], with: .fade)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
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
        //let proto = (indexPath.row % 2 == 0) ? "proto2" : "proto1"
        let vista = tableView.dequeueReusableCell(withIdentifier: "proto1", for: indexPath) as! FilaTableViewCell
        
        let dato = arreglo[indexPath.row]
        
        dato.edad = Int16(indexPath.row)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        vista.lblIzquierda.text = "\(dato.edad)"
        vista.lblDerecha.text = "\(dato.nombre!)"
        
        if dato.genero == "m"{
            vista.imgFoto.image = UIImage(named: "user_male")
        } else {
            vista.imgFoto.image = UIImage(named: "user_female")
        }
        
//        if indexPath.row % 2 == 0{
//            vista.lblDerecha.text = "\(datos[indexPath.row].1)"
//            vista.lblIzquierda.text = datos[indexPath.row].0
//        }
//        else{
//            vista.lblIzquierda.text = "\(datos[indexPath.row].1)"
//            vista.lblDerecha.text = datos[indexPath.row].0
//        }
        
        //let idFacebook = FBSDKAccessToken.current().userID
        //let cadenaUrl = "http://graph.facebook.com/\(idFacebook!)/picture?type=large"
        //let url = URL(string: "http://graph.facebook.com/\(idFacebook!)/picture?type=large")
        //let dato : Data?
        
        vista.imgFoto.downloadData(url: arreglo[indexPath.row].foto!)
        
        /*do{
            dato = try Data(contentsOf: url!)
            vista.imgFoto.image = UIImage(data: dato!)
        } catch {
            print("Error cargando la imagen.! \(error.localizedDescription)")
            dato = nil
            vista.imgFoto.image = UIImage(named: "Mr._Mime")
        }*/
        
        
        
        return vista
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Detalle Segue
        filaseleccionada = indexPath.row
        performSegue(withIdentifier: "Detalle Segue", sender: self)
        
    }
    
    func sincronizar()
    {
        let url = URL(string: "http://kke.mx/demo/contactos2.php")
        
        var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 1000)
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            guard (error == nil) else {
                print("Ocurrrió un error con la petición  \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                print("Ocurrió un error con la respuesta.")
                return
            }
            
            if (!(statusCode >= 200 && statusCode <= 299))
            {
                print("Respuesta no válida.")
                return
            }
            
            let cad = String(data: data!, encoding: .utf8)
            print("Response: \(response!.description)")
            print("error: \(error)")
            print("data: \(cad)")
            
            var parsedResult: Any!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            } catch{
                parsedResult = nil
                print("error: \(error)")
                return
            }
            
            guard let datos = (parsedResult as? Dictionary<String, Any?>)?["datos"]
                as! [Dictionary<String, Any>]! else{
                    print("Error: \(error)")
                    return
            }
            
            self.arreglo.removeAll()
            
//            for d in datos{
//                let nombre = (d["nombre"] as! String)
//                let edad = (d["edad"] as! Int)
//                let foto = d["foto"] as! String
//                let genero = d["genero"] as! String
//                
//                self.arreglo.append((nombre: nombre, edad: edad, genero: genero, foto: foto))
//            }
            
            let (agregados, modificados, errores) = Persona.agregarTodos(datos: datos)
            
            print("Se agregaron \(agregados) registros")
            print("Se modificaron \(modificados) registros")
            print("Errores \(errores) registros")
            
            self.arreglo = Persona.selectTodos()
            
            print("Se leyeron \(self.arreglo.count) registros")
            
            self.tblTablas.reloadData()
        })
        
        task.resume()
        
    }
}

