# Rappi

CAPAS DE LA APLICACIÓN: 
# VIEWS: ENCARGADA DE LAS VISTAS DE LA APP.
Assets: Carpeta que contiene todos los assests de la app(no contiene en este caso)
LaunchScreen.Storyboard: Se le llama cuando arranca la aplicación.
TableViewCell.xib: Es la celda creada que contiene los elementos para mostrarse. 
TableViewCell.swift Contiene los outlets de su xib.
Main.Storyboard: Contiene los controllers que fueron creados para manejar vistas y subsitas embebidos en un navigation Controller.

# CONTROLLERS: CONTIENE LOS VIEWCONTROLLERS.
MovieDetailViewController: Contiene toda la información y animaciones para mostrar la vista de detalle de la película.
MoviesTableViewController: Contiene la lógica de la tabla, que información debe mostrarse y los métodos para la búsqueda. 

# APIKEY: CONTIENE EL APIKEY TMDB

# CONNECTIONMANAGER:  CONTIENE LO RELACIONADO PARA CONECTARSE CON EL WEBSERVICE
APIManager.swift: Esta clase es una shared Instance para que se pueda acceder a ella desde cualquier parte del código y maneja la petición para hacer la petición al sever.

# RESOURCES:  ESTA CARPETA CONTIENE UN FOLDER CON UNA CARPETA QUE SE LLAMA FONTS QUE CONTIENE EL TIPO DE LETRA DE USADO EN LA APP

# UTILS:  CONTIENE ALGUNAS CLASES QUE AYUDAN A CREAR Y VALIDAR CIERTOS COMPORTAMIENTOS.
Reachability: Se encarga de saber el estado de la red.
Extensions: Contiene únicamente una extensión para descargar imágenes de la red. 
Tools: Una clase que ofece funciones compartidas para usarlas a conveniencia.

# MODELS
InfoModel.swift: Contiene el modelo de la información de la película.

# COREDATA: Cotiene todo lo relacionado con CoreData.
Model.xcdatamodeld: El modelo gráfico de la base de datos.
CoreDataStack.swift: Toda la configuración, métodos necesarios para persistir la info.


# EL PRINCIPIO DE RESPONSABILIDAD ÚNICA.
Basicamente consiste en que un objeto debe solamente realizar una sola cosa. 

