
include <../../clicker_counter_lib.scad>


DATA =
[
	[DEVICE,

		[COUNTER,
			[ WHEEL, []	],
		]
	],

	[DEVICE,

		[ MAKE_WHEELS, true ],
		[ MAKE_BASE, true ],
		[ MAKE_TAB_MALE, true ],
		[ MAKE_TAB_FEMALE, true ],
		[COUNTER,

			[WHEEL, 
				
				[ GLYPHS, ["0","1","2","3","4","5"] ],
			],

			[EXTRA_WIDTH, -2]
		],

		[COUNTER,

			[ WHEEL, 

				[ GLYPHS, ["0","1","2","3","4"] ],
			],
		]
	],

	[DEVICE,
				
		[ COUNTER,
			
			[ WHEEL, 
				[ 
					[ GLYPHS, ["0","1","2","3","4","5"] ],
				]
			]
		],	
	],

	[DEVICE,
		
		[ COUNTER,
			
			[ WHEEL, 
				 
				[ GLYPHS, ["0","1","2","3","4","5"] ],
				[ CLICK_STRENGTH, WEAKER ],
			],

			[ WHEEL, 
				
				[ GLYPHS, ["0","1","2","3","4","5","6"] ],
				[ CLICK_STRENGTH, AVERAGE ],
			],


			[ WHEEL, 
				
				[ GLYPHS, ["0","1","2","3","4","5","6","7"] ],
				[ CLICK_STRENGTH, STRONGER ],
			],						
		

			[ LABEL, "HP"]
			
			
		],


		[ COUNTER,

			[ WHEEL,
					
				[ GLYPHS, ["A","B","C","D","E"] ]
				
			],
	
			[ LABEL, "C"]
			
		],


		[ COUNTER,	
			
			[ WHEEL, 
				
				[ GLYPHS, ["0","1","2","3","4","5"] ]
				
			],		
		
			[ LABEL, "M"]
		]
	],



];

Main(); 
