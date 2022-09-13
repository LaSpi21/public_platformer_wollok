import wollok.game.*
import player.*
import HUD.*
import juego.*

object espada {

	var property image = "sword11.png"
	var property position = game.at(juego.tamanho() * (41 / 50), (4 / 5) * juego.tamanho() + 1)

	method esSuelo() = false

	method chocar() {
		console.println("espada")
		game.removeVisual(self)
		juego.visuals().remove(self)
		game.addVisual(iconoEspada)
		juego.visuals().add(iconoEspada)
		player.tieneEspada(true)
		player.animIdle()
	}
	
	method reiniciar() {
		console.println("reiniciar espada")
		if (!juego.visuals().contains(self)) {
			
			game.addVisual(self)
			juego.visuals().add(self)
			
		}
		console.println("reinicio espada")
	}

}

object ataque {

	var property position = game.at(0, 0)
	var property image = "sword2.png"
	var property danho = 0

	method mover(direccion) {
		if (direccion) {
			position = position.left(1)
		} else {
			position = position.right(1)
		}
	}

	method chocar() {
	}

}

