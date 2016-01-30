/*
Prime II - Vincent Giles (2016) [for Weeklybeats 2016]
---
Panning - glitchy complex waveforms in a gesture panning from extremes to non-extremes, and vice versa. Or extremes to extremes.
Underpinning this will be a similar prime-number system of saw-tooth enveloped wave forms.
*/


s.boot;
s.quit;

(
// This is the one for panned fun times. This should be randomly assigned.
SynthDef.new(\wavePan, {
	arg sigPan=0.8, sigPan2=0.0, sigPanDur=2, vSawFreq=0.9, lfNoiseFreq=500, dens1=15, resFreq=80, envDur=4;
	var signal, pFreq, pWidth, pMul, pAdd, panner, panLine, dustglitch, env;
	env = EnvGen.kr(Env.new([0, 1, 0], [envDur, 0.1], \wel), doneAction:2);
	dustglitch = Dust2.ar(dens1, 0.7, 0);
	pFreq = 1000;
	pWidth = LFPar.ar(50, 0, 0.5, 0);
	pMul = VarSaw.ar(vSawFreq, 0.5, 0.5, 0.5, 0);
	pAdd = SinOsc.ar(LFNoise0.ar(lfNoiseFreq), 1, 0);
	signal = Mix.ar(Pulse.ar(pFreq, pWidth, pMul, dustglitch));
	signal = Resonz.ar(signal, resFreq, 1, 0.7, 0);
	panner = Pan2.ar(signal, Line.kr(sigPan, sigPan2, sigPanDur, 0.6, 0, doneAction:2), 0.5);
	Out.ar([0, 1], FreeVerb.ar(panner * env, 0.2, 0.3, 0.3, 0.5, 0));
	}
).add
)
a = {SinOsc.ar(150, 0, Line.ar(0, 1, 4, 0.5, 0, doneAction:2), 0)}.scope;
b = {LFCub.ar(150, 0, Line.ar(0, 1, 4, 0.5, 0, doneAction:2), 0)}.scope;

(
// This is the one for the saw-tooth enveloped wave form running on prime numbers (as duration).
// Prime numbers: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 29, 23, 19, 17, 13, 11, 7, 5, 3, 2.

SynthDef.new(\sawEnv, {
	arg sinFreq=100, resFreq=300, sigPan0=0.0, sigPan1=1.0, sigPanDur0=3;
	var signal, env, delay, pan;
	env = EnvGen.kr(Env.new([0, 0.8, 0], [4, 0.9], \sin), doneAction:2);
	signal = LFCub.ar(sinFreq, 0, 0.7, Dust.ar(XLine.kr(500, 2, sigPanDur0), 0.5));
	signal = Resonz.ar(signal, resFreq, 1, 0.7, 0);
	delay = CombC.ar(signal, 2.0, 0.8, 0.4, 0.8, 0);
	signal = Pan2.ar(signal, Line.ar(sigPan0, sigPan1, sigPanDur0, 0.6, 0, doneAction:2), 0.5);
	Out.ar([0, 1], FreeVerb.ar(signal * env + delay * env, 0.2, 0.3, 0.3, 0.5, 0));
	}
).add
)



/* SawEnv setup*/

(
// Variables and arrays
var primeNums, sinFreqs1, pans1, pans2, resonance1;
primeNums = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 29, 23, 19, 17, 13, 11, 7, 5, 3, 2];
pans1 = Array.rand(21, -1.0, 1.0);
pans2 = Array.rand(21, -1.0, 1.0);
sinFreqs1 = Array.rand(21, 100, 400);
resonance1 = Array.rand(21, 50, 900);


// Sequencing SawEnv
o = Pbind (
	\instrument, \sawEnv,
	\dur, Pseq(primeNums, 1, 0),
	\sigPan0, Pseq(pans1, 1, 0),
	\sigPan1, Pseq(pans2, 1, 0),
	\sigPanDur0, Pseq(primeNums, 1, 0),
	\sinFreq, Pseq(sinFreqs1, 1, 0),
	\resFreq, Pseq(resonance1, 1, 0),
)
)

/* SawEnv setup*/

(
// Variables and arrays
var primeNums, sinFreqs1, pans1, pans2, resonance1;
primeNums = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 29, 23, 19, 17, 13, 11, 7, 5, 3, 2];
pans1 = Array.rand(21, -1.0, 1.0);
pans2 = Array.rand(21, -1.0, 1.0);
sinFreqs1 = Array.rand(21, 100, 400);
resonance1 = Array.rand(21, 50, 900);


