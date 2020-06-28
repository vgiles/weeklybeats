(
s.boot; // boots server

s.makeGui;

s.plotTree;

s.meter;

s.waitForBoot(
	{
		// set global variables for task management
		var parentSequence;
		// define synth def creation task

		Task {
			(
				// assign effect audio busses
				~vlnVerb = Bus.audio(s, 2);
				~vlnDelay = Bus.audio(s, 2);

				// assign dictionary of files into buffers
				d = Dictionary.new;
				d.add(\m -> PathName("/Users/vin/Dropbox/Composition/2020/Samples/all-samples/study/smp").entries.collect({
					arg sf;
					Buffer.read(s, sf.fullPath);
				});
				);

				// setup synth defs.
				// create the main buffer sample playback engine called vln
				SynthDef.new(\vln, {
					arg out, filtFreq, filtQ, noiseFreq1, noiseFreq2, noiseFreq3, noiseFreq4;
					var vlnSig, trig1, trig2, rate, amp, atk, rel, start, buf, dens;
					rate = LFNoise0.kr(noiseFreq1).range(0.2, 3);
					atk = LFNoise0.kr(noiseFreq2).range(0.001, 1.4);
					rel = LFNoise0.kr(noiseFreq3).range(0.001, 1.4);
					amp = LFNoise0.kr(noiseFreq4).range(0.01, 0.8);
					dens = LFNoise1.kr(noiseFreq1).range(0.2, 2);
					buf = LFNoise0.kr(noiseFreq2).range(0, 20).round(1);
					buf.postln;
					trig1 = Dust.kr(dens);
					trig2 = Dust2.kr(dens);
					start = LFNoise0.kr(noiseFreq3).range(0.01, BufFrames.kr(buf));
					vlnSig = BBandPass.ar(PlayBuf.ar(1, buf, BufRateScale.ir(buf) * rate, trig2, startPos: start, loop:1, doneAction:Done.freeSelf), filtFreq, filtQ, 1, 0);
					vlnSig = vlnSig * EnvGen.kr(Env.perc(atk, rel, amp), trig1,doneAction:Done.freeSelf);
					vlnSig = Pan2.ar(vlnSig, LFNoise1.kr(30));
					Out.ar(out, vlnSig);
				}).add;

				// create reverb effect
				SynthDef.new(\verb, {
					arg in, out=0;
					var verbSig;
					verbSig = In.ar(in, 2);
					verbSig = FreeVerb.ar(verbSig, 0.5, 0.8, 0.2);
					Out.ar(out, verbSig);
				}).add;

				// create delay effect
				SynthDef.new(\dly, {
					arg in, out=0, dtime, dktime;
					var dlySig;
					dlySig = In.ar(in, 2);
					dlySig = CombC.ar(dlySig, 1.2, dtime, dktime, 0.5, 0);
					Out.ar(out, dlySig);
				}).add;

				s.sync; // wait for everything to be loaded.

				parentSequence = Task(
					{
						{
							var structNum = 1, waitNum = 5;
							structNum = exprand(1, 12);
							waitNum = exprand(1, 6);
							0.1.wait;
							~verb = Synth.new(\verb, [\in, ~vlnVerb]);
							0.1.wait;
							~delay = Synth.new(\dly, [\in, ~vlnDelay, \out, ~vlnVerb]);
							0.1.wait;
							structNum.do{
								~instrument = Synth.new(\vln, [\out, ~vlnDelay, \dtime, exprand(0.1, 1.1), \dktime, exprand(0.1,1.1), \filtFreq, exprand(50, 1200), \filtQ, exprand(3, 50), \noiseFreq1, exprand(0.1,20), \noiseFreq2, exprand(0.1,20), \noiseFreq3, exprand(0.1,20), \noiseFreq4, exprand(0.1,20)]);
							};
							waitNum.wait;
							8.wait;
							/*~instrument.free;*/
							~delay.free;
							~verb.free;
						}.loop;

					}

				);
				1.wait;
				parentSequence.start;
				360.wait;
				parentSequence.stop;
			)
		}.start;
	}
)
)

s.quit; // quits server
s.plotTree; // plots node trees
s.meter; // shows channel/bus meters
s.reboot;
s.freeAll;