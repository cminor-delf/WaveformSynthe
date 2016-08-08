import ddf.minim.*;
import ddf.minim.ugens.*;

Minim       minim;
AudioOutput out;
Oscil       wave;
Wavetable   table;

void setup()
{
  size(1024, 500, P3D);
  
  minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  
  // create a reasonably complex waveform to start, will be slightly different every time
  table = Waves.randomNHarms(16);
  wave  = new Oscil( 110, 0.5f, table );
  // patch the Oscil to the output
  wave.patch( out );
}

void draw()
{
  background(0);
  
  stroke(255, 64);
  strokeWeight(1);
  
  // draw the waveform of the output
  for(int i = 0; i < out.bufferSize() - 1; i++)
  {
    line( i, 100  - out.left.get(i)*50, i+1, 100  - out.left.get(i+1)*50 );
    line( i, 300 - out.right.get(i)*50, i+1, 300 - out.right.get(i+1)*50 );
  }

  // draw the waveform we are using in the oscillator
  stroke( 200, 0, 0 );
  strokeWeight(4);
  for( int i = 0; i < width-1; ++i )
  {
    line( i, height/2 - (height*0.49) * table.value( (float)i / width) , i+1, height/2 - (height*0.49) * table.value( (float)(i+1) / width ) );
  }
  if(keyPressed&&key == 'k')
  {
    table.scale(0.98f);
  }
  if(keyPressed&&key=='l')
  {
    table.scale(1.03f);
  }
}

void keyPressed()
{ 
  switch( key )
  {
    case 'n':
      // scale the table so that the largest value is -1/1.
      table.normalize();
      break;
     
    case 's':
      // smooth out the table, similar to applying a low pass filter
      table.smooth( 64 );
      break;
     
    case 'r':
      // change all negative values to positive values
      table.rectify();
      break;
   
    case 'z':
      // add some noise
      table.addNoise( 0.1f );
      break;
    
    case 'q':
      table.scale( 1.1f );
      break;
      
    case 'a':
      table.scale( 0.9f );
      break;
     
    default: break; 
  }
}

void mousePressed()
{
  if ( mouseButton == RIGHT )
  {
    float flipPoint = map( mouseY, 0, height, 1, -1 );
    table.flip( flipPoint );
  }
  wave.patch(out);
}

void mouseDragged()
{
  if ( mouseButton == LEFT )
  {
    float y = pmouseY;
    int x = pmouseX;
    y = map(y,height,0, -1, 1 );
    x = (int)map(x,0,width , 0, table.size());
    if(x<10)x=10;
    if(x>table.size()-10) x=table.size()-10;
    for(int i=-10;i<10;i++){
    table.set( x+i,y);
    }
    println(x,y);
    
  }
}

void mouseReleased()
{
  
      table.smooth(128);
      
      table.scale( 0.8f );
}