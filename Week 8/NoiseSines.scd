/* SuperCollider Study #5 - Chorale #1
Vincent Giles, 2016 - For WeeklyBeats 2016 */

s.boot;
s.options.memSize = 65536;

(

//s.quit;
s.makeGui;
);
s.waitForBoot(

	{
		var mastersequence, sin1, sin2, sin3;

		Task({

			SynthDef.new(\SineNoise1, {
				var sinSig, noiseSig, delay, panner1, output1, env1;
				noiseSig = LFNoise0.ar([0.1, 0.5], 400, 500);
				sinSig = SinOsc.ar(noiseSig, 0, 0.5, 0);
				delay = DelayC.ar(sinSig, 1.0, 0.5, 0.5, 0);
				panner1 = Pan2.ar(delay, 1.0, 0.5);
				env1 = EnvGen.ar(Env.new([0, 1, 0], [3, 45], curve:\exponential), doneAction:2);
				output1 = Out.ar([0, 1], (panner1 * env1) + (delay * panner1));
			}).add; 

			SynthDef.new(\SineNoise2, {
				var sinSig2, noiseSig2, delay2, panner2, output2, env2;
				noiseSig2 = LFNoise0.ar([5, 10], 400, 500);
				sinSig2 = SinOsc.ar(noiseSig2, 0, 0.5, 0);
				delay2 = DelayC.ar(sinSig2, 20, 0.5, 0.5, 0);
				env2 = EnvGen.ar(Env.new([0, 1, 0], [10, 65], curve:\sine), doneAction:2);
				panner2 = Pan2.ar(delay2, -1.0, 0.5);
				output2 = Out.ar([0, 1], (panner2 * env2) + (delay2 * panner2));
			}).add;

			SynthDef.new(\SineNoise3, {
				var sinSig3, noiseSig3, delay3, panner3, output3, env3;
				noiseSig3 = LFNoise0.ar([1.6, 5], 400, 500);
				sinSig3 = SinOsc.ar(noiseSig3, 0, 0.5, 0);
				delay3 = DelayC.ar(sinSig3, 1.0, 0.5, 0.5, 0);
				env3 = EnvGen.ar(Env.new([0, 1, 0], [2, 30], curve:\linear), doneAction:2);
				panner3 = Pan2.ar(delay3, 0.0, 0.5);
				output3 = Out.ar([0, 1], (panner3 * env3) + (delay3 * panner3));
			}).add;


			s.sync;

			sin1 = Synth.new(\SineNoise1);
			sin2 = Synth.new(\SineNoise2);
			sin3 = Synth.new(\SineNoise3);

			s.queryAllNodes;

			mastersequence = Task({
				0.1.wait;

				sin1 = Synth(\SineNoise1);

				5.0.wait;

				sin2 = Synth(\SineNoise2);

				10.0.wait;

				sin3 = Synth(\SineNoise3);

				40.0.wait;

				sin1 = Synth(\SineNoise1);

				20.0.wait;

				sin2 = Synth(\SineNoise2);

				30.0.wait;

				sin3 = Synth(\SineNoise3);

				50.0.wait;

				sin2 = Synth(\SineNoise2);

				20.0.wait;

				sin1 = Synth(\SineNoise1);

				5.wait;

				mastersequence.stop;

			});

			1.0.wait;

			mastersequence.start;

			}
		).start;




	}
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




