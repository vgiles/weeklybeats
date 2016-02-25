/* SuperCollider Study #5 - Noise Is Quick And Dirty
Vincent Giles, 2016 - For WeeklyBeats 2016 */

s.boot;
s.options.memSize = 65536;
s.quit;

(
SynthDef.new(\SineNoise1, {
	var sinSig, noiseSig, delay, panner1, output1, env1;
	noiseSig = LFNoise0.ar([0.1, 0.5, 1, 5], 400, 500);
	sinSig = SinOsc.ar(noiseSig, 0, 0.8, 0);
	delay = DelayC.ar(sinSig, 1.0, 0.5, 0.8, 0);
	panner1 = Pan2.ar(delay, 1.0, 0.8);
	env1 = EnvGen.ar(Env.new([0, 1, 0], [3, 45], \lin), doneAction:2);
	output1 = Out.ar(out, delay * env1 + delay);
}).add
)
(
SynthDef.new(\SineNoise2, {
	var sinSig2, noiseSig2, delay2, panner2, output2, env2;
	noiseSig2 = LFNoise0.ar([0.8, 1.6, 5, 10], 400, 500);
	sinSig2 = SinOsc.ar(noiseSig2, 0, 0.8, 0);
	delay2 = DelayC.ar(sinSig2, 20, 0.5, 0.8, 0);
	env2 = EnvGen.ar(Env.new([0, 1, 0], [10, 65], \sine), doneAction:2);
	panner2 = Pan2.ar(delay2, -1.0, 0.8);
	output2 = Out.ar(out, delay2 * env2 + delay2);
}).add
)
(
SynthDef.new(\SineNoise3, {
	var sinSig3, noiseSig3, delay3, panner3, output3, env3;
	noiseSig3 = LFNoise0.ar([0.8, 1.6, 5, 10], 400, 500);
	sinSig3 = SinOsc.ar(noiseSig3, 0, 0.8, 0);
	delay3 = DelayC.ar(sinSig3, 1.0, 0.5, 0.8, 0);
	env3 = EnvGen.ar(Env.new([0, 1, 0], [2, 30], \exponential), doneAction:2);
	panner3 = Pan2.ar(delay3, 0.0, 0.8);
	output3 = Out.ar(out, delay3 * env3 + delay3);
}).add
)

x = Synth.new(\SineNoise1);
y = Synth.new(\SineNoise2);
z = Synth.new(\SineNoise3);

(
x.play;
y.play;
z.play;
)

s.freeAll;


