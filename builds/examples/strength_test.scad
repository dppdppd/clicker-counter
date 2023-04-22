
include <../../clicker_counter_lib.scad>

DATA = 
[
	[DEVICE,
		
		// [ MAKE_WHEELS, false ],

		[COUNTER,
			[CLICK_STRENGTH, WEAKEST],
			[ WHEEL]
		],

		[COUNTER,
			[CLICK_STRENGTH, WEAKER],
			[ WHEEL]
		],

		[COUNTER,
			[CLICK_STRENGTH, AVERAGE],
			[ WHEEL]
		],

		[COUNTER,
				[CLICK_STRENGTH, STRONGER],
			[ WHEEL]
		],

		[COUNTER,
			[CLICK_STRENGTH, STRONGEST],
			[ WHEEL]
		]
	]
];
