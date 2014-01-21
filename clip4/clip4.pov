/* CS 484 S11 - Final Lab - Mark Agne and Le Gao

   Extreme Close Up! Zooming in on a pleasantly surprised inchworm.  Antennae,
   smile, and camera zoom are all functions of the clock.  The background image
   is a blurry shot not originally intended for use, but placed here to trippy
   effect for our green worm who has just fallen from the party cup.  This darker
   background also serves as a transition to the black backgrounds in the final
   clips.   
*/ 

#include "colors.inc"
#include "stdPrim.inc"

// This is the beginning of the background image code. The template was found at:
// http://www.spiritone.com/~english/cyclopedia/background.html
#declare CamLook = <0,0,0>; // Camera's Look_at 
#declare CamLoc = <5,0,0>; //where the camera's location is
#declare cam_z = .3+(clock); //the amount of camera zoom
#declare back_dist = 63; // how far away the background image is
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
      pigment { image_map { jpeg "clipImage4.jpg" 
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

#declare bodyScale = 2; // Specifies size of the bug.          

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

// Declare mouth object
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
      #if (clock > .7) rotate <-((18/.7)*(clock-.7)),0,0> #end
   }  
   object { stdCylinder
      translate<0,.5,0>
      scale<.2,2,.2>
      rotate<-20,0,30>
      #if (clock > .7) rotate <(18/.7)*(clock-.7),0,0> #end
   }
   
   // Head 
   object { stdSphere scale <bodyScale,bodyScale,bodyScale> }
   
   #if (clock > .7)
      // Mouth
      intersection {
         // Mouth crescent shape
         object { mouth
            scale <1,.5+(clock-.7),.5+(clock-.7)>
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
   #end
}

object { head 
   rotate<0,180,0>
   pigment { color MediumForestGreen } 
} 
