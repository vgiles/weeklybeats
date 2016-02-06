/*
Prime III - Vincent Giles (2016) [Weeklybeats 2016]
--
71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499
--
Use these values as a set of rhythms to be randomised to create "grain-like" rhythmic patterns.
--
Use lower values for longer durations (ie. 'larger numbers = shorter durations, lower numbers = larger durations')
"percussion" sounds.
*/


// Select all (cmd-a) and execute (cmd-return) for the piece to work.

s.boot;

s.makeGui;



s.waitForBoot(
	{ // Add this last to control the piece.

		var masterSequence, length, rhy1, rhy2, lowLen, rhy3; // Set master variables
		length = [71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499];
		rhy1 = Array.fill(rrand(5, 100), {
			length.choose / 1000.0};
		);
		rhy2 = rhy1.scramble;
		rhy2.postln;
		lowLen = [2, 3, 5, 7, 11, 13, 17];
		rhy3 = lowLen.scramble;

		Task { // Load Synth Defs

			/* bell synth definition */
			(
				SynthDef.new(
					\bell, {
						| // Arguments
						baseFreq = 1000,
						amp = 0.7,
						percLen = 0.4,
						freqMod = 0.3,
						sinMul = 500,
						panPos = 0.0,
						oscs = 4
						|

						var signal, envelope;

						envelope = EnvGen.kr(Env.perc(0.001, percLen, amp, -8), doneAction: 2);
						oscs.do {
							signal = SinOsc.ar(baseFreq * freqMod, 0, SinOsc.ar(freqMod * sinMul, 0, 0.2, 0), 0)
						};
						// signal = CombC.(signal, 0.5, 0.4, 0.8, 1, 0); // replace with effect if desired
						signal = Pan2.ar(signal, panPos, 1);
						Out.ar([0, 1], signal * envelope);
					}
				).add;


				/* Low Bell Definition */

				SynthDef.new(
					\lowBell, {
						| // Arguments
						baseFreq = 300,
						amp = 0.7,
						percLen = 5,
						freqMod = 0.8,
						sinMul = 0.7,
						oscs = 4
						|

						var signal, envelope;

						envelope = EnvGen.kr(Env.perc(3, percLen, amp, -8), doneAction: 2);
						oscs.do {
							signal = SinOsc.ar(baseFreq * freqMod, 0, SinOsc.ar(freqMod * sinMul, 0, 0.2, 0), 0)
						};
						signal = Resonz.ar(signal, 110, 1, 1, 0);
						signal = Pan2.ar(signal, 0, 1);
						Out.ar([0, 1], signal * envelope);
					}
				).add;



				// Pbind/setup for bell

				~percussion = Pbind (
					\instrument, \bell,
					\dur, Pseq(rhy1, 2, 0), // rhy1 needs to be an array of durations
					\percLen, Pseq(rhy1, 2, 0),
					\amp, 0.8,
					\freqMod, Pdefn(\bellFreqMod, rrand(0.5, 9.0)),
					\sinMul, Pdefn(\bellsinMul, rrand(0.2, 50.0)),
					\panPos, Pdefn(\bellpanPos, rrand(-1.0, 1.0)),
					\oscs, rrand(4, 12)
				);

				~lowSwell = Pbind (
					\instrument, \lowBell,
					\dur, Pseq(rhy3, 2, 0),
					\percLen, Pdefn(\swellpercLen, rrand(1.0, 5.0)),
					\amp, 0.8,
					\freqMod, Pdefn(\swellFreqMod, rrand(0.5, 1.3)),
					\sinMul, Pdefn(\swellsinMul, rrand(0.2, 50.0)),
					\oscs, rrand(4, 12)
				);




				s.sync; // wait for everything to be loaded.

				masterSequence = Task({

					// 2, 3, 5, 7, 11, 7, 5, 3, 2  -- Prime Number Series for Form of bells
					// 5, 7, 11, 13 -- Prime Number Series for Form of Low Swells
					0.1.wait;

					// Dynamic activation of low resonant bell
					Pdefn(\swellFreqMod, rrand(0.5, 1.3));
					Pdefn(\swellsinMul, rrand(0.2, 50.0));
					Pdefn(\swellpercLen, rrand(1.0, 5.0));
					~lowSwell.play;

					2.wait;

					// Percussion

					Pdefn(\bellFreqMod, rrand(0.5, 9.0));
					Pdefn(\bellsinMul, rrand(0.2, 50.0));
					Pdefn(\bellpanPos, rrand(-1.0, 1.0));
					~percussion.play;


					3.wait; // 5

					// Percussion

					Pdefn(\bellFreqMod, rrand(0.5, 9.0));
					Pdefn(\bellsinMul, rrand(0.2, 50.0));
					Pdefn(\bellpanPos, rrand(-1.0, 1.0));
					~percussion.play;

					// Low Swell

					Pdefn(\swellFreqMod, rrand(0.5, 1.3));
					Pdefn(\swellsinMul, rrand(0.2, 50.0));
					Pdefn(\swellpercLen, rrand(1.0, 5.0));
					~lowSwell.play;

					5.wait;

					// Percussion

					Pdefn(\bellFreqMod, rrand(0.5, 9.0));
					Pdefn(\bellsinMul, rrand(0.2, 50.0));
					Pdefn(\bellpanPos, rrand(-1.0, 1.0));
					~percussion.play;

					7.wait; // 7
					// Percussion

					Pdefn(\bellFreqMod, rrand(0.5, 9.0));
					Pdefn(\bellsinMul, rrand(0.2, 50.0));
					Pdefn(\bellpanPos, rrand(-1.0, 1.0));
					~percussion.play;

					// Low Swell

					Pdefn(\swellFreqMod, rrand(0.5, 1.3));
					Pdefn(\swellsinMul, rrand(0.2, 50.0));
					Pdefn(\swellpercLen, rrand(1.0, 5.0));
					~lowSwell.play;

					11.wait;

					// Percussion

					Pdefn(\bellFreqMod, rrand(0.5, 9.0));
					Pdefn(\bellsinMul, rrand(0.2, 50.0));
					Pdefn(\bellpanPos, rrand(-1.0, 1.0));
					~percussion.play;

					// Low Swell

					Pdefn(\swellFreqMod, rrand(0.5, 1.3));
					Pdefn(\swellsinMul, rrand(0.2, 50.0));
					Pdefn(\swellpercLen, rrand(1.0, 5.0));
					~lowSwell.play;

					7.wait;
					// Percussion

					Pdefn(\bellFreqMod, rrand(0.5, 9.0));
					Pdefn(\bellsinMul, rrand(0.2, 50.0));
					Pdefn(\bellpanPos, rrand(-1.0, 1.0));
					~percussion.play;

					5.wait; // (not quite 13)

					// Percussion

					Pdefn(\bellFreqMod, rrand(0.5, 9.0));
					Pdefn(\bellsinMul, rrand(0.2, 50.0));
					Pdefn(\bellpanPos, rrand(-1.0, 1.0));
					~percussion.play;

					// Low Swell

					Pdefn(\swellFreqMod, rrand(0.5, 1.3));
					Pdefn(\swellsinMul, rrand(0.2, 50.0));
					Pdefn(\swellpercLen, rrand(1.0, 5.0));
					~lowSwell.play;

					3.wait;

					// Percussion

					Pdefn(\bellFreqMod, rrand(0.5, 9.0));
					Pdefn(\bellsinMul, rrand(0.2, 50.0));
					Pdefn(\bellpanPos, rrand(-1.0, 1.0));
					~percussion.play;

					2.wait;

					// Percussion

					Pdefn(\bellFreqMod, rrand(0.5, 9.0));
					Pdefn(\bellsinMul, rrand(0.2, 50.0));
					Pdefn(\bellpanPos, rrand(-1.0, 1.0));
					~percussion.play;

					3.wait;

					// Percussion

					Pdefn(\bellFreqMod, rrand(0.5, 9.0));
					Pdefn(\bellsinMul, rrand(0.2, 50.0));
					Pdefn(\bellpanPos, rrand(-1.0, 1.0));
					~percussion.play;

					5.wait; // (not quite 13)

					// Percussion

					Pdefn(\bellFreqMod, rrand(0.5, 9.0));
					Pdefn(\bellsinMul, rrand(0.2, 50.0));
					Pdefn(\bellpanPos, rrand(-1.0, 1.0));
					~percussion.play;

					3.wait;

					// Percussion

					Pdefn(\bellFreqMod, rrand(0.5, 9.0));
					Pdefn(\bellsinMul, rrand(0.2, 50.0));
					Pdefn(\bellpanPos, rrand(-1.0, 1.0));
					~percussion.play;

					2.wait;

					// Percussion

					Pdefn(\bellFreqMod, rrand(0.5, 9.0));
					Pdefn(\bellsinMul, rrand(0.2, 50.0));
					Pdefn(\bellpanPos, rrand(-1.0, 1.0));
					~percussion.play;

					10.wait;

					s.freeAll;

					masterSequence.stop;
				});

				1.wait;

				masterSequence.start;
			)
		}.start;



	}
)






// Test trigger
/* t = Synth.new(\bell, [\percLen, length, \amp, 0.8, \freqMod, rrand(0.5, 9.0), \sinMul, rrand(0.2, 50.0), \panPos, rrand(-1.0, 1.0), \oscs, rrand(4, 12)]);*/
// t = Synth.new(\lowBell);





