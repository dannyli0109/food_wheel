var Cell = function(i, x, y, diameter, color, item) {
  this.x = x;
  this.y = y;
  this.diameter = diameter;
  this.i = i;
  this.color = color;
  this.item = item;
  this.deg = PI/(length/2)*(i) - PI/length
  this.radius = this.diameter/3 + this.diameter/length
  this.selected = false;
  this.rotate = 0;
}

Cell.prototype.display = function() {
  // colorMode(HSB, 360,100,100);
  // if (this.selected) {
  //   this.diameter *= 1.5
  // } else {
  //   this.diameter = ra
  // }


  // stroke(255)
  if (this.selected){
    fill(217,83,79)
  } else if (this.i % 2 == 0){
    fill(this.color[0],this.color[1],this.color[2])
  } else {
    fill(255)
  }


  stroke(200)

  arc(this.x,this.y,this.diameter,this.diameter,PI/(wheel.length/2)*this.i + this.rotate,PI/(wheel.length/2)*(this.i+1)+ this.rotate)




  // fill(255)
  // noStroke()

  // arc(this.x,this.y,this.diameter/2,this.diameter/2,PI/(wheel.length/2)*this.i,PI/(wheel.length/2)*(this.i+1))

  stroke(0)
  strokeWeight(2)


  // line(
  //   this.x,
  //   this.y,
  //   this.radius * cos(this.deg),
  //   this.radius * sin(this.deg)
  // )


}
Cell.prototype.displayText = function() {
  fill(0)
  noStroke()
  textSize(13)
  textAlign(CENTER)
  text(this.item,this.endPoint()[0]-30,this.endPoint()[1]-30,70, 80)

}

Cell.prototype.interceptC = function(x,y) {
  var nextCell = wheel[(this.i + 1) % 12]
    if (
      x > this.endPoint()[0] &&
      x < nextCell.endPoint()[0]
    ) {
      console.log(this.i);
      return true
    }
  return false

}


Cell.prototype.endPoint = function() {
  return [this.radius * cos(this.deg + this.rotate),this.radius * sin(this.deg + this.rotate)]
}
