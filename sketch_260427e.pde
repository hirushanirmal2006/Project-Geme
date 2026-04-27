float ballX, ballY;
float speedX, speedY;

float paddleY;
float aiY;

int score = 0;
int lives = 3;

boolean isGameOver = false;

// Stars
float[] starX = new float[50];
float[] starY = new float[50];

//  Power-up
float powerX, powerY;
boolean showPower = false;

void setup() {
  size(700, 400);
  resetBall();

  // stars init
  for (int i = 0; i < 50; i++) {
    starX[i] = random(width);
    starY[i] = random(height);
  }
}

void draw() {

  if (isGameOver) {
    drawGameOver();
    return;
  }

  background(10, 20, 50);

  //  Moving Stars
  for (int i = 0; i < 50; i++) {
    fill(255);
    ellipse(starX[i], starY[i], 2, 2);
    starY[i] += 1;
    if (starY[i] > height) {
      starY[i] = 0;
      starX[i] = random(width);
    }
  }

  //  Center line
  stroke(255, 80);
  line(width/2, 0, width/2, height);

  //  Ball glow
  noStroke();
  for (int i = 12; i > 0; i--) {
    fill(255, 255, 0, 20);
    ellipse(ballX, ballY, i*2, i*2);
  }
  fill(255, 255, 0);
  ellipse(ballX, ballY, 20, 20);

  // movement
  ballX += speedX;
  ballY += speedY;

  if (ballY < 10 || ballY > height - 10) {
    speedY *= -1;
  }

  //  Player paddle
  paddleY = mouseY - 40;
  fill(0, 200, 255);
  rect(10, paddleY, 12, 80, 10);

  
  aiY += (ballY - aiY - 40) * 0.08;
  fill(255, 80, 160);
  rect(width - 22, aiY, 12, 80, 10);

  // collision
  if (ballX < 25 && ballY > paddleY && ballY < paddleY + 80) {
    speedX *= -1.03;
    ballX = 25;
    score += 10;
  }

  if (ballX > width - 25 && ballY > aiY && ballY < aiY + 80) {
    speedX *= -1.03;
    ballX = width - 25;
  }

  //  miss
  if (ballX < 0) {
    lives--;
    if (lives <= 0) {
      isGameOver = true;
    } else {
      resetBall();
    }
  }

  if (ballX > width) {
    score += 20;
    resetBall();
  }

  //  Power-up spawn
  if (frameCount % 300 == 0) {
    powerX = random(100, width-100);
    powerY = random(50, height-50);
    showPower = true;
  }

  // draw power-up
  if (showPower) {
    fill(0, 255, 100);
    ellipse(powerX, powerY, 15, 15);

    // collect
    if (dist(ballX, ballY, powerX, powerY) < 15) {
      score += 50;
      showPower = false;
    }
  }

  drawUI();
}

//  Reset
void resetBall() {
  ballX = width/2;
  ballY = height/2;
  speedX = random(4, 5) * (random(1) > 0.5 ? 1 : -1);
  speedY = random(-3, 3);
}

// 🧾 UI
void drawUI() {
  textSize(20);

  // score
  fill(0, 255, 200);
  textAlign(LEFT);
  text("Score: " + score, 20, 30);

  //  Lives as hearts
  for (int i = 0; i < lives; i++) {
    fill(255, 0, 0);
    ellipse(width - 30 - i*25, 25, 15, 15);
  }

  // level
  textAlign(CENTER);
  fill(255);
  text("Level: " + (score/100 + 1), width/2, 30);
}

//  Game Over
void drawGameOver() {
  background(0);

  for (int i = 0; i < 50; i++) {
    fill(255);
    ellipse(starX[i], starY[i], 2, 2);
    starY[i] += 1;
    if (starY[i] > height) {
      starY[i] = 0;
      starX[i] = random(width);
    }
  }

  textAlign(CENTER);
  fill(255, 0, 0);
  textSize(50);
  text("GAME OVER", width/2, height/2);

  
  textSize(20);
  fill(#FAFF17);
  text("Final Score: " + score, width/2, height/2 + 40);
  fill(#FFFFFF);
  text("Click to Restart", width/2, height/2 + 80);
}

//  Restart
void mousePressed() {
  if (isGameOver) {
    score = 0;
    lives = 3;
    isGameOver = false;
    resetBall();
  }
}
