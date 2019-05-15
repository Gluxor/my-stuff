/////Michal Ochelski all rights reserved /////
/////gluxor@o2.pl
///// Game Class /////

function Game(sizeX, sizeY) {
  
  this.level = 1
  this.diamonds = 0
  this.sizeX = sizeX
  this.sizeY = sizeY
  this.measures = "vmin"
  this.levelTime = 0
  this.timerActive = false
  
    
  this.board = document.createElement("div")
  this.board.className = "board"
  document.body.appendChild(this.board)
  
 
  
  this.createLevel = function createLevel() {
    
    this.clearBoard()
    
    var i = 0
    
    while(i < this.sizeX * this.sizeY) {
      
      var segment = document.createElement("div")
      segment.style.width = 100/this.sizeX + this.measures
      segment.style.height = 100/this.sizeY + this.measures

      var segmentType = Math.floor((Math.random() * 10) + 1)

        if(segmentType==1) {
           segment.className = "diamond"
           this.diamonds += 1
           this.protectDiamond(segment, i)
        }
        else if(segmentType > 1 && segmentType < 4) {
          segment.className = "wall"
        }
        else {
          segment.className = "segment"
        }
       
    this.protectPlayer(segment, i)
    this.board.appendChild(segment)
      
    i++
    }
    

  }
  
  this.protectPlayer = function protectPlayer(segment, i) {  
    
    if( this.posInCollection(player.positionX, player.positionY) -1 == i || this.posInCollection(player.positionX, player.positionY) -2 == i || this.posInCollection(player.positionX, player.positionY) +1 == i || this.posInCollection(player.positionX, player.positionY) == i) {
      
      if (segment.className == "diamond") { 
        this.diamonds -= 1 
      }
      segment.className = "segment" 

    }
  }

  this.protectDiamond = function protectDiamond(segment, i) { 
  
  }
  
  this.isDiamond = function isDiamond(PositionX, PositionY) {    
   
    if (this.board.childNodes[this.posInCollection(PositionX, PositionY) -1].className == "diamond") {
        player.points += 1
        this.board.childNodes[this.posInCollection(PositionX, PositionY) -1].className = "segment"
        this.displayPoints()
      
        this.isComplete()
        
        }
  }
  
  this.displayPoints = function displayPoints() {
    
    player.counter.innerHTML = player.points
  }
  
  this.notWall = function notWall(nextPositionX, nextPositionY) {
       
    if (this.board.childNodes[this.posInCollection(nextPositionX, nextPositionY) -1].className  !== "wall") {
     
      return true
    }
    else {
      
      return false
    }
  }
  
  this.isComplete = function isComplete() {

    if (this.diamonds == player.points - player.pointsOnLastLevel ) { 
      
      this.newLevel()
   }
  }
  
  this.newLevel = function newLevel() {
    
      player.pointsOnLastLevel = player.points
      this.levelTime = 0
      this.timerActive = false
      this.level += 1
      this.clearBoard()
      this.createLevel()
      player.addPlayerSegment(this)
      this.displayPoints()
      info.show("<b>Level " + this.level + "</b><br> diamonds: " + (this.diamonds) + "<br>total points after level " + (this.level -1) + ": " + player.points, "5s", "lightgreen")
 
  }
  
  
  this.clearBoard = function clearBoard() {
    
        this.diamonds = 0
        while ( this.board.hasChildNodes() ) {
          this.board.removeChild(this.board.lastChild);
        }
    }
  
  this.posInCollection = function posInCollection(nextPositionX, nextPositionY) {
    
    return (nextPositionX + 1) + (nextPositionY * this.sizeX)
  }

}

///// Player Class /////
function Player(positionX, positionY) {
    

  var segmentSize = game.sizeX
    
  this.points = 0
  this.pointsOnLastLevel = 0 
  this.positionX = positionX
  this.positionY = positionY
  
  this.playerSegment =  {}
  this.counter = {}
  this.timer = {}
  
  this.addPlayerSegment = function addPlayerSegment(game) {
    
    this.playerSegment = document.createElement("div")
    this.playerSegment.className = "player"
    game.board.appendChild(this.playerSegment)
    
    this.counter = document.createElement("div")
    this.counter.className = "counter"
    this.timer = document.createElement("div")
    this.timer.className = "timer"
      
    this.playerSegment.appendChild(this.counter)
    this.playerSegment.appendChild(this.timer)

    
    game.displayPoints()
    this.updatePosition()
  }
  
  this.updatePosition = function updatePosition() {
    
    this.playerSegment.style.left = (this.positionX * segmentSize) + game.measures
    this.playerSegment.style.top = (this.positionY * segmentSize) + game.measures

    this.playerSegment.style.transform = "translate(" + game.board.offsetLeft + "px, " + game.board.offsetTop + "px)"

  }


}

