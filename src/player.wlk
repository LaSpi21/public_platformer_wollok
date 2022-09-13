import wollok.game.*
import juego.*
import espada.*

object player {

	var vivo = true
	var property salud = 6
	// var position = game.at(1, suelo.position().y())
	var property position = self.posicionInicial()
	var property anim_time = 200
	var property image = 0
	var property mov = false
	var property saltando = false
	var property atacando = false
	var property ataque1 = false
	var property ataque2 = false
	var cayendo = false
	var property tieneEspada = false
	var property att_combo = false
	const property hitbox = []
	var property vulnerable = true
	// ANIMACIONES
	const salto_right = [ "tile069.png", "tile070.png", "tile071.png" ]
	const salto_left = [ "tile069i.png", "tile070i.png", "tile071i.png" ]
	const muere_right = [ "tile065.png", "tile066.png", "tile067.png", "tile068.png", "tile068.png" ]
	const muere_left = [ "tile065i.png", "tile066i.png", "tile067i.png", "tile068i.png", "tile068i.png" ]
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
	const caida_right = [ "tile022.png", "tile023.png" ]
	const caida_left = [ "tile022i.png", "tile023i.png" ]
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

	method posicionInicial() = game.at(1, 1)

	method aplicarAnimate() {
		game.onTick(anim_time, "anima", { self.Animate()})
		juego.tickEvents().add("anima")
	}

	method cambiarAnimate(sprite_nuevo, anim_time_nuevo) {
		game.removeTickEvent("anima")
		juego.tickEvents().remove("anima")
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
		if (self.position().y() == -4) {
			self.transportar(self.posicionInicial())
			self.bajarSalud(1)
		}
		const objAbajo = game.getObjectsIn(game.at(self.position().x() + 4, self.position().y() - 1))
		if (objAbajo.size() > 0) {
			return objAbajo.get(0).esSuelo()
		} else {
			return false
		}
	}

