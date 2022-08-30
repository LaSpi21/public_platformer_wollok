import wollok.game.*

const velocidad = 250

object juego {

	const objetos = [ suelo, vida, player, reloj, espada, slime]

	method configurar() {
		game.width(105)
		game.height(70)
		game.cellSize(5)
		game.title("platformero")
		objetos.forEach({ unObjeto => game.addVisual(unObjeto)})
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
		game.onCollideDo(player, { obstaculo => obstaculo.chocar()})
	// game.onCollideDo(espada, { obstaculo => obstaculo.obtenerEspada()})
	}

	method iniciar() {
		player.iniciar()
		reloj.iniciar()
		vida.iniciar()
		slime.iniciar()
	}

	method saltar() {
		if (player.estaVivo()) player.saltar() else {
		}
	}

	method reiniciar() {
		if (!player.estaVivo()) {
			game.removeVisual(gameOver)
			self.iniciar()
		} else {
		}
	}

	method caminar(direccion) {
		if (player.estaVivo()) player.caminar(direccion) else {
		}
	}

	method terminar() {
		game.addVisual(gameOver)
		reloj.detener()
		player.morir()
	}

}

object gameOver {

	method position() = game.center()

	method text() = "GAME OVER"

}

object vida {

	const imagenes = [ "hearts0.png", "hearts1.png", "hearts2.png", "hearts3.png", "hearts4.png", "hearts5.png", "hearts6.png" ]

	method image() {
		return imagenes.get(player.salud())
	}

	method position() = game.at(5, game.height() - 8)

	method iniciar() {
		player.todaLaVida()
	}

}

object reloj {

	var tiempo = 100

	method text() = tiempo.toString()

	method position() = game.at(50, game.height() - 10)

	method pasarTiempo() {
		tiempo = tiempo - 1
	}

	method iniciar() {
		tiempo = 100
		game.onTick(1000, "tiempo", { self.pasarTiempo()})
	}

	method detener() {
		game.removeTickEvent("tiempo")
	}

	method reinciar() {
		game.onTick(1000, "tiempo", { self.pasarTiempo()})
	}

}

object suelo {


	method position() = game.origin().up(1)

	method image() = "suelo.png"
	
	method chocar(){}

}

object espada {

	var property image = "sword11.png"
	var property position = game.at(30, 1)

	method chocar() {
		console.println("espada")
		game.removeVisual(self)
		game.addVisual(iconoEspada)
		player.espada(true)
		player.animIdle()
	}

}

object iconoEspada {

	var property image = "sword.png"
	var property position = game.at(5, game.height() - 12)

}

object player {

	var vivo = true
	var property salud = 6
	// var position = game.at(1, suelo.position().y())
	var position = game.at(1, 20)
	var property anim_time = 125
	var property image = 0
	var property mov = false
	var property saltando = false
	var property atacando = false
	var property ataque1 = false
	var property ataque2 = false
	var cayendo = false
	var property espada = false
	var property att_combo = false
	var armadura = 1
	
	// ANIMACIONES
	const salto_right = [ "tile069.png", "tile070.png", "tile071.png" ]
	const salto_left = [ "tile069i.png", "tile070i.png", "tile071i.png" ]
	const muere_right = [ "tile065.png", "tile066.png", "tile067.png", "tile068.png" ]
	const muere_left = [ "tile065i.png", "tile066i.png", "tile067i.png", "tile068i.png" ]
	const att1_right = [ "tile042.png", "tile043.png", "tile044.png", "tile045.png", "tile046.png", "tile047.png", "tile047.png" ]
	const att1_left = [ "tile042i.png", "tile043i.png", "tile044i.png", "tile045i.png", "tile046i.png", "tile047i.png", "tile047i.png" ]
	const att2_right = [ "tile047.png", "tile048.png", "tile049.png", "tile050.png", "tile051.png", "tile052.png", "tile052.png" ]
	const att2_left = [ "tile047i.png", "tile048i.png", "tile049i.png", "tile050i.png", "tile051i.png", "tile052i.png", "tile052i.png" ]
	const att3_right = [ "tile053.png", "tile054.png", "tile055.png", "tile056.png", "tile057.png", "tile058.png", "tile058.png" ]
	const att3_left = [ "tile053i.png", "tile054i.png", "tile055i.png", "tile056i.png", "tile057i.png", "tile058i.png", "tile058i.png" ]

	
	const idle_right = [ "tile000.png", "tile001.png", "tile002.png", "tile003.png" ]
	const idle_left = [ "tile000i.png", "tile001i.png", "tile002i.png", "tile003i.png" ]
	const idle_espada_right = [ "tile038.png", "tile039.png", "tile040.png", "tile041.png" ]
	const idle_espada_left = [ "tile038i.png", "tile039i.png", "tile040i.png", "tile041i.png" ]
	const walk_right = [ "tile008.png", "tile009.png", "tile010.png", "tile011.png", "tile012.png", "tile013.png" ]
	const walk_left = [ "tile008i.png", "tile009i.png", "tile010i.png", "tile011i.png", "tile012i.png", "tile013i.png" ]
	const caida_right = ["tile022.png", "tile023.png"]
	const caida_left = ["tile022i.png", "tile023i.png"]

