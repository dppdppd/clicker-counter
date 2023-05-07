include <../../clicker_counter_lib.scad>

WHEEL_DIAMETER = 16;

DATA = 
[
	[DEVICE,	//player
		
		// [ DISABLED, true],
		// [ MAKE_WHEELS, false ],
		// [ MAKE_BASE, false ],


		// [ MAKE_TAB_MALE, true ],
		// [ MAKE_TAB_FEMALE, true ],						
			
	
		[COUNTER,	// HP
			
			[ WHEEL, [] ],
			[ WHEEL, []	],
			[ LABEL, "HP"],
			// [ MAKE_WHEELS, false ],

		],

		[COUNTER,	// ENERGY
			
			[ WHEEL, []],
			[ WHEEL, []],
			[ LABEL, "M"],
			// [ MAKE_WHEELS, false ],

		],

		[COUNTER,	// ENERGY
			
			[ WHEEL, []],
			[ WHEEL, []],
			[ LABEL, "B"],
			// [ MAKE_WHEELS, false ],

		],

		[COUNTER,	// ENERGY
			
			[ WHEEL, []],
			[ WHEEL, []],
			[ LABEL, "H"],
			// [ MAKE_WHEELS, false ],

		],		
	],

];
