/*
Prime IV - Vincent Giles (2016) [For WeeklyBeats2016]
****
This piece will use prime number series as the frequency envelopes for a series of additive synthetic percussive sounds.
Additionally, these synthetic percussive sounds will be interjected with a noise, which again uses the prime number series to modify
a frequency cutoff.
****
Sequencing will be based upon prime numbers again.
****
This will be the final in the series of prime number SuperCollider studies.
*/

s.boot;
s.makeGui;

s.waitForBoot(
	{
		// set global variables (for pbinds etc)
		var masterSequence, bellrhy, noiserhy, length, rhythm1, bellrhy2;
		length = [71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499];
		rhythm1 = Array.fill(rrand(5, 100), {
			length.choose / 1000.0};
		);
		bellrhy = rhythm1.scramble;
		bellrhy2 = bellrhy.scramble;
		noiserhy = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 37, 31, 29, 23, 19, 17, 13, 11, 7, 5, 3, 2];


		Task {


(
	SynthDef.new( // high frequency "bell" like things.
		\slideBell,
		{

			|
			freq1 = 400, // starting frequency
			freq2 = 500, // destination frequency
			baseFreq1 = 200, // initial frequency
			panPos1 = 0.0, // pan position
			slideDur = 250, // duration of slide
			percRel = 15,
		    baseFreq = 500
			|

			var signal, freqEnv, envelope, sig2; // local def variables


		freqEnv = XLine.kr(freq1, freq2, slideDur, 0.8, doneAction: 2);
		signal = SinOsc.ar(baseFreq1 * freqEnv, 0, 0.8, SinOsc.ar(freqEnv, 0.5, 0));
			envelope = EnvGen.kr(Env.perc(0.001, percRel, 1, -4), doneAction: 2);
		signal = FreeVerb.ar(signal, 0.6, 0.2, 0.2, 0.8, 0);
			sig2 = Pan2.ar(signal, panPos1, 1);
		    Out.ar([0, 1], sig2 * envelope);
		};
		).add




	SynthDef.new(
		\funNoise, // low frequency thing
		{
			|
			freq3 = 50, // use prime number pairs for frequency cutoff
			freq4 = 55, // second of the prime number pairs
			noiseDur = 12,
			panPos2 = 0.0,
			percDur = 7,
			percAtk = 0.9
			|

			var noiseSig, filter, noiseEnv; // local variables

		noiseSig = Crackle.ar(SinOsc.kr(0.2, 0, 0.9, 1), SinOsc.kr(0.01, 0.5, 0.5, 0), Saw.ar(Crackle.kr(SinOsc.kr(1, 0, 0.8, 0), 0.3, 0));
			filter = BBandPass.ar(noiseSig, Line.kr(freq3, freq4, noiseDur, 0.8, doneAction: 2));
			noiseEnv = EnvGen.ar(Env.perc(percAtk, percDur, 0.9, -4), doneAction: 2); // percussion sound
			Out.ar([0, 1], filter * noiseEnv);
		};
		).add

	// Here are the Pbinds
					~sweepbell = Pbind (
						\instrument, \sweepBell,
						\dur, Pseq(bellrhy, 3, 0),
						\baseFreq, rrand(30, 300),
						\baseFreq1, Pdefn(\bellBaseF1, rrand(40, 200)),
						\freq1, Pdefn(\modFreq1, rrand(100, 500)),
						\freq2, Pdefn(\modFreq2, rrand(200, 700)),
						\panPos1, Pdefn(\bellPan, exprand(-1.0, 1.0)),
						\slideDur, Pdefn(\bellSlide, rrand(0.1, 2.0)),
						\percRel, Pseq(bellrhy2), 3, 0),
				);

				~noise = Pbind (
					\instrument, \funNoise,
					\freq3, Pdefn(\noiseFreq1, rrand(100, 600)),
					\freq4, Pdefn(\noiseFreq2, rrand(100, 1000)),
					\noiseDur, Pseq(noiserhy, 1, 0),
					\percDur, Pseq(noiserhy, 1, 0),
					\percAtk, Pdefn(\percAtk, rrand(0.1, 2.0)),
				);
				s.sync;
				// 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 37, 31, 29, 23, 19, 17, 13, 11, 7, 5, 3, 2
				masterSequence = Task({
					0.1.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					2.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					2.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					3.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					3.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					5.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					5.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					7.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					7.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					11.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					11.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					13.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					13.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					17.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					17.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					19.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					19.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					23.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					23.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					29.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					29.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					31.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					31.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					37.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					37.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					41.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					41.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					37.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					37.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					31.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					31.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					29.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					29.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					21.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					21.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;

					19.wait;
					Pdefn(\noiseFreq1, rrand(100, 600));
					Pdefn(\noiseFreq2, rrand(100, 1000));
					Pdefn(\percAtk, rrand(0.1, 2.0));
					~noise.play;

					19.wait;
					Pdefn(\bellBaseF1, rrand(40, 200));
					Pdefn(\modFreq1, rrand(100, 500));
					Pdefn(\modFreq2, rrand(200, 700));
					Pdefn(\bellPan, exprand(-1.0, 1.0));
					Pdefn(\bellSlide, rrand(0.1, 2.0));
					~sweepbell.play;







/*x = Synth.new(\funNoise, [\percAtk, rrand(0.1, 2.0), \percDur, rrand(2, 5), \freq3, exprand(60, 1000), \freq4, exprand(60, 2000)]);
t = Synth.new(\slideBell, [\freq1, exprand(20, 150), \freq2, exprand(50, 400), \baseFreq1, exprand(600, 2000), \slideDur, rrand(40, 200), \percRel, rrand(0.2, 2.0), \panPos1, rrand(-1.0, 1.0)]);*/