	var miraDerecha = true
	
	
	// SELECTOR DE LA ANIMACION ACTUAL
	var property sprites = idle_right

	method position() = position

	method todaLaVida() {
		self.salud(6)
	}

	method image() {
		return sprites.get(image)
	}

	method aplicarAnimate() {
		game.onTick(anim_time, "anima", { self.Animate()})
	}

	method cambiarAnimate(sprite_nuevo, anim_time_nuevo) {
		game.removeTickEvent("anima")
		self.image(0)
		self.sprites(sprite_nuevo)
		anim_time = anim_time_nuevo
		self.aplicarAnimate()
	}

	method Animate() {
		if (image < sprites.size() - 1) {
			image += 1
		} else {
			image = 0
		}
	}

	method grounded() = position.y() == suelo.position().y()

	method saltar() {
		if (self.grounded()) {
			console.println("saltando")
			saltando = true
			self.animSaltar(miraDerecha)
			self.subir()
			4.times({ i => game.schedule(125 * (i / 2), { self.subir()})})
			game.schedule(375, { self.saltando(false)})
		}
	}

	method subirSalud(x) {
		salud = (salud + x).min(6)
	}

	method bajarSalud(x) {
		salud = (salud - x).max(0)
		if (salud == 0) {
			self.morir()
		}
	}

	method subir() {
		position = position.up(2)
	}

	method subir(x) {
	} // METODO SUBIR ALTERNATIVO PARA ARMAR DESPUES CON (1..x) para hacer subir de distitntos altos

	method caer() {
		if (!self.grounded() and !saltando) {
			if (!cayendo) {
				self.animCaer(miraDerecha)
			}
			cayendo = true
			position = position.down(1)
		}
		if (self.grounded() and cayendo) {
			cayendo = false
			self.animIdle()
		}
	}

	method animIdle() {
		mov = false
		if (!atacando) {
			if (espada) {
				if (miraDerecha) { // TODO
					self.cambiarAnimate(idle_espada_right, 150)
				} else {
					self.cambiarAnimate(idle_espada_left, 150)
				}
			} else {
				if (miraDerecha) { // TODO
					self.cambiarAnimate(idle_right, 150)
				} else {
					self.cambiarAnimate(idle_left, 150)
				}
			}
		}
	}

	method caminar(direccion) {
		if (self.grounded() and !mov) {
			self.animCaminar(direccion)
			mov = true
			self.mover(direccion)
			9.times({ i => game.schedule(500 * (i / 9), { self.mover(direccion)})}) // TODO 18 hace que se buggeeee todo
			game.schedule(500, { self.animIdle()})
		} else if (!mov) {
			mov = true
			self.animCaer(direccion)
			self.mover(direccion)
			9.times({ i => game.schedule(500 * (i / 9), { self.mover(direccion)})})
			game.schedule(500, { self.mov(false)})
		}
	}

	method animCaminar(direccion) {
		if (direccion) { // TODO
			self.cambiarAnimate(walk_right, 75)
			miraDerecha = true
		} else {
			self.cambiarAnimate(walk_left, 75)
			miraDerecha = false
		}
	}

	method animAtacar1() {
		if (miraDerecha) {
			self.cambiarAnimate(att1_right, 75)
		} else {
			self.cambiarAnimate(att1_left, 75)
		}
	}

	method animAtacar2() {
		if (miraDerecha) {
			self.cambiarAnimate(att2_right, 75)
		} else {
			self.cambiarAnimate(att2_left, 75)
		}
	}
	
	method animAtacar3() {
		if (miraDerecha) {
			self.cambiarAnimate(att3_right, 75)
		} else {
			self.cambiarAnimate(att3_left, 75)
		}
	}
	
	method atacando(bool){
		if (!att_combo){
		atacando = bool
		}
		}
	

