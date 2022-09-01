import wollok.game.*

class TP {
	
	var property position
	var property image
	var property x
  var property y
  
	method esSuelo() = false
	method chocar(){
    player.position(player.position.right(x).up(x)) //CHECKEA ESTO
  }
  
  }
  
const tp1 = new TP(position = game.at(10,1), image = "tp1.png", x = 10, y = 10)
const tp2 = new TP(position = game.at(10,1), image = "tp2.png", x = 10, y = 10)  //CAMBIAR LAS POSITION Y LOS X,Y.. agregarlos al inicio de plat.wlk
const tp3 = new TP(position = game.at(10,1), image = "tp3.png", x = 10, y = 10)
const tp4 = new TP(position = game.at(10,1), image = "tp4.png", x = 10, y = 10)
}

class Receiver{

	method esSuelo() = false
	method image() = "TP.png"
	method chocar(){
  
  }
}

const r1 = new Receiver(position = game.at(10,1), image = "tp1.png")
const r2 = new Receiver(position = game.at(10,1), image = "tp2.png")    //CAMBIAR LAS POSITION Y LOS X,Y.. agregarlos al inicio de plat.wlk
const r3 = new Receiver(position = game.at(10,1), image = "tp3.png")
const r4 = new Receiver(position = game.at(10,1), image = "tp4.png")
