import wollok.game.*
import teletransportadores.*

const velocidad = 250

object juego {


    
    const property tamanho = 40
    
	const objetos = [ vida, player, reloj, espada, slime]

	method configurar() {
		game.width(tamanho)
		game.height(tamanho)
		game.cellSize(12)
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
		//keyboard.x().onPressDo{ player.grounded2()} // MOTIVOS DE PRUEBAS
		

	}

	method iniciar() {
		player.iniciar()
		reloj.iniciar()
		vida.iniciar()
		slime.iniciar()
		
	}
	
	
	method colisiones(){
		player.hitbox().forEach({x => game.onCollideDo(x, { obstaculo => obstaculo.chocar()})})
		
	}

	method saltar() {
		if (player.estaVivo()) player.saltar() else {
		}
	}

	method reiniciar() {

			self.iniciar()}  //esto deberia cerrar todo antes de iniciar de nuevo


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

	method position() = game.at(1, juego.tamanho()*(9/10))

	method iniciar() {
		player.todaLaVida()
	}

}

object reloj {
	var property segundo = 500
	var tiempo = 100

	method text() = tiempo.roundUp().toString()

	method position() = game.at(juego.tamanho()/2, game.height() - juego.tamanho()/10)

	method pasarTiempo() {
		tiempo = tiempo - segundo/3000
		player.caer()
		//game.onTick(250 / 3, "gravity", { self.caer()})
	}

	method iniciar() {
		tiempo = 100
		
		game.onTick(segundo / 3, "tiempo", { self.pasarTiempo()})
	}

	method detener() {
		game.removeTickEvent("tiempo")
	}

	method reinciar() {
		game.onTick(1000, "tiempo", { self.pasarTiempo()})
	}

}


object espada {

	var property image = "sword11.png"
	var property position = game.at(20, (2/5)*juego.tamanho()+3)

	method esSuelo() = false
	
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
	var property position = game.at(1, juego.tamanho()*(9/10)-2)

}

object player {

	var vivo = true
	var property salud = 6
	// var position = game.at(1, suelo.position().y())
	var property position = self.posicionInicial()
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
	const property hitbox = []
	var property vulnerable = true
	
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

	method posicionInicial() = game.at(juego.tamanho()-5, (2/5)*juego.tamanho()+3)
	
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


	method grounded() {
		if (self.position().y() == -4){
			self.transportar(self.posicionInicial())
			self.bajarSalud(1)
		}
		
		const objAbajo = game.getObjectsIn(game.at(self.position().x()+4, self.position().y()-1))
		if (objAbajo.size() > 0){
		return objAbajo.get(0).esSuelo()
		}
		else{
			return false
		}
		
	}
	
	//console.println(game.getObjectsIn(game.at(self.position().x(), self.position().y()-1)).get(0).esSuelo())
		//return game.getObjectsIn(game.at(self.position().x(), self.position().y()-1))}
	// game.getObjectsIn(game.at(self.position().x(), self.position().y()-1)).esSuelo()

