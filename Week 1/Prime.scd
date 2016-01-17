/* What I want to do:
1. Long periods of blocked noise. |||||||||||||| (sequence decided by prime numbers up and down, 2, 3, 5, 7, 11, 13, 17, 19, 23, 19, 17, 13, 11, 7, 5, 3, 2.
2. Pauses between noise blocks: the same prime number sequence
3. This happens on top of a bed of "jittery" noise.
4. Piece is finished after the final two second pause (5.9minutes)
-- Then I need to record the whole thing. Easy!
*/

s.boot;
s.kill;

v = Array.fill(19, {Rand(400, 800).collect;});
v.postln;

// Synthesis Definitions
// Blippy Fun

(
SynthDef.new(\synthBed, {
	arg freq1=500, freq2=552, freq3=900, freq4=1274, dens1=45, time=2;
	var signal1, env2;
	env2 = EnvGen.kr(Env.new([0, 1, 1, 0], [0.1, time, 0.1]), doneAction:2);
	signal1 = Mix.ar(SinOsc.ar([freq1, freq2, freq3, freq4], 0, Dust2.kr(dens1, 0.8), 0));
	signal1 = FreeVerb.ar(signal1, 0.2, 0.3, 0.3, 0.8, 0);
	Out.ar([0, 1], signal1 * env2);
	};
).add
)
// Noise Wall
(
SynthDef.new(\NoiseWall, {
	arg cutoff=600, resonance=0.8, time1=2;
	var signal, env;
	env = EnvGen.kr(Env.new([0, 1, 1, 0], [0.1, time1, 0.1]), doneAction:2);
	signal = Resonz.ar(PinkNoise.ar(10), cutoff, resonance);
	signal = FreeVerb.ar(signal, 0.4, 0.8, 0.9, 1, 0);
	Out.ar([0, 1], signal * env);
	};
).add
)

// Performative/Sequencing Stuff
// To add the performative timing things, \time and \time1 need to be given new arguments each loop.


x = Synth.new(\synthBed, [\dens1, rrand(15, 50), \freq1, rrand(200, 1200), \freq2, rrand(300, 1000), \freq3, rrand(240, 2500), \freq4, rrand(1000, 6000), \time, 2]);
y = Synth.new(\NoiseWall, [\cutoff, rrand(340, 900), \resonance, rrand(0.3, 2.4), \time1, 2]);


(
// Let's make some arrays.
var densRand, freq1Rand, freq2Rand, freq3Rand, freq4Rand, cutRand, resRand;
densRand = Array.fill(19, { rrand(15, 50) });
freq1Rand = Array.fill(19, { rrand(200, 1200) });
freq2Rand = Array.fill(19, { rrand(300, 1000) });
freq3Rand = Array.fill(19, { rrand(240, 2500) });
freq4Rand = Array.fill(19, { rrand(1000, 6000) });
cutRand = Array.fill(19, { rrand(340, 900) });
resRand = Array.fill(19, { rrand(0.3, 2.4) });


// The actual triggering system
p = Pbind (
	\instrument, \synthBed,
	\dur, Pseq([2, Rest(2), 3, Rest(3), 5, Rest(5), 7, Rest(7), 9, Rest(9), 11, Rest(11), 13, Rest(13), 17, Rest(17), 19, Rest(19), 23, Rest(23), 19, Rest(19), 17, Rest(17), 13, Rest(13), 11, Rest(11), 7, Rest(7), 5, Rest(5), 3, Rest(3), 2, Rest(2)], 1),
	\time, Pseq([2, Rest(2), 3, Rest(3), 5, Rest(5), 7, Rest(7), 9, Rest(9), 11, Rest(11), 13, Rest(13), 17, Rest(17), 19, Rest(19), 23, Rest(23), 19, Rest(19), 17, Rest(17), 13, Rest(13), 11, Rest(11), 7, Rest(7), 5, Rest(5), 3, Rest(3), 2, Rest(2)], 1),
	\dens1, Pseq(densRand, 1),
	\freq1, Pseq(freq1Rand, 1),
	\freq2, Pseq(freq2Rand, 1),
	\freq3, Pseq(freq3Rand, 1),
	\freq4, Pseq(freq4Rand, 1),
).play;
q = Pbind (
	\instrument, \NoiseWall,
	\dur, Pseq([Rest(2), 2, Rest(3), 3, Rest(5), 5, Rest(7), 7, Rest(9), 9, Rest(11), 11, Rest(13), 13, Rest(17), 17, Rest(19), 19, Rest(23), 23, Rest(19), 19, Rest(17), 17, Rest(13), 13, Rest(11), 11, Rest(7), 7, Rest(5), 5, Rest(3), 3, Rest(2), 2], 1),
	\time1, Pseq([Rest(2), 2, Rest(3), 3, Rest(5), 5, Rest(7), 7, Rest(9), 9, Rest(11), 11, Rest(13), 13, Rest(17), 17, Rest(19), 19, Rest(23), 23, Rest(19), 19, Rest(17), 17, Rest(13), 13, Rest(11), 11, Rest(7), 7, Rest(5), 5, Rest(3), 3, Rest(2), 2], 1),
	\cutoff, Pseq(cutRand, 1),
	\resonance, Pseq(resRand, 1),
).play;
)
p.stop;
q.stop;
s.makeGui;


// Here is the piece scheduled

x = Synth.new(\synthBed, [\dens1, rrand(15, 50), \freq1, rrand(200, 1200), \freq2, rrand(300, 1000), \freq3, rrand(240, 2500), \freq4, rrand(1000, 6000), \time, 2]);

y = Synth.new(\NoiseWall, [\cutoff, rrand(340, 900), \resonance, rrand(0.3, 2.4), \time, 2]);



/*
In here I will want to iterate over the list of integers, changing the time arguments each time.*/






