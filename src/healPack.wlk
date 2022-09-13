
import wollok.game.*
import juego.*
import player.*

class HealPack{
	
	var property position
	var property image = "heal.png"
	
	method chocar(){
		player.subirSalud(1)
		game.removeVisual(self)
		juego.visuals().remove(self)
	}
	
	method serAtacado(x){}
	
	method esSuelo() = false
}