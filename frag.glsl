struct Ball {
    vec3 pos;
    vec3 rgb;
    float r;
};

const int MAX_BALLS = 50;
const float threshold = 3.4;

uniform Ball balls[MAX_BALLS];
uniform int n_balls;

varying vec4 vertColor;

void main() {
    float total = 0;
    int idx = 0;
    float highest = 0;
    for(int i=0; i<n_balls; i++) {
	Ball b = balls[i];
	float dst = distance(b.pos.xy, gl_FragCoord.xy);
	float val = b.r / dst;
	total += val;
	if(val > highest) {
	    idx = i;
	    highest = val;
	}
    }
    if(total < threshold) {
    	gl_FragColor = vec4(vec3(1.0), 1.0);
    } else if(total < threshold + 0.05) {
    	gl_FragColor = vec4(vec3(0.0), 1.0);
    } else {
	gl_FragColor = vec4(balls[idx].rgb, 1.0);
    }

    // create dots in middle of ball
    float dot_rad = 4;
    for(int i=0; i<n_balls; i++) {
	if(distance(balls[i].pos.xy, gl_FragCoord.xy) < sqrt(dot_rad)) {
	    gl_FragColor = vec4(vec3(0.0), 1.0);
	}
    }
}