	method saltar() {
		if (self.grounded()) {
			console.println("saltando")
			saltando = true
			self.animSaltar(miraDerecha)
			self.subir()
			2.times({ i => game.schedule(250 * i/3, { self.subir()})})
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
		position = position.up(1)
		hitbox.forEach({unHitbox => unHitbox.position(unHitbox.position().up(1))})
	}


	method caer() {
		if (!self.grounded() and !saltando) {
			if (!cayendo) {
				self.animCaer(miraDerecha)
			}
			cayendo = true
			position = position.down(1)
			hitbox.forEach({unHitbox => unHitbox.position(unHitbox.position().down(1))})
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
			(juego.tamanho()/10).times({ i => game.schedule(500 * (i / 7), { self.mover(direccion)})}) // TODO 18 hace que se buggeeee todo
			game.schedule(500, { self.animIdle()})
		} else if (!mov) {
			mov = true
			self.animCaer(direccion)
			self.mover(direccion)
			(juego.tamanho()/10).times({ i => game.schedule(500 * (i / 7), { self.mover(direccion)})})
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
			//2.times({ i => game.schedule(350 * (i / 2), { self.mover(miraDerecha)})})
			game.schedule(300, { self.ataque1(true)})
			game.schedule(600, { self.mov(false)})
			game.schedule(550, { self.atacando(false)}) // NECESITO PODER ABORTAR ESTO PARA QUE FUNCIONE!!
			game.schedule(575, { self.ataque1(false)})
			game.schedule(600, { self.animIdle()}) // NECESITO PODER ABORTAR ESTO PARA QUE FUNCIONE!!
			
		}
}

	method atacar2() {
		if (ataque1) {
			console.println("att2")
			mov = true
			ataque1 = false
			atacando = true
			att_combo = true
			self.animAtacar2() // A esta funcion le falta la parte donde invoca el objeto ataque...
			1.times({ i => game.schedule(350 * (i / 2), { self.mover(miraDerecha)})})
			
			game.schedule(350, { self.ataque2(true)})
			game.schedule(600, { self.mov(false)})
			game.schedule(550, { self.atacando(false)}) // NECESITO PODER ABORTAR ESTO PARA QUE FUNCIONE!!
			game.schedule(575, { self.ataque2(false)})
			game.schedule(325, { self.att_combo(false)})
			game.schedule(600, { self.animIdle()})
		}
	}


	method atacar3() {
		if (ataque2) {
			console.println("att3")
			mov = true
			ataque2 = false //sacar si se quiere un combo mas buggeado pero copado
			atacando = true
			att_combo = true
			self.animAtacar3() // A esta funcion le falta la parte donde invoca el objeto ataque...
			//2.times({ i => game.schedule(150 * (i / 2), { self.mover(miraDerecha)})})
			8.times({ i => game.schedule(150 + 200 * (i / 10), { self.mover(miraDerecha)})})
			game.schedule(550, { self.mov(false)})
			game.schedule(400, { self.att_combo(false)})
			game.schedule(550, { self.atacando(false)})
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
	
	method transportar(pos){
		const diffX = pos.x() - position.x()
		const diffY = pos.y() - position.y()
		hitbox.forEach({unHitbox => unHitbox.position(unHitbox.position().right(diffX).up(diffY))})
		position = pos
		
	}

	method mover(direccion) {
		if (direccion) { // TODO
			position = position.right(1)
			hitbox.forEach({unHitbox => unHitbox.position(unHitbox.position().right(1))})
		} else {
			position = position.left(1)
			hitbox.forEach({unHitbox => unHitbox.position(unHitbox.position().left(1))})
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
		//game.onTick(250 / 3, "gravity", { self.caer()})
		
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
	var property position = game.at(25, (2/5)*juego.tamanho()+3)
	var direccion = true
	
	
	method image() {
		return sprites.get(image)
	}
	
	method esSuelo() = false

	method chocar_deprecated(){
		
		
		if (player.vulnerable()){
			player.vulnerable(false)
			player.mov(true)
			4.times({ i => game.schedule(45 * (1.6**i), { player.mover(!direccion)})})
			game.schedule(300, {player.vulnerable(true)})
			game.schedule(300, {player.mov(false)})

		
		player.bajarSalud(2)}
	}
	
	method chocar(){
		player.transportar(player.posicionInicial())
		//player.bajarSalud(2)
		game.say(player, ["¡Auch!", "Otra vez al comienzo..", "ouch...", "aaAaH!!!"].anyOne())
	}
	
	
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
		if (position.x() <= 15){
			direccion = false
		}
		else if (position.x() >= 35){
			direccion = true
		}
			
	}

	
}


class Plataforma {
	
	var property position
	
	
	method esSuelo() = true
	method image() = "muro12.png"
	method chocar(){}
}


object nivel1 {

	method cargar() {
//	PAREDES
		const ancho = game.width()
		const alto = game.height()
		const posParedes = []
		(1 .. ancho*(2/15)).forEach{ n => posParedes.add(new Position(x = n, y = 0))}
		(ancho*(41/50) .. ancho-2).forEach{ n => posParedes.add(new Position(x = n, y = 0))} 
		(ancho*(1/10) .. ancho-1).forEach{ n => posParedes.add(new Position(x = n, y = (2/5)*alto+2))} 
		(ancho*(5/10) .. ancho-1).forEach{ n => posParedes.add(new Position(x = n, y = (3/5)*alto+3))} 
		(0 .. ancho*(3/10)).forEach{ n => posParedes.add(new Position(x = n, y = (7/10)*alto))} 
		(ancho*(2/10) .. ancho*(17/50)).forEach{ n => posParedes.add(new Position(x = n, y = (1/5)*alto+1))} 
		(ancho*(22/50) .. ancho*(5/10)).forEach{ n => posParedes.add(new Position(x = n, y = (1/5)*alto+1))} 
		(ancho*(33/50) .. ancho*(37/50)).forEach{ n => posParedes.add(new Position(x = n, y = (1/5)*alto+1))} 
		(ancho*(34/50) .. ancho+2).forEach{ n => posParedes.add(new Position(x = n, y = (4/5)*alto+4))} 
		//(0 .. largo).forEach{ n => posParedes.add(new Position(x = 0, y = n))} // bordeIzq 
		//(0 .. largo).forEach{ n => posParedes.add(new Position(x = ancho, y = n))} // bordeDer
			// posParedes.addAll([new Position(x=3,y=5), new Position(x=4,y=5), new Position(x=5,y=5)])
			// posParedes.addAll([new Position(x=1,y=2), new Position(x=2,y=2),new Position(x=6,y=2), new Position(x=7,y=2)])
			// posParedes.addAll([new Position(x=1,y=1), new Position(x=2,y=1),new Position(x=6,y=1), new Position(x=7,y=1)])
		posParedes.forEach{ p => self.dibujar(new Plataforma(position = p))}
	}

	method dibujar(dibujo) {
		game.addVisual(dibujo)
		return dibujo
	}
		}
		

class Player_hitbox {
	
	var property position
	
	
	method image() = "sword2.png"
	method chocar(){}
	

	
}

object player_hit {

	method cargar() {
//	HITBOX
		const ancho = 2
		//const alto = 3
		const posParedes = []
		(0 .. ancho).forEach{ n => posParedes.add(new Position(x = player.position().x() + 2 + n, y = player.position().y()))} // bordeAbajo
		//(0 .. ancho).forEach{ n => posParedes.add(new Position(x = player.position().x() + 3 + 20*n, y = player.position().y()+alto))} // bordeArriba 
		//(0 .. alto).forEach{ n => posParedes.add(new Position(x = player.position().x() + 3, y = player.position().y() + 2*n))} // bordeIzq 
		//(0 .. alto).forEach{ n => posParedes.add(new Position(x = player.position().x() + 3 +ancho, y = player.position().y() + 2*n))} // bordeDer
			// posParedes.addAll([new Position(x=3,y=5), new Position(x=4,y=5), new Position(x=5,y=5)])
			// posParedes.addAll([new Position(x=1,y=2), new Position(x=2,y=2),new Position(x=6,y=2), new Position(x=7,y=2)])
			// posParedes.addAll([new Position(x=1,y=1), new Position(x=2,y=1),new Position(x=6,y=1), new Position(x=7,y=1)])
		posParedes.forEach{ p => self.dibujar(new Player_hitbox(position = p))}
	}

	method dibujar(dibujo) {
		game.addVisual(dibujo)
		player.hitbox().add(dibujo)
		return dibujo
		
	
	}
		}