// Sequencing SawEnv
q = Pbind (
	\instrument, \sawEnv,
	\dur, Pseq(primeNums, 1, 0),
	\sigPan0, Pseq(pans1, 1, 0),
	\sigPan1, Pseq(pans2, 1, 0),
	\sigPanDur0, Pseq(primeNums, 1, 0),
	\sinFreq, Pseq(sinFreqs1, 1, 0),
	\resFreq, Pseq(resonance1, 1, 0),
)
)

/* wavePan setup*/
(
// Variables and Arrays
var randomDurs, randomRests, pseqDur, vSaw, pans3, pans4, lfFreq, density, res;

randomDurs = Array.rand(21, 2, 29);
randomRests = Array.rand(21, 2, 29);
pseqDur = randomDurs ++ randomRests;
pseqDur = pseqDur.scramble;
vSaw = Array.rand(21, 0.01, 2.04);
pans3 = Array.rand(21, -1.0, 1.0);
pans4 = Array.rand(21, -1.0, 1.0);
lfFreq = Array.rand(21, 50, 500);
density = Array.rand(21, 5, 400);
res = Array.rand(21, 5, 500);


// Sequencing
// NB: sigPan, sigPan2, sigPanDur, vSawFreq, lfNoiseFreq, dens1, resFreq, envDur;
p = Pbind (
	\instrument, \wavePan,
	\dur, Pseq(pseqDur, 1, 0),
	\envDur, Pseq(randomDurs, 1, 0),
	\sigPan, Pseq(pans3, 1, 0),
	\sigPan2, Pseq(pans4, 1, 0),
	\sigPanDur, Pseq(randomDurs, 1, 0),
	\vSawFreq, Pseq(vSaw, 1, 0),
	\lfNoiseFreq, Pseq(lfFreq, 1, 0),
	\dens1, Pseq(density, 1, 0),
	\resFreq, Pseq(res, 1, 0),
)
)
/* wavePan setup*/
(
// Variables and Arrays
var randomDurs, randomRests, pseqDur, vSaw, pans3, pans4, lfFreq, density, res;

randomDurs = Array.rand(21, 2, 29);
randomRests = Array.rand(21, 2, 29);
pseqDur = randomDurs ++ randomRests;
pseqDur = pseqDur.scramble;
vSaw = Array.rand(21, 0.01, 2.04);
pans3 = Array.rand(21, -1.0, 1.0).postln;
pans4 = Array.rand(21, -1.0, 1.0);
lfFreq = Array.rand(21, 50, 500);
density = Array.rand(21, 5, 400);
res = Array.rand(21, 5, 500);


// Sequencing
// NB: sigPan, sigPan2, sigPanDur, vSawFreq, lfNoiseFreq, dens1, resFreq, envDur;
r = Pbind (
	\instrument, \wavePan,
	\dur, Pseq(pseqDur, 1, 0),
	\envDur, Pseq(randomDurs, 1, 0),
	\sigPan, Pseq(pans3, 1, 0),
	\sigPan2, Pseq(pans4, 1, 0),
	\sigPanDur, Pseq(randomDurs, 1, 0),
	\vSawFreq, Pseq(vSaw, 1, 0),
	\lfNoiseFreq, Pseq(lfFreq, 1, 0),
	\dens1, Pseq(density, 1, 0),
	\resFreq, Pseq(res, 1, 0),
)
)


(
/* Call into existence multiple versions. You need to make sure the synthdefs are active along with all four pbinds before activating this.*/
o.play;
p.play;
q.play;
r.play;
)

s.makeGui;

//Testing the triggers
b = Synth.new(\sawEnv, [\sinFreq, 300, \resFreq, 700, \sigPan0, rrand(-1.0, 0.4), \sigPan1, rrand(-0.4, 1.0),\sigPanDur, rrand(2, 8)]);
a = Synth.new(\wavePan, [\resFreq, 240, \dens1, rrand(50, 300), \lfNoiseFreq, rrand(100, 800), \vSawFreq, rrand(0, 4), \sigPan, rrand(-1.0, 0.4), \sigPan2, rrand(-0.4, 1.0), \sigPanDur, rrand(2, 8), \envDur, 4]);



