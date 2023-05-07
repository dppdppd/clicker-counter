include <../../clicker_counter_lib.scad>


WHEEL_DIAMETER = 16;


DATA = 
[
	[DEVICE,
		
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
			[ LABEL, "NRG"],
			// [ MAKE_WHEELS, false ],

		],
		
	],
	[DEVICE,
		// [ MAKE_WHEELS, false ],

		[COUNTER,
			
			[ WHEEL, []],
			[ WHEEL, []],
			[ LABEL, "GOLD"],
			// [ MAKE_WHEELS, false ],


		],	

		[COUNTER,
			
			[ WHEEL, []],
			[ LABEL, "P"],
			// [ MAKE_WHEELS, false ],


		],

		[COUNTER,
			
			[ WHEEL, []],
			[ LABEL, "R"],
			// [ MAKE_WHEELS, false ],

		],
		
	],

	[DEVICE,  // ENEMY HP
		
		// [ DISABLED, true],
		// [ MAKE_WHEELS, false ],
		
		[COUNTER,
			
			[ WHEEL, []],
			[ WHEEL, []],
			[ LABEL, "NME"],
		],
	]
];

