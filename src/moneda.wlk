import wollok.game.*
import juego.*
import obtenibles.*

class Moneda inherits Obtenibles{

	override method image() = "coin.png"

	override method chocar() {
		juego.obtenerMoneda()
		super()
	}

	method reiniciar() {
		if (!juego.visuals().contains(self)) {
			game.addVisual(self)
			juego.visuals().add(self)
		}
	}

}



const moneda1 = new Moneda(position = game.at(juego.tamanho() * (7 / 10), (3 / 5) * juego.tamanho() + 1))

const moneda2 = new Moneda(position = game.at(juego.tamanho() * (1 / 10), (7 / 10) * juego.tamanho() + 1))

const moneda3 = new Moneda(position = game.at(juego.tamanho() * (3 / 10), (2 / 5) * juego.tamanho() + 1))

const moneda4 = new Moneda(position = game.at(juego.tamanho() * (6 / 10), (2 / 5) * juego.tamanho() + 1))

const moneda5 = new Moneda(position = game.at(juego.tamanho() * (36 / 50), (1 / 5) * juego.tamanho() + 1))

