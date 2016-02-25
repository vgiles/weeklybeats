/* SuperCollider Study #5 - Chorale #1
Vincent Giles, 2016 - For WeeklyBeats 2016 */

(


s.options.memSize = 65536;


s.boot;
//s.quit;
s.makeGui;

s.waitForBoot(

	{
		var mastersequence, sin1, sin2, sin3;

		Task({
			(
			SynthDef.new(\SineNoise1, {
				var sinSig, noiseSig, delay, panner1, output1, env1;
				noiseSig = LFNoise0.ar([0.1, 0.5], 400, 500);
					sinSig = SinOsc.ar(noiseSig, 0, SinOsc.ar(0.01, 0, 0.5, 1), 0);
				delay = DelayC.ar(sinSig, 1.0, 0.5, 0.2, 0);
				env1 = EnvGen.ar(Env([0.0, 1.0, 0.0], [3, 45], \lin), doneAction:2);
				panner1 = Pan2.ar(delay * env1, SinOsc.kr(0.02, 0, 1, 0), 0.1);
				output1 = Out.ar(0, panner1 + delay * 0.3);
			}).add;

			SynthDef.new(\SineNoise2, {
				var sinSig2, noiseSig2, delay2, panner2, output2, env2;
				noiseSig2 = LFNoise0.ar([0.01, 0.5], 400, 500);
					sinSig2 = SinOsc.ar(noiseSig2, 0, SinOsc.ar(0.2, 0, 0.5, 1), 0);
				delay2 = DelayC.ar(sinSig2, 20, 0.5, 0.2, 0);
				env2 = EnvGen.ar(Env([0.0, 1.0, 0.0], [5, 65], \lin), doneAction:2);
				panner2 = Pan2.ar(delay2 * env2, SinOsc.kr(0.02, 0, 1, 0), 0.1);
				output2 = Out.ar(0, panner2 + delay2 * 0.3);
			}).add;

			SynthDef.new(\SineNoise3, {
				var sinSig3, noiseSig3, delay3, panner3, output3, env3;
				noiseSig3 = LFNoise0.ar([1.6, 0.8], 400, 500);
				sinSig3 = SinOsc.ar(noiseSig3, 0, SinOsc.ar(20, 0, 0.5, 1), 0);
				delay3 = DelayC.ar(sinSig3, 1.0, 0.5, 0.2, 0);
				env3 = EnvGen.ar(Env([0.0, 1.0, 0.0], [5, 30], \lin), doneAction:2);
				panner3 = Pan2.ar(delay3 * env3, SinOsc.kr(0.02, 0, 1, 0), 0.1);
				output3 = Out.ar(0, panner3 + delay3 * 0.3);
			}).add;


			s.sync;

			s.queryAllNodes;


			mastersequence = Task({
				2.0.wait;

				Synth.new(\SineNoise1);

				5.0.wait;

				Synth.new(\SineNoise2);

				10.0.wait;

				Synth.new(\SineNoise3);

				40.0.wait;

				Synth.new(\SineNoise1);

				20.0.wait;

				Synth.new(\SineNoise2);

				50.0.wait;

				Synth.new(\SineNoise3);

				50.0.wait;

				Synth.new(\SineNoise2);

				20.0.wait;

				Synth.new(\SineNoise1);

				60.0.wait;

				mastersequence.stop;

			});

			1.0.wait;

			mastersequence.start;

			)
			}

		).start;




	}
)
)



// x = Synth(\SineNoise1);
// y = Synth(\SineNoise2);
// z = Synth(\SineNoise3);
//
// (
// x.play;
// y.play;
// z.play;
// )
//
// s.freeAll;
// s.quit;