	method atacar1() {
		if (self.grounded() and espada and !atacando) {
			console.println("att1")
			mov = true
			atacando = true
			self.animAtacar1() // A esta funcion le falta la parte donde invoca el objeto ataque...
			2.times({ i => game.schedule(350 * (i / 2), { self.mover(miraDerecha)})})
			game.schedule(300, { self.ataque1(true)})
			game.schedule(600, { self.mov(false)})
			game.schedule(575, { self.atacando(false)}) // NECESITO PODER ABORTAR ESTO PARA QUE FUNCIONE!!
			game.schedule(575, { self.ataque1(false)})
			game.schedule(600, { self.animIdle()}) // NECESITO PODER ABORTAR ESTO PARA QUE FUNCIONE!!
			
		}
	/*	//ESTO NO VIENE FUNCIONANDO BIEN..
	 * else if (espada){
	 * 	console.println("att_aire")
	 * 	mov = true
	 * 	self.animAtacar()
	 * 	game.schedule(450, { self.mov(false)})
	 * 	game.schedule(450, { self.animIdle()})
	 * 	}
	 */
	}

	method atacar2() {
		if (ataque1) {
			console.println("att2")
			mov = true
			atacando = true
			att_combo = true
			self.animAtacar2() // A esta funcion le falta la parte donde invoca el objeto ataque...
			2.times({ i => game.schedule(350 * (i / 2), { self.mover(miraDerecha)})})
			
			game.schedule(350, { self.ataque2(true)})
			game.schedule(600, { self.mov(false)})
			game.schedule(575, { self.atacando(false)}) // NECESITO PODER ABORTAR ESTO PARA QUE FUNCIONE!!
			game.schedule(575, { self.ataque2(false)})
			game.schedule(325, { self.att_combo(false)})
			game.schedule(600, { self.animIdle()})
		}
	}


	method atacar3() {
		if (ataque2) {
			console.println("att3")
			mov = true
			atacando = true
			att_combo = true
			self.animAtacar3() // A esta funcion le falta la parte donde invoca el objeto ataque...
			2.times({ i => game.schedule(350 * (i / 2), { self.mover(miraDerecha)})})
			game.schedule(600, { self.mov(false)})
			game.schedule(400, { self.att_combo(false)})
			game.schedule(575, { self.atacando(false)})
			game.schedule(600, { self.animIdle()})
		}
	}

	method animSaltar(direccion) {
		if (direccion) { // TODO
			self.cambiarAnimate(salto_right, 75)
			miraDerecha = true
		} else {
			self.cambiarAnimate(salto_left, 75)
			miraDerecha = false
		}
	}
	
	method animCaer(direccion) {
		if (direccion) { // TODO
			self.cambiarAnimate(caida_right, 75)
			miraDerecha = true
		} else {
			self.cambiarAnimate(caida_left, 75)
			miraDerecha = false
		}
	}
	

	method mover(direccion) {
		if (direccion) { // TODO
			position = position.right(1)
		} else {
			position = position.left(1)
		}
	}

	method morir() {
		game.removeTickEvent("anima")
		game.removeTickEvent("gravity")
		game.say(self, "¡Auch!")
		vivo = false
	}

	method iniciar() {
		sprites = idle_right
		game.onTick(125 / 4, "gravity", { self.caer()})
		self.aplicarAnimate()
		vivo = true
	}

	method estaVivo() {
		return vivo
	}

	method mostrarPosicion() {
		console.println(self.position())
	}

/* 
 * method obtenerEspada(){
 * 	console.println("espada")
 * 	game.removeVisual(espada)
 * 	game.addVisual(iconoEspada)
 * 	espada = true
 * }
 */
}


object slime{
	
	const slime_mov = ["slime (1).png", "slime (2).png", "slime (3).png", "slime (4).png", "slime (5).png", "slime (6).png", "slime (7).png", "slime (8).png", "slime (9).png", "slime (10).png"]
	var property sprites = slime_mov
	var image = 0
	var anim_time = 100
	var property position = self.posicionInicial()
	var direccion = true
	
	method image() {
		return sprites.get(image)
	}
	
	method posicionInicial() = game.at(40, 0)

	method Animate() {
		if (image < sprites.size() - 1) {
			image += 1
		} else {
			image = 0
		}
	}
	
	method aplicarAnimate() {
		game.onTick(anim_time, "slime_anima", { self.Animate()})
	}
	
	method iniciar() {
		sprites = slime_mov
		game.onTick(200,"moverSlime",{self.mover()})
		//game.onTick(125 / 4, "gravity", { self.caer()})
		self.aplicarAnimate()
			}
	
	method mover(){
		if (direccion){
		position = position.left(1)}
		else{
			position = position.right(1)
		}
		if (position.x() <= 20){
			direccion = false
		}
		else if (position.x() >= 60){
			direccion = true
		}
			
	}
	

		
		
	
}
