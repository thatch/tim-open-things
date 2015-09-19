linear_extrude(2) for(x=[1:10]) {
    polygon([[x,0],[x+1,0],[x+1,x+1],[x,x+0.1]]);
}