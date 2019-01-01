//

diameter=30;

function pointlist(alpha1=360,beta1=360,deltaAlpha=45,deltaBeta=45,diameter=20) = [ 
    for (alpha=[0:deltaAlpha:alpha1])
        for (beta=[0:deltaBeta:beta1])
            point(alpha,beta,diameter=diameter)
];



function point(alpha,beta,diameter=20) = [
    cos(beta)*sin(alpha)*diameter,
    cos(beta)*cos(alpha)*diameter,
    sin(beta)*diameter
    ];
        
        

// hull()
    for ( point=pointlist(deltaAlpha=15,deltaBeta=15)){
      translate( point) cube(.5);
}
