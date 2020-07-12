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
				~kickTrig = Bus.control(s, 1);
				~hatsTrig = Bus.control(s, 1);
				~snareTrig = Bus.control(s, 1);
				~globVerb = Bus.audio(s, 2);

				// assign dictionary of files into buffers
				d = Dictionary.new;
				d.add(\m -> PathName("/Users/vin/Dropbox/Composition/2020/Samples/all-samples/study/smp2").entries.collect({
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
					buf = LFNoise0.kr(noiseFreq2).range(0, 5).round(1);
					buf.postln;
					trig1 = Dust.kr(dens);
					trig2 = Dust2.kr(dens);
					start = LFNoise0.kr(noiseFreq3).range(0.01, BufFrames.kr(buf));
					vlnSig = BBandPass.ar(PlayBuf.ar(1, buf, BufRateScale.ir(buf) * rate, trig2, startPos: start, loop:1, doneAction:Done.freeSelf), filtFreq, filtQ, 1, 0);
					vlnSig = vlnSig * EnvGen.kr(Env.perc(atk, rel, amp), trig1,doneAction:Done.freeSelf);
					vlnSig = Pan2.ar(vlnSig, LFNoise1.kr(30));
					Out.ar(out, vlnSig);
				}).add;

				SynthDef.new(\kick,
					{
						// initialise variables and arguments
						arg amp = 0.5, filtFreq = 100, density = 0.8, curve = \sine, baseFreq = 50, filtLine = 1, in, out = 0;
						var kickSnd, filt, env, trig1, inCtrl;

						inCtrl = In.kr(in, 1);
						kickSnd = SineShaper.ar(LPF.ar(CrossoverDistortion.ar(LFDNoise0.ar(baseFreq, 1, SinOsc.ar(baseFreq/1.2, 0, 1, 0)), 0.5, 0.2, 1, 0), baseFreq*1.5, 1, 0), 0.6, 1.6, 0);
						trig1 = Dust2.kr(density, 1, 0); // redundant by input bus
						env = EnvGen.kr(Env.perc(0.001, 0.2, amp, curve), inCtrl, /*doneAction: Done.freeSelf*/);
						filt = BPF.ar(LPF.ar(kickSnd, filtFreq, 1.0, 0), 40, 1);
						kickSnd = CombC.ar(filt * env, 0.3, 0.2, 0.3, 1);
						Out.ar([0,1], kickSnd);
					}
				).add;

				SynthDef.new(\hat,
					{
						// initialise vars and args
						arg amp = 0.7, curve = \sin, in, out, panPos = 0.5, dens, hatFreq = 4500, envDec = 0.7;
						var hatSnd, filt, env, trig1, inCtrl;


						// the guts
						inCtrl = In.kr(in, 1);
						trig1 = Dust2.kr(dens, 1, 0);
						hatSnd = Disintegrator.ar(BPF.ar(PinkNoise.ar(1, 0), LFNoise0.kr(5).range(400, 5000), 0.2, 1, 0), 0.7, 0.7, 1.0, 0);
						env = EnvGen.kr(Env.perc(0.001, envDec, amp, curve), inCtrl, /*doneAction: Done.freeSelf*/);
						hatSnd = CombC.ar(hatSnd * env, 0.6, 0.3, 0.5, 1, 0);
						hatSnd = Pan2.ar(hatSnd, panPos, 0.5);
						Out.ar(out, hatSnd);
					}
				).add;

				// SynthDef.new(\snare,
				// 	{
				//


				SynthDef.new(\bweep,
					{
						arg out = ~globVerb;
						var sig, trig, env, lineVar, trig1;
						trig1 = Dust2.kr(LFNoise0.kr(LFNoise0.kr(1).range(0.1, 5)), 1, 0);
						trig = Convolution.ar(Crackle.ar(1.9, 1,0), Dust.ar(30, 1, 0), 256, 1, 0);
						sig = HPF.ar(SawDPW.ar(LFNoise0.kr(0.1).range(300, 2500), 0, 1, 0), LFNoise0.kr(0.1).range(300, 2500), 1.0) * trig;
						env = EnvGen.kr(Env.perc(0.01, 1, 1, \sin), trig1);
						//lineVar = Line.kr(LFNoise0.kr(0.5).range(0, 1), LFNoise0.kr(0.5).range(0, 3), 1, 0);
						sig = Pan2.ar(sig * env, LFNoise0.kr(LFNoise0.kr(3).range(0.1, 30)).range(-1, 1), 1);
						Out.ar(out, sig);
					}
				).add;

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

				SynthDef.new(\kTrig,
					{
						// set some args for control
						arg amp = 0.5, density = 1, out;
						var trig;
						trig = Dust2.kr(density, 1.0, 0);
						Out.kr(out, trig);
					}
				).add;

				SynthDef.new(\hTrig,
					{
						// set up the hat trigger synth
						arg amp = 0.5, dens = 1, out;
						var trig;
						trig = Dust2.kr(dens, 1.0, 0);
						Out.kr(out, trig);
					}
				).add;

				SynthDef.new(\verb, {
					arg in, out=0;
					var verbSig;
					verbSig = In.ar(in, 2);
					verbSig = FreeVerb.ar(verbSig, 0.5, 0.5, 0.1, 1, 0);
					Out.ar(out, verbSig);
				}).add;

				s.sync; // wait for everything to be loaded.

				~verb2 = Synth.new(\verb, [\in, ~globVerb]);
				~kick = Synth.new(\kick, [amp: 0.4, density: 1, filtFreq: 100, curve: \sin, filtLine: 1, in: ~kickTrig, baseFreq: 70]);
				~ktrig = Synth.new(\kTrig, [density: 1, amp: 0.5, out: ~kickTrig]); // this is replaced by pattern

				30.wait;
				~hat = Synth.new(\hat, [curve: \lin, dens: 4, in: ~hatTrig, \out, ~globVerb, \panPos, 0]);
				~htrig = Synth.new(\hTrig, [\dens, 5, \amp, 0.5, \out, ~hatTrig]); // replaced by pattern

				20.wait;
				~fweep = Synth.new(\bweep);

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
				300.wait;
				~kTrig.free;
				~hTrig.free;
				~kick.free;
				~hat.free;
				5.wait;
				~fweep.free;
				~verb2.free;
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