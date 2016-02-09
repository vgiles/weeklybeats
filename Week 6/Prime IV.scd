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
			slideDur = exprand(20, 300), // duration of slide
			percRel = exprand(1.0, 8.0)
			|

			var signal, freqEnv, envelope; // freqEnv = frequency glide, envelope = envgen.

			freqEnv = EnvGen.ar(XLine(freq1, freq2, slideDur, 0.8), doneAction: 2);
			signal = {
				Saw.ar(baseFreq * SinOsc.ar(freqEnv, 0.5, 0.5, 0), 0, 0.5, 0);
			}
			envelope = EnvGen.ar(Env.perc(0.01, percRel, 0.8, -8), doneAction: 2);
			signal = Pan2.ar(signal, panPos1, 1);
			Out.ar([0, 1], signal * envelope);
		}
	)
)