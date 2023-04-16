
include <../../clicker_counter_lib.scad>


WHEEL_DIAMETER = 16;


DATA = 
[
	[DEVICE,
		
		// [ DISABLED, true],
		// [ MAKE_WHEELS, false ],

		// [ MAKE_TAB_MALE, true ],
		// [ MAKE_TAB_FEMALE, true ],						
			
	
		[COUNTER,	// HP
			
			[ WHEEL, [] ],
			[ WHEEL, []	],
			[ LABEL, "HP"],
		],

		[COUNTER,	// ENERGY
			
			[ WHEEL, []],
			[ WHEEL, []],
			[ LABEL, "NRG"],

		],
		

		[COUNTER,
			
			[ WHEEL, []],
			[ WHEEL, []],
			[ LABEL, "GOLD"],

		],	

		[COUNTER,
			
			[ WHEEL, []],
			[ LABEL, "P"],

		],

		[COUNTER,
			
			[ WHEEL, []],
			[ LABEL, "R"],
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

Main(); 
