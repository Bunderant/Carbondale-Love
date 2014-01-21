/* CS 484 S11 - Final Lab - Mark Agne and Le Gao

   Roll credits:  
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
      pigment { image_map { png "clipImage7.png" 
                map_type 0 
                interpolate 2 } }
      finish { ambient 0.5 }
      translate <-0.5,-0.5,0>
      scale 2*<fx,fy,0.5>
      translate fz*z
      scale back_dist
      OrientZ(CamLoc,CamLook,cam_s) }
// End of background image code.