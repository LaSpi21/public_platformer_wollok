import wollok.game.*
import player.*
import HUD.*
import espada.*
import slime.*
import plataformas.* 
import moneda.*
import teletransportadores.*
import puerta.*

object juego {

	const property tamanho = 40
	const objetos = [ vida, reloj, espada, slime1, slime2, slime3, monedaHUD, moneda1, moneda2, moneda3, moneda4, moneda5, tp1, r1, tp2, r2, tp3, r3, tp4, r4, ataque, contadorMonedas, puerta, player]
	const animables = [player, reloj, vida, slime1, slime2, slime3, iconoEspada] 
	const reInstanciables = [slime1, slime2, slime3, moneda1, moneda2, moneda3, moneda4, moneda5, espada]
	const property tickEvents = []
	const property visuals = []
	var property monedas = 0
	
	var property dropCoin = [true, false, false]
	
	method configurar() {
		game.width(tamanho)
		game.height(tamanho)
		game.cellSize(12)
		game.title("platformero")
		objetos.forEach({ unObjeto => game.addVisual(unObjeto)})
		objetos.forEach({ unObjeto => visuals.add(unObjeto)})
		keyboard.space().onPressDo{ self.saltar()}
		keyboard.right().onPressDo{ self.caminar(true)}
		keyboard.left().onPressDo{ self.caminar(false)}
		keyboard.r().onPressDo{ self.reiniciar()}
		keyboard.q().onPressDo{ player.atacar1()}
		keyboard.w().onPressDo{ player.atacar2()}
		keyboard.e().onPressDo{ player.atacar3()}
		keyboard.p().onPressDo{ player.mostrarPosicion()} // MOTIVOS DE PRUEBAS
		keyboard.k().onPressDo{ player.bajarSalud(1)} // MOTIVOS DE PRUEBAS
		keyboard.l().onPressDo{ player.subirSalud(1)} // MOTIVOS DE PRUEBAS
		keyboard.x().onPressDo{ console.println(tickEvents)} // MOTIVOS DE PRUEBAS
		keyboard.c().onPressDo{ console.println(visuals)} // MOTIVOS DE PRUEBAS
	}

	method obtenerMoneda(){
		monedas += 1
		if (monedas == 6){
			puerta.abrirPuerta()
		}
	}
	
	method ganar(){
		game.say(player, "Yo ya gané")
	}
	
	method iniciar() {
		animables.forEach({ unObjeto => unObjeto.iniciar()})
	}

	method colisiones() {
		player.hitbox().forEach({ x => game.onCollideDo(x, { obstaculo => obstaculo.chocar()})})
		game.onCollideDo(ataque, { obstaculo => obstaculo.serAtacado(ataque.danho())})
	}

	method saltar() {
		if (player.estaVivo()) player.saltar() else {
		}
	}


	
	
	method reiniciar() {
		if (tickEvents.size() > 0) {
			self.terminar()
		}
		monedas = 0
		dropCoin = [true, false, false]
		puerta.cerrarPuerta()
		self.iniciar()
	}

	method caminar(direccion) {
		if (player.estaVivo()) player.caminar(direccion) else {
		}
	}

	method terminar() {
		//game.addVisual(gameOver)
		animables.forEach({ unObjeto => self.detener(unObjeto)})
		reInstanciables.forEach({ unObjeto => unObjeto.reiniciar()})
		
	}
	
	method detener(objeto){
		if (visuals.contains(objeto)){
			objeto.detener()
		}
	}


}