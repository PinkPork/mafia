//
//  Utils.swift
//  Algorithms
//
//  Created by Santiago Carmona gonzalez on 12/9/17.
//  Copyright © 2017 santicarmo31. All rights reserved.
//

import UIKit

struct Utils {
    // MARK: - UI
    
    /// Default navigation bar height value = **44.0**
    static let defaultNavigationBarHeight: CGFloat = 44.0
    
    /// Returns main UIScreen height
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// Returns main UIScreen width
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// Returns main UIScreen bounds
    static var screenBounds: CGRect {
        return UIScreen.main.bounds
    }
    
    /// Returns navigationBarHeight which by default is **44.0** plus the status bar frame height
    static var navigationBarheight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height + defaultNavigationBarHeight
    }
    
}

struct Segues {
    static let Menu = [
        ["Perfil", "app_menu_ico_perfil_", "_perfil"],
        //        ["Medios de pago", "app_menu_ico_medio_pago_", "_medio_pago"],
        //        ["Programar recogida", "app_menu_ico_programar_", "_prog_recog"],
        ["Historial", "app_menu_ico_historial_", "_hist"],
        ["Favoritos", "app_menu_ico_favorito_", "_fav"],
        //        ["Precios", "app_menu_ico_precio_", "_cost"],
        ["Compartir App", "app_menu_ico_com_app_", "_shar_app"],
        ["Calificar App", "app_menu_ico_calificar_", "_app_rate"],
        ["Sugerencias y quejas", "app_menu_ico_sugerencia_", "_sug_qu"],
        ["Terminos y condiciones", "app_menu_ico_terminos_", "_terms"],
        ["Acerca", "app_menu_ico_acerca_", "_about"],
        ["Cerrar sesión","ic_exit_to_app_"]]
}
