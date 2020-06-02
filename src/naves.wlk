// Lookup Method (aka: El método lucap)
// Esto es lo que relaciona un envío de mensaje con el método real a ejecutarse
// 1. En un object, es fácil, está en el object.
// 2. Si es instancia de una clase, entonces ir a buscar el método a dicha clase.
// 3. Con herencia: Si no se encuentra un método que matchee con el mensaje, entonces buscar en la superclase
// - Repetir hasta llegar a Object.
// - Si no lo encuentra -> MessageNotUnderstandException


// Esta clase sirve para meter comportamiento común de todas las naves.
// No está pensada para crear instancias a partir de ella.
class Nave {
	var property velocidad = 0
	
	method acelerar(_velocidad) {
		velocidad = (velocidad + _velocidad).min(300000)
	}
	
	method propulsar() {
		self.acelerar(20000)
	}
	
	method prepararParaViajar() {
		self.acelerar(15000)
	}
	
	method encontrarEnemigo() {
		self.recibirAmenaza()
		self.propulsar()
	}
	
	method recibirAmenaza() // Método abstracto -> No tiene cuerpo
}

class NaveDeCarga inherits Nave {

	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	override method recibirAmenaza() {
		carga = 0
	}
	
	method enFalta() = self.sobrecargada() and self.excedidaDeVelocidad()
	
	method acercamientoDeControl() {
		if (self.enFalta()) {
			self.recibirAmenaza()
		}
	}
}

class NaveDeResiduosRadioactivos inherits NaveDeCarga {
	var property selladoAlVacio = false
	
	override method recibirAmenaza() {
		velocidad = 0
	}
	
	override method prepararParaViajar() {
		super()
		selladoAlVacio = true
	}
}

class NaveDePasajeros inherits Nave {
	
	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() {
		alarma = true
	}

}

// Herencia para heredar comportamiento y definir los pripios
class NaveDeCombate inherits Nave {
	// Composición (hay varios objetos involucrados)
	var property modo = reposo
	const property mensajesEmitidos = []

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}
	
	override method prepararParaViajar() {
		super()
		modo.sePreparaParaViajar(self)
	}
}

object reposo {

	method invisible() = false

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}
	
	method sePreparaParaViajar(nave) {
		nave.emitirMensaje("Saliendo en misión")
		nave.modo(ataque)
	}

}

object ataque {

	method invisible() = true

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
	}
	
	method sePreparaParaViajar(nave) {
		nave.emitirMensaje("Volviendo a la base")
	}

}

