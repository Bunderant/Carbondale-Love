/* CS 484 S11 - Final Lab - Mark Agne and Le Gao

   A daring rescue attemt kinda sorta works out for our hero.     
*/  

#include "colors.inc"
#include "stdPrim.inc"

// Animation related variables:
#declare animation_loop = 15;
#declare num_loops = 6.0; 
#declare startingPos_x = 0;
#declare startingPos_y = -3.5;
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

// This is the beginning of the background image code. The template was found at:
// http://www.spiritone.com/~english/cyclopedia/background.html
#declare CamLook = <0,20,0>; // Camera's Look_at 
#declare CamLoc = <10,18,-25>; //where the camera's location is
#declare cam_z = 1.0; //the amount of camera zoom
#declare back_dist = 2000; // how far away the background image is
#declare cam_a = 4/3; // camera aspect ratio
#declare cam_s = <0,1,0>; // camera sky vector
#declare cam_d = vnormalize(CamLook-CamLoc); // camera direction vector
#declare cam_r = vnormalize(vcross(cam_s,cam_d)); // camera right vector
#declare cam_u = vnormalize(vcross(cam_d,cam_r)); // camera up vector
#declare cam_dir = cam_d * cam_z; // direction vector scaled
#declare cam_right = cam_r * cam_a; // right vector scaled

#declare fz = vlength(cam_dir);
#declare fx = vlength(cam_right)/2;
#declare fy = vlength(cam_u)/2; 

#macro OrientZ(p1,p2,cs)
  #local nz = vnormalize(p2-p1);
  #local nx = vnormalize(vcross(cs,nz)); 
  #local ny = vcross(nz,nx);
  matrix <nx.x,nx.y,nx.z, ny.x,ny.y,ny.z, nz.x,nz.y,nz.z, p1.x,p1.y,p1.z>          
#end

camera {
  location CamLoc
  up cam_u
  right cam_r * cam_a
  direction (cam_d * cam_z) 
}

box { <0,0,0> <1,1,0.1>
      pigment { image_map { jpeg "clipImage3.jpg" 
                map_type 0 
                interpolate 2 } }
      finish { ambient 0.5 }
      translate <-0.5,-0.5,0>
      scale 2*<fx,fy,0.5>
      translate fz*z
      scale back_dist
      OrientZ(CamLoc,CamLook,cam_s) }
// End of background image code.

light_source { <-10,30,10> color Gray30 }
light_source { <-10,30,10> color White }
light_source { <-10,30,-10> color White }
light_source { <0,10,-1000> color White }
light_source { <15,30,-10> color White }  

#declare bodyScale = 2; // Specifies size of the bug.  
#declare bodySegmentDist = bodyScale * .75; // Specifies distance between the centers of each body segment 

// Code to draw coordinate axes taken from Dr. Wainer's example.  Only used for
// some preliminary testing:

/*
// Make arrows to lie along the major axi

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
      object { stdSphere pigment { color MediumForestGreen } }      
      object { stdSphere 
         scale<.9,.9,.9>
         translate<0,0,.3>
         pigment { color MediumForestGreen }
      }
   }     
   object { stdSphere
      scale<.6,.6,.6>
      translate<-.15,0,.2>
      pigment { color Gray60 }
   }      
}

// Declare head object
#declare head = union {
        
   // Eyes
   object { eye
      scale<.8,.8,.8>
      rotate<0,-90,10>
      translate<-.9,.2,.6>   
   }   
   object { eye
      scale<.8,.8,.8>
      rotate<0,-90,10>
      translate<-.9,.2,-.6> 
   }   
      
   // Antennae
   object { stdCylinder 
      translate<0,.5,0>
      scale<.2,2,.2>
      rotate<20,0,30>
      pigment { color MediumForestGreen }
   }  
   object { stdCylinder
      translate<0,.5,0>
      scale<.2,2,.2>
      rotate<-20,0,30>
      pigment { color MediumForestGreen }
   }
   
   // Head 
   object { stdSphere scale <bodyScale,bodyScale,bodyScale> 
         pigment { color MediumForestGreen }
   }
}

// Declare worm object
#declare green_worm = union {    
     
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
      
   object { headless_worm 
      pigment { color MediumForestGreen }
   }
   object { headless_worm 
      rotate<0,180,0> 
      pigment { color MediumForestGreen }
   }
   object { stdSphere
      scale<bodyScale,bodyScale,bodyScale>
      translate<x_int+bodySegmentDist*.65,0,0>
      rotate<0,180,0>   
      pigment { color MediumForestGreen } 
   }
   object { head 
      rotate<0,180,0>
      translate<x_int+bodySegmentDist*.65,0,0> 
   } 
}

#declare party_cup = union {
   difference {
      cone {
         <0,0,0>, 3,
         <0,12,0>, 4.4
         pigment { color rgb<1,0,0> }
      }
      cone {
         <0,0.2,0>, 3,
         <0,12.2,0>, 4.4
         pigment { color rgb <1,1,1>}
      }
   }
}

#declare x_max = (bodySegmentDist*num_segments);
#declare green_worm_displacement = x_max*(anim_clock+current_loop);

union {
   object { green_worm
      translate<startingPos_x+green_worm_displacement,startingPos_y+bodyScale/2,0>
      rotate<0,0,96.5>
   }
   
   object { party_cup  
      translate <5,0,0>
      scale <1.8,1.8,1.8>
   }
   
   #if (clock > .4)
      translate <-3.5,0,0>
      
      #local cup_rotation = pow((clock-.4)*9.8,3.3);
      #if (cup_rotation >= 85)
         rotate <0,0,90>
      #else
         rotate <0,0,cup_rotation>
      #end
      
      translate <3.5,0,0>
   #end  
   
   // Temporary plane used as a reference in making appropriate camera adjustments.  
   /*
   object { stdCube
      scale<50,.1,50>
   }*/
}    
