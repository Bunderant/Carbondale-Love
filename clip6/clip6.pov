/* CS 484 S11 - Final Lab - Mark Agne and Le Gao

   They meet at last, and live happily ever after.     
*/ 

#include "colors.inc"
#include "stdPrim.inc"

// Animation related variables:
#declare num_loops = 6.0; 
#declare startingPos_x = -18;
#declare anim_clock = 0;

// Create a 0-1 clock variable for each animation loop (based on the overall clock) 
#declare index = 1;
#while (clock >= (index/num_loops) )
   #declare index = index + 1;
#end
#declare current_loop = index-1;
#declare anim_clock = clock*num_loops-current_loop;

// Keep the anim_clock variable from getting too close to 0 or 1 to avoid extreme
// amplitudes when calculating the parabola used in the worm animation.  
#if (anim_clock < 0.04) #declare anim_clock=0.04; #end
#if (anim_clock > 0.96) #declare anim_clock=0.96; #end

#if (clock <= .3)
   #declare heart_height = 0;
#else
   #declare heart_height = 40*(clock-.3);
#end

camera {
  location <0,3,18>
  up    <0,1,0>
  right  <-1.33,0,0>
  look_at <0,heart_height+1,0> 
}

light_source { <-100,1000,-100> color Gray30 }
light_source { <-100,1000,-100> color White }
light_source { <-5,0,2> color White }  

#declare bodyScale = 2; // Specifies size of the bug.  
#declare bodySegmentDist = bodyScale * .75; // Specifies distance between the centers of each body segment 

// Code to draw coordinate axes taken from Dr. Wainer's example.  Only used for
// some preliminary testing:


// Make arrows to lie along the major axi
/*
#declare shaftLen = 2; // A parameter to express arrow shaft length
#declare arrowHead = intersection { // points up (+y)
   object { stdCube rotate <45, 0, 35.264> translate <0, -.5, 0>}
   object { stdCylinder translate <0,0.5,0> }
   scale <0.5, 2, 0.5> // make point sharper
   translate < 0, shaftLen/2, 0> // move up to sit on shaft
}
#declare arrowShaft = object { // positioned on y centered at origin
   stdCylinder scale <0.125, shaftLen, 0.125>
}

#declare upArrow = union {
   object { arrowHead }
   object { arrowShaft }
}

#declare axisArrows = union {
   object { upArrow rotate < 0, 0, -90> // x axis
      pigment {color Red}
   }
   object { upArrow  // y axis
      pigment {color Green }
   }
   object { upArrow rotate < 90, 0, 0> // z axis
      pigment {color Blue }
   }
}       
*/

// Declare eye object
#declare eye = union { 
   difference {
      object { stdSphere }      
      object { stdSphere 
         scale<.9,.9,.9>
         translate<0,0,.3>
         pigment { color Black }
      }
   }     
   object { stdSphere
      scale<.6,.6,.6>
      translate<0,0,.2>
      pigment { color Gray60 }
   }      
}

#declare mouth = difference {
   object { stdCylinder 
      rotate <0,0,90>
      translate <-.5,0,0>
      scale <bodyScale*2,1,1>
   }
   object { stdCube
      translate <0,-.5,0>
      scale <bodyScale*2,1,1>
   }      
   object { stdCylinder
      rotate <0,0,90>
      scale <bodyScale*2,0.5,1>
   }
}

