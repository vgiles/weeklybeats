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
	Out.ar([0, 1], panner * env);
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
	Out.ar([0, 1], signal * env + delay * env);
	}
).add
)

(
// Variables and arrays
var primeNums, sinFreqs1, pans1, pans2, resonance1;
primeNums = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 29, 23, 19, 17, 13, 11, 7, 5, 3, 2];
pans1 = Array.fill(21, {rrand(-1.0, 0.5)});
pans2 = Array.fill(21, {rrand(1.0, -0.5)});
sinFreqs1 = Array.fill(21, {rrand(100, 400)});
resonance1 = Array.fill (21, {rrand(50, 900)});


// Sequencing
p = Pbind (
	\instrument, \sawEnv,
	\dur, Pseq(primeNums, 1, 0),
	\sigPan0, Pseq(pans1, 1, 0),
	\sigPan1, Pseq(pans2, 1, 0),
	\sigPanDur0, Pseq(primeNums, 1, 0),
	\sinFreq, Pseq(sinFreqs1, 1, 0),
	\resFreq, Pseq(resonance1, 1, 0),
)

q = Pbind (
	\instrument, \wavePan,







//Testing the triggers
b = Synth.new(\sawEnv, [\sinFreq, 300, \resFreq, 700, \sigPan0, rrand(-1.0, 0.4), \sigPan1, rrand(-0.4, 1.0),\sigPanDur, rrand(2, 8)]);
a = Synth.new(\wavePan, [\resFreq, 240, \dens1, rrand(50, 300), \lfNoiseFreq, rrand(100, 800), \vSawFreq, rrand(0, 4), \sigPan, rrand(-1.0, 0.4), \sigPan2, rrand(-0.4, 1.0), \sigPanDur, rrand(2, 8), \envDur, 4]);



