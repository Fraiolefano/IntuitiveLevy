int programMode=0;  //0=2D,1=3D,2=Manual
int drawMode=0;

ArrayList<Walker> Walkers;
int nWalkers=30;

float depth=0;
float angleVelocity=20f *(PI/180f);
PVector boundary;

PVector influence;
float maxInfluence=20;
float influenceMag=0;
PVector influencePos=new PVector(100,100);

PImage manual;

final int FPS=60;
float deltaTime=1.0/FPS;


void setup()
{
    fullScreen(P3D);
    background(0);
    manual=loadImage("manual.jpg");
    depth=height*0.8f;
    
    influence=new PVector(0,0,0);
    frameRate(FPS);
    init();
    programMode=2;
}

void draw()
{
  background(0);
  drawForce();
  Walker crtB;
  switch (programMode)
  {
    case 0:
      translate(width/2,height/2);
      break;
    case 1:
      translate(width/2,height/2,-depth/2);
      rotateY(angleVelocity*millis()/1000f);
      stroke(0,255,127);
      noFill();
      box(depth);
      break;
    case 2:
      showManual();
      return;
  }
  for (int b=0;b<Walkers.size();b++)
  {
    crtB=Walkers.get(b);
    crtB.levy();
    crtB.applyForce(influence);
    crtB.velocity.add(crtB.acceleration);
    crtB.position.add(crtB.velocity.copy().mult(deltaTime));
    crtB.bounds();
    crtB.manageTrail();
    crtB.drawTrail();
    crtB.draw();
    crtB.acceleration=new PVector(0,0,0);
  }
}

void keyReleased()
{
  if (keyCode==LEFT)
  {
    drawMode--;
    if (drawMode<0) {drawMode=4;} 
  }
  else if (keyCode==RIGHT)
  {
    drawMode++;
    if (drawMode>4) {drawMode=0;}
  }
  
  else if (keyCode=='1')
  {
    programMode=0;
    init();
    return;
  }
  else if (keyCode=='2')
  {
    programMode=1;
    init();
    return;
  }
  else if (keyCode=='H')
  {
    programMode=2;
    return;
  }
}

void mouseWheel(MouseEvent e )
{
  influenceMag+=-e.getCount();
  if (influenceMag<0){influenceMag=0;}
  else if (influenceMag>maxInfluence){influenceMag=maxInfluence;}
  influence=new PVector(mouseX-100,mouseY-100,0).normalize().mult(influenceMag);
}

void mouseMoved()
{
  influence=new PVector(mouseX-100,mouseY-100,0).normalize().mult(influenceMag);
}

void init()
{
  switch(programMode)
  {
    case 0:
      boundary=new PVector(width/2.0,height/2.0,0);
      break;
    case 1:
      boundary=new PVector(depth/2.0,depth/2.0,depth/2.0);
      break;
  }
  
  Walkers=new ArrayList<Walker>();
  for(int n=0;n<floor(random(10,nWalkers));n++)
  {
    Walker b=new Walker();
    b.mass=random(1,3);
    if (programMode==0)
    {
      b.position=new PVector(random(-boundary.x,boundary.x),random(-boundary.y,boundary.y),0 );
    }
    else
    {
      b.position=new PVector(random(-boundary.x,boundary.x),random(-boundary.y,boundary.y),random(-boundary.z,boundary.z) );
    }
    b.col=color(0,127,255);
    b.radius=random(2,3);
    Walkers.add(b);
  }
}

void drawForce()
{
  if (influence.mag()==0) return;
  
  fill(0,127,255);
  stroke(0,127,255);
  circle(influencePos.x,influencePos.y,5);
  line(influencePos.x,influencePos.y,influencePos.x+influence.x*10,influencePos.y+influence.y*10);
  noStroke();
}

float myLerp(float a, float b, float c)
{
  return (a*(1-c))  + (b * c);
}

color lerpColor(float r1,float g1,float b1,float r2, float g2, float b2, float lerpFactor )
{
  color c = color(myLerp(r1,r2,lerpFactor),myLerp(g1,g2,lerpFactor),myLerp(b1,b2,lerpFactor));
  return c;
}
  
void showManual()
{
  background(0);
  image(manual,0,0,width,height);
}
