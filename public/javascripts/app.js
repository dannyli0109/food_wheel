var wheel = []
var width = 800
var radius = width/3*2
var length = 12
var spinAngle = 0
var spinReduce = 1
var spinAccerlerate = 0
var startingPos = null
var angleTotal = 0
var finishSpinning = false
var canvas, button;
var buttonDiv = document.querySelector("#lets_go")
var latInput = document.querySelectorAll(".coordinate")[0]
var lonInput = document.querySelectorAll(".coordinate")[1]
var vicinityInput = document.querySelector("#vicinity")
var nameInput = document.querySelector("#name")
var placeInput = document.querySelector("#place")


function generateRandomColor(mix) {
  var red = random(0,255)
  var green = random(0,255)
  var blue = random(0,255)

  // mix the color

  red = (red + mix[0]) / 2;
  green = (green + mix[1]) / 2;
  blue = (blue + mix[2]) / 2;


  return [red,green,blue];
}


function initWheel(amount) {
  for (var i = 0; i < amount; i++) {
    col = 200
    wheel.push(new Cell(i, 0, 0, radius, [col,col,col], items[i]))
  }
}

// ajax request

function setup() {
  canvas = createCanvas(601,601)
  initWheel(12)
  canvas.parent("roulette")
  for (var i = 0; i < wheel.length; i++) {
    console.log(wheel[i].endPoint());
  }
}

function getData(data) {
  console.log(data);
}


function draw() {
  colorMode(RGB, 255)
  background(255)

  translate(width/2, height/2);


  for (var i = 0; i < wheel.length; i++) {
    wheel[i].display()
  }

  for (var i = 0; i < wheel.length; i++) {
    wheel[i].displayText()
  }



  fill(255)
  stroke(200)

  ellipse(0, 0, width/2)

  for (var i = 0; i < wheel.length; i++) {

    var nextItem = wheel[(i+1) % wheel.length]
    // text(wheel[i].item,wheel[i].radius/3 * 2 * cos(wheel[i].deg),wheel[i].radius/3 * 2 * sin(wheel[i].deg))
    // console.log(dist(wheel[i].endpoint()[0],wheel[i].endpoint()[1],nextItem.endPoint()[0],nextItem.endPoint()[1]));
    // console.log(nextItem.endPoint()[0]);

  }



  spinAngle += spinAccerlerate
  spinAccerlerate *= spinReduce



  // var currentPlace = (360 - degrees(spinAngle) % 360)% 11
  // var currentPlace = spinAngle/(PI/12)%11
  // console.log(spinAngle/(PI/12)%11);
  // wheel[Math.round(currentPlace)].selected = true



  if (spinAccerlerate < 0.005 && spinAccerlerate > 0) {
    spinAccerlerate = 0
    finishSpinning = true
  }

  for(var i = 0; i < wheel.length; i++) {
    wheel[i].rotate = spinAngle
    wheel[i].selected = false
  }
  for (var i = 0; i < wheel.length; i++) {
    if(wheel[i].interceptC(-57.51534335611563,-250)) {
      wheel[i].selected = true
    }
  }



  fill(0)
  stroke(0)
  triangle(-10, -280, 0, -250, 10, -280);

  noStroke()
  textSize(20)
  if (finishSpinning) {
    for (var i = 1; i < wheel.length + 1; i++) {
      if (wheel[i-1].selected) {
        text(wheel[i%12].item,-50,-50,100,100)
        latInput.value = coordinates[i%12][0]
        lonInput.value = coordinates[i%12][1]
        vicinityInput.value = vicinities[i%12]
        nameInput.value = items[i%12]
        placeInput.value = placeIds[i%12]
      }
    }
    if (!button) {

      button = document.createElement("BUTTON")
      button.innerHTML = "Let's go"
      button.className = "btn btn-primary"
      buttonDiv.appendChild(button)

    }
  }

}


function interceptWithWheel(x,y) {
  // console.log(dist(width/2,width/2,x,y));
  var distance = dist(width/3,width/3,x,y)
  if (distance < radius && distance > radius/2) {
    return true
  } else {
    return false
  }
}

function mousePressed() {

  if (!finishSpinning) {
    if (interceptWithWheel(mouseX, mouseY)) {
      startingPos = [mouseX, mouseY]
      spinReduce = 1
    }
  }


}

function mouseDragged() {
  if (!finishSpinning) {
    if (startingPos) {
      if (interceptWithWheel(mouseX, mouseY)) {
        var rad = atan2(mouseY - startingPos[1],mouseX - startingPos[0])
        // console.log(degrees(acos(abs(a/b))));
        spinAngle = rad
      }

    }
  }

}

function mouseReleased() {

  if (!finishSpinning) {
    if (startingPos) {
      if (mouseY - startingPos[1] > 30) {
        spinAccerlerate += random(0.1,0.25)
      }
      spinReduce = 0.99
      startingPos = null
    }
  }



}
