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

(
	SynthDef.new( // high frequency "bell" like things.
		\slideBell,
		{
			|
			freq1 = 400, // starting frequency
			freq2 = 500, // destination frequency
			baseFreq1 = 200, // initial frequency
			panPos1 = 0.0, // pan position
			slideDur = 50, // duration of slide
			percRel = 3.0,
		    baseFreq = 500
			|

			var signal, freqEnv, envelope; // freqEnv = frequency glide, envelope = envgen.


		    freqEnv = Line.ar(freq1, freq2, slideDur, 0.8, doneAction: 2);
			envelope = EnvGen.ar(Env.perc(0.01, percRel, 0.8, -4), doneAction: 2);
			signal = SinOsc.ar(baseFreq1 * freqEnv, 0, 0.8, 0);
			signal = Pan2.ar(signal, panPos1, 0.8);
		    Out.ar([0, 1], signal * envelope);
		};
		).add
	)


(
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

			var noiseSig, filter, noiseEnv;

		noiseSig = Crackle.ar(SinOsc.kr(0.2, 0, 0.9, 1), SinOsc.kr(0.01, 0.5, 0.5, 0), Saw.ar(Crackle.kr(SinOsc.kr(1, 0, 0.8, 0), 0.3, 0));
			filter = BBandPass.ar(noiseSig, Line.kr(freq3, freq4, noiseDur, 0.8, doneAction: 2));
			noiseEnv = EnvGen.ar(Env.perc(percAtk, percDur, 0.9, -4), doneAction: 2); // percussion sound
			Out.ar([0, 1], filter * noiseEnv);
		};
		).add
	)

x = Synth.new(\funNoise, [\percAtk, rrand(0.1, 2.0), \percDur, rrand(2, 5), \freq3, exprand(60, 1000), \freq4, exprand(60, 2000)]);
t = Synth.new(\slideBell, [\freq1, exprand(400, 1000), \freq2, exprand(400, 1000), \baseFreq1, exprand(600, 2000), \slideDur, rrand(1.0, 5.0), \percRel, exprand(1.0, 4.0)]);




