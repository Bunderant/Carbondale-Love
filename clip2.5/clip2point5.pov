/* CS 484 S11 - Final Lab - Mark Agne and Le Gao

   Damsel in distress!   
*/  

#include "colors.inc"
#include "stdPrim.inc"

// This is the beginning of the background image code. The template was found at:
// http://www.spiritone.com/~english/cyclopedia/background.html
#declare CamLook = <0,0,0>; // Camera's Look_at 
#declare CamLoc = <5,25,0>; //where the camera's location is
#declare cam_z = 1.0; //the amount of camera zoom
#declare back_dist = 1000; // how far away the background image is
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
      pigment { image_map { jpeg "clipImage2point5.jpg" 
                map_type 0 
                interpolate 2 } }
      finish { ambient 0.5 }
      translate <-0.5,-0.5,0>
      scale 2*<fx,fy,0.5>
      translate fz*z
      scale back_dist
      OrientZ(CamLoc,CamLook,cam_s) }
// End of background image code.

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
      }
   }     
   object { stdSphere
      scale<.6,.6,.6>
      translate<-.15,0,.2>
      pigment { color Gray60 }
   }      
}

// Declare mouth object
#declare mouth = intersection {
   difference {
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
         translate <0,-.5,0>
         pigment { color Black }
      }
      
      // Sculpt outside edge to be consistent with the head shape   
      object { stdSphere
         scale <bodyScale*1.05,bodyScale*1.05,bodyScale*1.05>
         pigment { color Black }
      }
   }
}

#declare purple_worm = union {    
   // Head 
   object { head 
      rotate <0,0,-clock*80>
      pigment { color Orchid } 
   }
    
   // Body
   #declare index = 1;
   #while (index <= 6) 
      object { stdSphere scale <bodyScale,bodyScale,bodyScale>
         translate<(bodySegmentDist*.8)*index,0,0>
         rotate<0,9*index,0> 
         pigment { color Orchid }
      } 
      #declare index = index + 1;
   #end   
}

object { purple_worm
   rotate <0,180,0>  
   translate <-2,0,-5>
}    