	// console.println(game.getObjectsIn(game.at(self.position().x(), self.position().y()-1)).get(0).esSuelo())
	// return game.getObjectsIn(game.at(self.position().x(), self.position().y()-1))}
	// game.getObjectsIn(game.at(self.position().x(), self.position().y()-1)).esSuelo()
	method saltar() {
		if (self.grounded()) {
			console.println("saltando")
			saltando = true
			self.animSaltar(miraDerecha)
			self.subir()
			2.times({ i => game.schedule(250 * i / 3, { self.subir()})})
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
		hitbox.forEach({ unHitbox => unHitbox.position(unHitbox.position().up(1))})
	}

	method caer() {
		if (!self.grounded() and !saltando) {
			if (!cayendo) {
				self.animCaer(miraDerecha)
			}
			cayendo = true
			position = position.down(1)
			hitbox.forEach({ unHitbox => unHitbox.position(unHitbox.position().down(1))})
		}
		if (self.grounded() and cayendo) {
			cayendo = false
			self.animIdle()
		}
	}

	method animIdle() {
		mov = false
		if (!atacando) {
			if (tieneEspada) {
				if (miraDerecha) { // TODO
					self.cambiarAnimate(idle_espada_right, 250)
				} else {
					self.cambiarAnimate(idle_espada_left, 250)
				}
			} else {
				if (miraDerecha) { // TODO
					self.cambiarAnimate(idle_right, 250)
				} else {
					self.cambiarAnimate(idle_left, 250)
				}
			}
		}
	}

	method caminar(direccion) {
		if (self.grounded() and !mov) {
			self.animCaminar(direccion)
			mov = true
			self.mover(direccion)
			5.times({ i => game.schedule(500 * (i / 7), { self.mover(direccion)})}) // TODO 18 hace que se buggeeee todo
			game.schedule(500, { self.animIdle()})
		} else if (!mov) {
			mov = true
			self.animCaer(direccion)
			self.mover(direccion)
			3.times({ i => game.schedule(500 * (i / 3), { self.mover(direccion)})})
			game.schedule(500, { self.mov(false)})
		}
	}

	method animCaminar(direccion) {
		if (direccion) { // TODO
			self.cambiarAnimate(walk_right, 175)
			miraDerecha = true
		} else {
			self.cambiarAnimate(walk_left, 175)
			miraDerecha = false
		}
	}

	method animAtacar1() {
		if (miraDerecha) {
			self.cambiarAnimate(att1_right, 75)
			game.schedule(150, { ataque.position(self.position().right(3))})
			ataque.danho(1)
			4.times({ i => game.schedule(150 + 150 * (i / 4), { ataque.mover(false)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		} else {
			self.cambiarAnimate(att1_left, 75)
			game.schedule(150, { ataque.position(self.position().right(2))})
			ataque.danho(1)
			4.times({ i => game.schedule(150 + 150 * (i / 4), { ataque.mover(true)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		}
	}

	method animAtacar2() {
		if (miraDerecha) {
			self.cambiarAnimate(att2_right, 75)
			game.schedule(150, { ataque.position(self.position().right(3))})
			ataque.danho(2)
			5.times({ i => game.schedule(150 + 150 * (i / 5), { ataque.mover(false)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		} else {
			self.cambiarAnimate(att2_left, 75)
			game.schedule(150, { ataque.position(self.position().right(2))})
			ataque.danho(2)
			5.times({ i => game.schedule(150 + 150 * (i / 5), { ataque.mover(true)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		}
	}

	method animAtacar3() {
		if (miraDerecha) {
			self.cambiarAnimate(att3_right, 75)
			game.schedule(150, { ataque.position(self.position().right(3))})
			ataque.danho(5)
			12.times({ i => game.schedule(150 + 150 * (i / 12), { ataque.mover(false)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		} else {
			self.cambiarAnimate(att3_left, 75)
			game.schedule(150, { ataque.position(self.position().right(2))})
			ataque.danho(5)
			12.times({ i => game.schedule(150 + 150 * (i / 12), { ataque.mover(true)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		}
	}

	method atacando(bool) {
		if (!att_combo) {
			atacando = bool
		}
	}

	method atacar1() {
		if (self.grounded() and tieneEspada and !atacando and vivo) {
			console.println("att1")
			mov = true
			atacando = true
			self.animAtacar1()
				// 2.times({ i => game.schedule(350 * (i / 2), { self.mover(miraDerecha)})})
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
			self.animAtacar2()
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
			ataque2 = false // sacar si se quiere un combo mas buggeado pero copado
			atacando = true
			att_combo = true
			self.animAtacar3()
				// 2.times({ i => game.schedule(150 * (i / 2), { self.mover(miraDerecha)})})
			8.times({ i => game.schedule(150 + 200 * (i / 10), { self.mover(miraDerecha)})})
			game.schedule(550, { self.mov(false)})
			game.schedule(400, { self.att_combo(false)})
			game.schedule(550, { self.atacando(false)})
			game.schedule(600, { self.animIdle()})
		}
	}

	method animSaltar(direccion) {
		if (direccion) { // TODO
			self.cambiarAnimate(salto_right, 350)
			miraDerecha = true
		} else {
			self.cambiarAnimate(salto_left, 350)
			miraDerecha = false
		}
	}

	method animCaer(direccion) {
		if (direccion) { // TODO
			self.cambiarAnimate(caida_right, 350)
			miraDerecha = true
		} else {
			self.cambiarAnimate(caida_left, 350)
			miraDerecha = false
		}
	}

	method transportar(pos) {
		const diffX = pos.x() - position.x()
		const diffY = pos.y() - position.y()
		hitbox.forEach({ unHitbox => unHitbox.position(unHitbox.position().right(diffX).up(diffY))})
		position = pos // anular moviemiento s anteriores?
	}

	method mover(direccion) {
		if (direccion) { // TODO
			position = position.right(1)
			hitbox.forEach({ unHitbox => unHitbox.position(unHitbox.position().right(1))})
		} else {
			position = position.left(1)
			hitbox.forEach({ unHitbox => unHitbox.position(unHitbox.position().left(1))})
		}
	}

	method detener2() {
		if (vivo) {
			self.animMorir(miraDerecha)
			game.schedule(500, { game.removeTickEvent("anima")})
			game.schedule(500, { juego.tickEvents().remove("anima")})
			game.schedule(500, { game.say(self, "Game Over")})
				// game.removeTickEvent("gravity")
				// juego.tickEvents().remove("gravity")
			game.schedule(500, {juego.terminar()})
			game.schedule(1000, { game.say(self, "Apreta R para reiniciar")})
			vivo = false
		}
	}
	
	method detener() {
		if (vivo) {
			game.removeTickEvent("anima")
			juego.tickEvents().remove("anima")
		}
		if (juego.tickEvents().contains("tiempo")) {
			game.removeTickEvent("tiempo")
			juego.tickEvents().remove("tiempo")
		}
	// game.removeTickEvent("gravity")
	// juego.tickEvents().remove("gravity")
	}
	
	method morir() {
		game.removeTickEvent("anima")
		juego.tickEvents().remove("anima")
			// game.removeTickEvent("gravity")
			// juego.tickEvents().remove("gravity")
		game.say(self, "Game Over")
		if (juego.tickEvents().contains("tiempo")) {
			game.removeTickEvent("tiempo")
			juego.tickEvents().remove("tiempo")
		}
		game.schedule(1000, { game.say(self, "Apreta R para reiniciar")})
		vivo = false
	}

	method animMorir(direccion) {
		if (direccion) { // TODO
			self.cambiarAnimate(muere_right, 100)
		} else {
			self.cambiarAnimate(muere_left, 100)
		}
	}

	method iniciar() {
		self.transportar(self.posicionInicial())
		tieneEspada = false
		sprites = idle_right
			// game.onTick(250 / 3, "gravity", { self.caer()})
		self.aplicarAnimate()
		vivo = true
	}

	method estaVivo() {
		return vivo
	}

	method mostrarPosicion() {
		console.println(self.position())
	}

	method serAtacado(x) {
	}

}

class Player_hitbox {

	var property position

	method image() = "sword2.png" // cambiar imagen

	method chocar() {
	}

	method serAtacado(x) {
	}

}

object player_hit {

	method cargar() {
//	HITBOX
		const ancho = 2
			// const alto = 3
		const posHitbox = []
		(0 .. ancho).forEach{ n => posHitbox.add(new Position(x = player.position().x() + 2 + n, y = player.position().y()))} // bordeAbajo
		posHitbox.forEach{ p => self.dibujar(new Player_hitbox(position = p))}
	}

	method dibujar(dibujo) {
		game.addVisual(dibujo)
		player.hitbox().add(dibujo)
		return dibujo
	}

}

