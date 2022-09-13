import wollok.game.*

class Plataforma {

	var property position

	method esSuelo() = true

	method image() = "muro12.png"

	method chocar() {
	}

}

object nivel1 {

	method cargar() {
//	PAREDES
		const posPlataformas = []
		(1 .. game.width() * (3 / 15)).forEach{ n => posPlataformas.add(new Position(x = n, y = 0))}
		(game.width() * (41 / 50) .. game.width() - 2).forEach{ n => posPlataformas.add(new Position(x = n, y = 0))}
		(game.width() * (1 / 10) .. game.width() + 5 ).forEach{ n => posPlataformas.add(new Position(x = n, y = (2 / 5) * game.height() ))}
		(game.width() * (5 / 10) .. game.width() + 5 ).forEach{ n => posPlataformas.add(new Position(x = n, y = (3 / 5) * game.height() ))}
		(0 .. game.width() * (2 / 10)).forEach{ n => posPlataformas.add(new Position(x = n, y = (7 / 10) * game.height()))}
		(game.width() * (2 / 10) .. game.width() * (17 / 50)).forEach{ n => posPlataformas.add(new Position(x = n, y = (1 / 5) * game.height() ))}
		(game.width() * (22 / 50) .. game.width() * (5 / 10)).forEach{ n => posPlataformas.add(new Position(x = n, y = (1 / 5) * game.height() ))}
		(game.width() * (33 / 50) .. game.width() * (37 / 50)).forEach{ n => posPlataformas.add(new Position(x = n, y = (1 / 5) * game.height() ))}
		(game.width() * (40 / 50) .. game.width() + 5).forEach{ n => posPlataformas.add(new Position(x = n, y = (4 / 5) * game.height() ))}
		posPlataformas.forEach{ p => self.dibujar(new Plataforma(position = p))}
	}

	method dibujar(dibujo) {
		game.addVisual(dibujo)
		return dibujo
	}

}
