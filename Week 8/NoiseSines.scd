/* SuperCollider Study #5 - Noise Is Quick And Dirty
Vincent Giles, 2016 - For WeeklyBeats 2016 */

s.boot;


SynthDef.new(\SineNoise1, {
	var sinSig, noiseSig, delay, panner1;
	noiseSig = LFNoise0.ar([0.1, 0.5, 1, 5], 400, 500);
	sinSig = SinOsc.ar(noiseSig, 0, 0.8, 0);
	delay = DelayC.ar(sinSig, 1.0, 0.5, 0.8, 0);
	panner1 = Pan2.ar(delay, SinOsc.kr(0.001, 0, 1, 0));
}).add

SynthDef.new(\SineNoise2, {
	var sinSig2, noiseSig2, delay2, panner2;
	noiseSig2 = LFNoise0.ar([0.8, 1.6, 5, 10], 400, 500);
	sinSig2 = SinOsc.ar(noiseSig, 0, 0.8, 0);
	delay2 = DelayC.ar(sinSig, 1.0, 0.5, 0.8, 0);
	panner12 = Pan2.ar(delay, SinOsc.kr(0.001, 0.5pi, 1, 0));
}).add

SynthDef.new(\SineNoise3, {
	var sinSig3, noiseSig3, delay3, panner3;
	noiseSig3 = LFNoise0.ar([0.8, 1.6, 5, 10], 400, 500);
	sinSig3 = SinOsc.ar(noiseSig, 0, 0.8, 0);
	delay3 = DelayC.ar(sinSig, 1.0, 0.5, 0.8, 0);
	panner3 = Pan2.ar(delay, SinOsc.kr(0.001, 0.5pi, 1, 0));
}).add