///// game Controller Class /////
function gameController(game, player) {
  
  var holdKey = 0
  
  this.releaseKey = function releaseKey(e) { holdKey = 0 }

 
  this.move = function move(e) {
    
    player.positionXLast =  player.positionX 
    player.positionYLast =  player.positionY 

    if(game.timerActive)  {
      
      switch (e.key) {
         
        case "ArrowUp":
            holdKey = -1
         if (gameController.inBoard(player.positionX, player.positionY - 1) ) {
            if( game.notWall(player.positionX, player.positionY - 1) ) {             
                player.positionY -= 1
              }
            }
            break

        case "ArrowDown":
            holdKey = 1
         if (gameController.inBoard(player.positionX, player.positionY + 1) ) {
            if( game.notWall(player.positionX, player.positionY + 1) ) {             
                player.positionY += 1
              }
            }
            break

        case "ArrowLeft":
         if (gameController.inBoard(player.positionX -1, player.positionY + holdKey) ) {
            if( game.notWall(player.positionX -1, player.positionY + holdKey) ) {             
              player.positionX -= 1
              player.positionY += holdKey
              }
            }
            break

        case "ArrowRight":
         if (gameController.inBoard(player.positionX + 1, player.positionY + holdKey) ) {
            if( game.notWall(player.positionX + 1, player.positionY + holdKey) ) {             
              player.positionX += 1
              player.positionY += holdKey
              }
            }
            break

          default:
            info.show("Key not supported" , "1s", "coral")
            break
      }
      
    }
    
  game.isDiamond(player.positionX, player.positionY)
  player.updatePosition()

  }
  
  this.inBoard = function inBoard(nextPositionX, nextPositionY) {

      if(nextPositionX < game.sizeX && nextPositionX >= 0 && nextPositionY < game.sizeY && nextPositionY >= 0)  {

        return true
    }
    else { 
        info.show("Don't go off board" , "1s", "coral")
        return false         
    }
  }

 this.controlTime = function controlTime() {
 
   if ( game.timerActive ) {    
   
       player.playerSegment.style.background = "lime"
     
       if (game.levelTime < 45) { 

           game.levelTime += 1
           player.timer.innerHTML = game.levelTime

              if (game.levelTime > 34)   player.playerSegment.style.background = "coral"
              if (game.levelTime > 39)   player.playerSegment.style.background = "red"
              
         
       }

       else {
         
           game.newLevel()
       }
     
   }  
   
   else { 
       console.log("not active")
       player.playerSegment.style.background = "gray" 
   }
   
 } 
  
  this.controlTimer = setInterval(this.controlTime, 1000)
  
}

///// Info Class /////
function Info() {
  
  this.info = document.createElement("div")
  this.info.className = "info"
  document.body.appendChild(this.info)
  
  this.show = function show(message, duration, background) {
    
    this.info.innerHTML = message
    this.info.style.animationName = "show"
    this.info.style.animationDuration = duration
    this.info.style.background = background
  }
  
  this.info.addEventListener('animationend', function(){
    this.style.animationName = null
    game.timerActive = true
  })
  
}


///// GAME /////
 
 var messages = {
   welcome: {duration: "10s", message: "<b>Welcome.</b> <br> Use Arrows keys to move.<br> Hold <b>Up/Down</b> arrow key + <b>Right/Left</b> arrow to teleport.<br> "
             + "<b>example</b>: hold up arrow and press right arrow to teleport between walls.</br>You have <b>45sec</b> to collect items.<br><b>(BETA 1)</b>"},
   author: { duration: "5s", message: "author: <b>Michał Ochelski</b>(gluxor@o2.pl)<br> free for noncommercial use."}
 }
 var game = new Game(10, 10)

 var player = new Player(5, 5)
 
 game.createLevel()
 player.addPlayerSegment(game)
 
 var gameController = new gameController(game, player)
 
 var info = new Info()
 info.show( messages["welcome"].message + messages["author"].message , messages["welcome"].duration, "lightblue")


 document.body.onkeydown = gameController.move
 document.body.onkeyup = gameController.releaseKey
 document.body.onresize = function() { 
   player.updatePosition() 
 }