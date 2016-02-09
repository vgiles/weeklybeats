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
	SynthDef.new(
		\slideBell,
		{
			|
			freq1 = 400,
			freq2 = 500,
			panPos1 = 0.0,
			slideDur = lrand(20, 300)
			|

			var signal, envelope1;



		}
	)
)