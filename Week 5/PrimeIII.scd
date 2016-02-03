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

s.boot;
s.freeAll;

s.meter.free;
s.plotTree;
s.makeGui;

// s.waitForBoot({ // Add this last to control the piece.

//	var masterSequence;

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
		panPos = 0.0
		|

		var signal, envelope, pan;

		envelope = EnvGen.kr(Env.perc(0.01, percLen, amp, -8), doneAction: 2);
		signal = {
			SinOsc.ar(baseFreq * freqMod, 0, SinOsc.ar(sinMul, 0, 0.2, 0), 0)
		};
		signal = Pan2.ar(signal, panPos, 1);
		Out.ar([0, 1], signal * envelope);
	}
).add
)


(
var length;
length = [71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499];

length = length.choose/60;
t = Synth.new(\bell, [\percLen, length, \amp, 0.5, \freqMod, rrand(0.5, 9.0), \sinMul, rrand(0.2, 50.0), \panPos, rrand(-1.0, 1.0)]);
)