// Declare head object
#declare head = union {
        
   // Eyes
   object { eye
      scale<.8,.8,.8>
      rotate<0,-80,10>
      translate<-.9,.2,-.6>   
   }   
   object { eye
      scale<.8,.8,.8>
      rotate<0,-100,10>
      translate<-.9,.2,.6> 
   }   
      
   // Antennae
   object { stdCylinder 
      translate<0,.5,0>
      scale<.2,2,.2>
      rotate<20,0,30>
   }  
   object { stdCylinder
      translate<0,.5,0>
      scale<.2,2,.2>
      rotate<-20,0,30>
   }
   
   // Head 
   object { stdSphere scale <bodyScale,bodyScale,bodyScale> }
   
   // Mouth
   intersection {
      // Mouth crescent shape
      object { mouth
         scale <1,.7,.7>
         rotate <180,0,0>
         translate <0,-.25,0>
         pigment { color Black }
      }
      
      // Sculpt outside edge to be consistent with the head shape   
      object { stdSphere
         scale <bodyScale*1.05,bodyScale*1.05,bodyScale*1.05>
         pigment { color Black }
      }
   }
}

#declare worm = union {    
   // Body
   #declare num_segments = 3;
   #declare index = 0;
                                      
   #declare headless_worm = union {
      #if (anim_clock < 0.5)                     
         #while (index < num_segments)  
   
            #declare y_int = (num_segments-.4)*(1.3*(anim_clock));
            #declare amp = pow(5*anim_clock,2);
            #declare x_int = sqrt(y_int/amp);
            #declare x_val = (x_int/num_segments)*index;
            #declare y_val = -amp*(x_val*x_val)+y_int;        
      
            object { stdSphere scale <bodyScale,bodyScale,bodyScale>
               translate<x_val,y_val,0> 
            }          
      
            #declare index = index + 1;
         #end 
        
         object { stdSphere 
            scale <bodyScale,bodyScale,bodyScale>
            translate<x_int+bodySegmentDist*.2,bodySegmentDist*anim_clock*.3,0> 
         } 
      #end       
      
      #if (anim_clock >= 0.5)                     
         #while (index < num_segments)
                                                                           
            #declare y_int =(num_segments-.4)*(1.3*(1-anim_clock));
            #declare amp = pow(5*(1-anim_clock),2);
            #declare x_int = sqrt(y_int/amp);
            #declare x_val = ((x_int/num_segments)*index);
            #declare y_val = (-amp*(x_val*x_val)+y_int);        
            
            object { stdSphere 
               scale <bodyScale,bodyScale,bodyScale>
               translate<x_val,y_val,0> 
            }          
            
            #declare index = index + 1;
         #end
 
           
         object { stdSphere 
            scale <bodyScale,bodyScale,bodyScale>
            translate<x_int+bodySegmentDist*.2,bodySegmentDist*(1-anim_clock)*.3,0>     
         }                 
         
      #end
   }          
      
   object { headless_worm }
   object { headless_worm 
      rotate<0,180,0> 
   }
   object { stdSphere
      scale<bodyScale,bodyScale,bodyScale>
      translate<x_int+bodySegmentDist*.65,0,0>
      rotate<0,180,0>    
   }
   object { head 
      rotate<0,180,0>
      translate<x_int+bodySegmentDist*.65,0,0> 
   }   
}

#declare heart = union {
   object { stdCube
      rotate <0,0,45>
      translate <0,.5,0>
   }
   object { stdCylinder
      rotate <90,0,0>
      translate <-.35,.85,0>
      
   }
   object { stdCylinder
      rotate <90,0,0>
      translate <.35,.85,0>
   }
}

#declare x_max = (bodySegmentDist*num_segments);
#declare worm_displacement = x_max*(anim_clock+current_loop);

object { worm  
   translate<startingPos_x+worm_displacement,0,0>
   pigment { color MediumForestGreen }
}

object { worm  
   translate<startingPos_x+worm_displacement,0,0>
   rotate <0,180,0>
   pigment { color Orchid }
}

object { heart
   scale <3,3,.5>   
   rotate <0,(clock*360)*5,0>
   
   #if (clock > .3) 
      translate <0,heart_height,0> 
   #end                            
   
   // Fade in at the beginning
   #if (clock < .3) 
      pigment { color rgbf <1,0,0,1-(clock*10/3)> }
   #else
      pigment { color Red }
   #end
}    
