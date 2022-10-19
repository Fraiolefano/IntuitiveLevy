class Walker
{
    PVector position;
    PVector velocity;
    PVector acceleration;
    float mass=1;
    color col=color(255);
    float radius=20;
    ArrayList<PVector> trailPositions;
    int nTrails=500;
    float trailTimer=0;
    float levyStart=0;
    float levyTimer=100;
    float randomStart=0;
    int[] randomVel={100,200};
    Walker()
    {
      this.position=new PVector(0,0,0);
      this.velocity=new PVector(0,0,0);
      this.acceleration=new PVector(0,0,0);
      this.trailPositions=new ArrayList<PVector>();
      
    }
    
   void draw()
   {
     fill(col);
     stroke(col );
     strokeWeight(this.radius);
     point(position.x,position.y,position.z);
     strokeWeight(1);
   }

   void bounds()
   {
     float k=1;
     
     if (this.position.x>boundary.x-radius)
     {
       this.position.x=boundary.x-radius;
       this.velocity.x*=-k;
     }
     else if (this.position.x<-boundary.x+radius)
     {
       this.position.x=-boundary.x+radius;
       this.velocity.x*=-k;
     }
     
     if (this.position.y>boundary.y-radius)
     {
       this.position.y=boundary.y-radius;
       this.velocity.y*=-k;
     }
     else if (this.position.y<-boundary.y+radius)
     {
       this.position.y=-boundary.y+radius;
       this.velocity.y*=-k;
     }
     
     if (programMode==1)
     {
       if (this.position.z>boundary.z-radius)
       {
         this.position.z=boundary.z-radius;
         this.velocity.z*=-k;
       }
       else if (this.position.z<-boundary.z+radius)
       {
         this.position.z=-boundary.z+radius;
         this.velocity.z*=-k;
       }
     }
     
   }

  void applyForce(PVector force)
  {
    this.acceleration.add(force.copy().div(mass));
  }
  
  void manageTrail()
  {
    if (millis()-trailTimer>10)
    {
      trailPositions.add(position.copy());
      if (trailPositions.size()>nTrails)
        {trailPositions.remove(0);}
        trailTimer=millis();
    }
  }

  void drawTrail()
  {
    strokeWeight(1);
    PVector crtP=new PVector();
    PVector nexP=new PVector();
    
    switch(drawMode)
    {
      case 0:
        drawTrail0(crtP,nexP);
        break;
      case 1:
        drawTrail1(crtP,nexP);
        break;
      case 2:
        drawTrail2(crtP,nexP);
        break;
      case 3:
        drawTrail3(crtP,nexP);
        break;
      case 4:
        drawTrail4();
        break;
    }
    strokeWeight(1);
  }
  
  void drawTrail0(PVector crtP, PVector nexP)
  {
    for(int p=0;p<trailPositions.size()-1;p++)
    {
      crtP=trailPositions.get(p);
      nexP=trailPositions.get(p+1);
      float currentSize=trailPositions.size();
      float alpha= (255) *(p/currentSize);
      float WalkerR= radius*(p/currentSize);
      stroke(color(   0     ,(255-155*abs(crtP.y/boundary.y)),127,alpha));
      strokeWeight(WalkerR);
      line(crtP.x,crtP.y,crtP.z,nexP.x,nexP.y,nexP.z );
    }
  }

  void drawTrail1(PVector crtP, PVector nexP)
  {
    for(int p=0;p<trailPositions.size()-1;p++)
    {
      crtP=trailPositions.get(p);
      nexP=trailPositions.get(p+1);
      float currentSize=trailPositions.size();
      float WalkerR= radius*(p/currentSize);
      float alpha= (255) *(p/currentSize);
      float lerpF=(1.0/nTrails)*p;
      color pColor=lerpColor(0,255,127,0,127,255,lerpF);
      color hColor=color( 255-(255*abs(crtP.y/boundary.y)) ,green(pColor)*abs(crtP.y/boundary.y),blue(pColor)*abs(crtP.y/boundary.y),alpha     );
      stroke(hColor);
      strokeWeight(WalkerR);
      line(crtP.x,crtP.y,crtP.z,nexP.x,nexP.y,nexP.z );
    }
  }

  void drawTrail2(PVector crtP, PVector nexP)
  {
    for(int p=0;p<trailPositions.size()-1;p++)
    {
      crtP=trailPositions.get(p);
      nexP=trailPositions.get(p+1);
      float currentSize=trailPositions.size();
      float alpha= (255) *(p/currentSize);
      float lerpF=(1.0/nTrails)*p;
      color pColor=lerpColor(0,255,127,0,127,255,lerpF);
      color hColor=color( 255-(255*abs(crtP.y/boundary.y)) ,green(pColor)*abs(crtP.y/boundary.y),blue(pColor)*abs(crtP.y/boundary.y),alpha     );
      stroke(hColor);
     strokeWeight(10-noise((crtP.y/10.0) * (millis()/5000.0))*9);
     point(crtP.x,crtP.y,crtP.z);
     strokeWeight(1);
     line(crtP.x,crtP.y,crtP.z,nexP.x,nexP.y,nexP.z );
    }
  }

  void drawTrail3(PVector crtP, PVector nexP)
  {
    for(int p=0;p<trailPositions.size()-1;p++)
    {
      crtP=trailPositions.get(p);
      nexP=trailPositions.get(p+1);
      float currentSize=trailPositions.size();
      float alpha= (255) *(p/currentSize);
      color pColor=color(   0     ,(255-155*abs(crtP.y/boundary.y)),127,alpha);
      stroke(pColor);
      strokeWeight(10-noise((crtP.y/10.0) * (millis()/5000.0))*9);
      point(crtP.x,crtP.y,crtP.z);
      strokeWeight(1);
      line(crtP.x,crtP.y,crtP.z,nexP.x,nexP.y,nexP.z );

    }
  }

  void drawTrail4()
  {
      color pColor=color(   0     ,(255-155*abs(position.y/boundary.y)),127);
      stroke(pColor);
      strokeWeight(20-noise((position.y/100.0)* (millis()/5000.0))*19);
      point(position.x,position.y,position.z);
  }

  void levy()
  {
    float randomTimer=1000f;
    
    if (millis()-randomStart>=randomTimer)
    {
      float r=floor(random(0,100));
      randomStart=millis();
      
      if (r<=25)
      {
        levyTimer=1000;
        randomVel[0]=200;
        randomVel[1]=300;
        levyStart=0;
      }
      else
      {
        levyTimer=100;
        randomVel[0]=100;
        randomVel[1]=200;
      }
      
    }
    if (millis()-levyStart>=levyTimer)
    {
      PVector f;
      switch (programMode)
      {
        case 0:
          f=new PVector(random(-1,1),random(-1,1),0).mult(random(1,5));
          this.velocity=new PVector(random(-1,1),random(-1,1),0).mult(random(randomVel[0],randomVel[1]));
          break;
        case 1:
          f=new PVector(random(-1,1),random(-1,1),random(-1,1)).mult(random(1,5));
          this.velocity=new PVector(random(-1,1),random(-1,1),random(-1,1)).mult(random(randomVel[0],randomVel[1]));
          break;
      }
      levyStart=millis();
    }
  }
  
}
