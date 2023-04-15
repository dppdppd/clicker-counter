
include <../../clicker_counter_lib.scad>

DATA =
[
	[DEVICE,

		[ MAKE_TAB_MALE, true ],
		
		[COUNTER,
			[ WHEEL, []	],
			[ WHEEL, []	],			
			[ LABEL, "HP"],

			[EXTRA_WIDTH, -1]
		],
	],

	[DEVICE,
		[ MAKE_TAB_FEMALE, true ],

		[COUNTER,
			[ WHEEL, []	],
			[ WHEEL, []	],			
			[ LABEL, "MP"],

			[EXTRA_WIDTH, 4]

		],

		[COUNTER,
			[ WHEEL, []	],
			[ WHEEL, []	],			
			[ LABEL, "XP"]
		]		
	],
];

Main(); 
