	method chocar_deprecated() {
		if (player.vulnerable()) {
			player.vulnerable(false)
			player.mov(true)
			4.times({ i => game.schedule(45 * (1.6 ** i), { player.mover(!direccion)})})
			game.schedule(300, { player.vulnerable(true)})
			game.schedule(300, { player.mov(false)})
			player.bajarSalud(2)
		}
	}