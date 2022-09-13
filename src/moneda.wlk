import wollok.game.*
import juego.*

class Moneda {

	var property position
	var property image = "coin.png"

	method chocar() {
		juego.obtenerMoneda()
		game.removeVisual(self)
		juego.visuals().remove(self)
	}

	method serAtacado(x) {
	}

	method esSuelo() = false

	method reiniciar() {
		if (!juego.visuals().contains(self)) {
			game.addVisual(self)
			juego.visuals().add(self)
		}
	}

}

const moneda0 = new Moneda(image = "coinPequenha.png", position = game.at(1, juego.tamanho() * (9 / 10) - 1))

const moneda1 = new Moneda(position = game.at(juego.tamanho() * (7 / 10), (3 / 5) * juego.tamanho() + 1))

const moneda2 = new Moneda(position = game.at(juego.tamanho() * (1 / 10), (7 / 10) * juego.tamanho() + 1))

const moneda3 = new Moneda(position = game.at(juego.tamanho() * (3 / 10), (2 / 5) * juego.tamanho() + 1))

const moneda4 = new Moneda(position = game.at(juego.tamanho() * (6 / 10), (2 / 5) * juego.tamanho() + 1))

const moneda5 = new Moneda(position = game.at(juego.tamanho() * (36 / 50), (1 / 5) * juego.tamanho() + 1))

