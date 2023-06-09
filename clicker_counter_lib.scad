// Copyright 2023 Ido Magal
//
// Released under the Creative Commons - Attribution - Non-Commercial - Share Alike License.
// https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode

VERSION = "1.00";
COPYRIGHT_INFO = "\tClicker Counter\n\thttps://github.com/dppdppd/clicker_counter\n\n\tCopyright 2023 Ido Magal\n\tCreative Commons - Attribution - Non-Commercial - Share Alike.\n\thttps://creativecommons.org/licenses/by-nc-sa/4.0/legalcode";


GLYPHS = "GLYPHS";
FONT = "FONT";
BASE_FONT = "BASE_FONT";
WHEEL_FONT = "WHEEL_FONT";

LABEL = "BASE-LABEL";
CLICK_STRENGTH = "CLICK_STRENGTH";
IS_WHEEL_INNIE = "IS_WHEEL_INNIE";
IS_BASE_INNIE = "IS_BASE_INNIE";
EXTRA_WIDTH = "EXTRA_WIDTH";
DISABLED = "DISABLED";

WEAKEST = -2;
WEAKER = -1;
AVERAGE = 0;
STRONGER = 1;
STRONGEST = 2;

DEVICE = "DEVICE";
GENERAL = "GENERAL";
COUNTER = "COUNTER";
WHEEL = "WHEEL";

UNDERSIDE_LABEL = "UNDERSIDE_LABEL";


MAKE_BASE = "MAKE_BASE";
MAKE_WHEELS = "MAKE_WHEELS";
MAKE_TAB_MALE = "MAKE_TAB_MALE";
MAKE_TAB_FEMALE = "MAKE_TAB_FEMALE";


DATA = [];


// didx - index into root, top level entries
// elidx - index into counters, 2nd level entries.
// idx - index into entries under counters.
// wheelidx - index into wheels.

// OG VALUES
// WHEEL_RADIUS = 8;
// WHEEL_THICKNESS = 3.5;


WHEEL_DIAMETER = 16;
WHEEL_RADIUS = WHEEL_DIAMETER/2;
WHEEL_THICKNESS = WHEEL_RADIUS * 0.5;
WHEEL_INSET = WHEEL_THICKNESS * 0.167;
GLYPH_THICKNESS = WHEEL_RADIUS * 0.0625;
WHEEL_AXLE_DIVOT_DIAMETER = WHEEL_RADIUS * 0.375;
WHEEL_CLICK_DIVOT_DIAMETER = WHEEL_RADIUS * 0.25;
WHEEL_CLICK_DETENT_DIAMETER = WHEEL_CLICK_DIVOT_DIAMETER;
WHEEL_CLICK_DETENT_SCALE = 0.20;
BASE_LABEL_DEPTH = WHEEL_RADIUS * 0.1;
BASE_ARM_THICKNESS = 2;

TOLERANCE = 0.1;

EXTRA_DISTANCE_BETWEEN_DEVICES = WHEEL_RADIUS;


dbg_wheel = "";
dbg_basemain = "";
dbg_baseballs = "";
dgb_crosssection = false;

// key-values helpers

// constants
KE_KEY = 0;
KE_VALUE = 1;

function get_element( table, i ) = table[ i ];
function num_elements( table ) = len( table );

function get_key( table ) = table[KE_KEY];

function find_key( table, key ) = search( [ key ], table )[ KE_KEY ];
function find_value( table, key, default = false ) = find_key( table, key ) == [] ? default : table[ find_key( table, key ) ][ KE_VALUE ];

// count the number of keys matching the parm
function count_keys( table, key, start = 0, stop = -1, idx = 0, sum = 0 ) = 
	let( end = ( stop != -1 && stop < len(table) ) ? stop + 1 : len(table) )
	let( idx = start + idx )
    idx < end ? 
        count_keys( table, key, 0, stop, idx + 1, sum + ( get_key( table[idx] ) == key ? 1 : 0 )) : 
        sum;

///////////////////////////////////////////////////////////////////////

function preview() =  $preview;
$fn = preview() ? 20 : 50;

function get_device( didx ) = get_element( DATA, didx );


module DbgRender( test )
{
    if ( preview() && test == "clear" )
   		color( [1,1,1], alpha = 0.5)
 		children();
    else if ( preview() && test == "off" )
    	* children();
    else
    	children();	
}

module DbgCrossSection()
{
    if ( preview() && dgb_crosssection )
    difference()
    {
        children();
        translate([50,0,0])
        cube( [100, 100, 100], center = true);

    }    
    else
    children();
}

Main();

module Main()
{
	    echo( str( "\n\n\n", COPYRIGHT_INFO, "\n\n\tVersion ", VERSION, "\n\n" ));

	for( didx = [ 0: num_elements( DATA ) - 1 ] )
	{	
		MakeDevice( didx );
	}
}

BASE_MIN_Z = -WHEEL_RADIUS * 1.18;

module MakeDevice( didx )
{
	// echo ( didx, get_device_position( stop = didx ), get_device_width( didx ));
	if ( !is_device_disabled(didx))
	translate([ -get_device_position( didx ),0,0])
	{
		difference()
		{
			// EACH COUNTER
			for( elidx = [ 0: num_elements( get_device( didx ) ) - 1 ] )
			{
				translate( [ -get_part_position( stop = elidx ), 0, 0 ])
				{		
					if ( is_counter( elidx ) && !is_counter_disabled( elidx, didx ))
					{
					//	echo( str("-- counter ", elidx ));

						// look for wheels
						if ( num_wheels_in_counter( elidx = elidx ) > 0)
						{
							// echo( str("---- num wheels: ", num_wheels_in_counter( elidx = elidx ) ));
							for( idx = [ 0: num_elements( get_part( elidx, didx = didx ) ) - 1] )
							{
								if (get_device_make_wheels() && is_wheel( elidx, idx ))
								{            
									wheelidx = get_wheelidx( elidx, idx);
									if ( !is_wheel_disabled(elidx, wheelidx, didx))
									{
										DbgRender( dbg_wheel )
										OrientWheelForPrint( elidx, wheelidx, idx )       
												MakeWheel( elidx, wheelidx );
									}
								}

								// echo( idx, get_part_position( stop = elidx));

								if ( get_device_make_base() )
								{
									OrientBaseForPrint()
									MakeBaseForCounter( elidx );
								}

							}
						}
						else
						{
							OrientBaseForPrint()							
							MakeExtraWidth( elidx );
						}

						if ( get_device_make_base() )
						if ( !is_last_counter( elidx ) )
						{
							OrientBaseForPrint()
							MakeExtraWidth( elidx );
						}
					}
				}
			}

			OrientBaseForPrint()
			MakeBaseUndersideLabel();

			if ( get_device_tab_female() )
			{
				OrientBaseForPrint()
				MakeTab( male = false );
			}
		}

		if ( get_device_tab_male() )
		{
			DbgRender( dbg_basemain )
			OrientBaseForPrint()
			MakeTab( male = true );
		}
	}

	function get_device_underside_label( didx = didx ) = find_value( get_device( didx ), UNDERSIDE_LABEL, default = false);
	function get_device_make_wheels( didx = didx ) = find_value( get_device( didx ), MAKE_WHEELS, default = true);
	function get_device_make_base( didx = didx ) = find_value( get_device( didx ), MAKE_BASE, default = true);
	function get_device_base_font( didx = didx ) = find_value( get_device( didx ), BASE_FONT, default = "Liberation Sans:style=Bold");
	function get_device_wheel_font( didx = didx ) = find_value( get_device( didx ), WHEEL_FONT, default = "Liberation Sans:style=Bold");
	function get_device_default_glyphs( didx = didx ) = find_value( get_device( didx ), GLYPHS, default = ["0","1","2","3","4","5","6","7","8","9"]);
	function get_device_default_click_strength( didx = didx ) = find_value( get_device( didx ), CLICK_STRENGTH, default = 0);
	function get_device_default_is_wheel_innie( didx = didx ) = find_value( get_device( didx ), IS_WHEEL_INNIE, default = true);
	function get_device_default_base_label_innie( didx = didx ) = find_value( get_device( didx ), IS_BASE_INNIE, default = false);
	function get_device_default_extra_width( didx = didx ) = find_value( get_device( didx ), EXTRA_WIDTH, default = 1);
	function get_device_tab_male( didx = didx ) = find_value( get_device( didx ), MAKE_TAB_MALE, default = false);
	function get_device_tab_female( didx = didx ) = find_value( get_device( didx ), MAKE_TAB_FEMALE, default = false);

	function num_counters( didx = didx, start = 0 ) = count_keys( get_device( didx ), COUNTER, start = start );
	function is_counter( elidx, didx = didx ) = get_key( get_element( get_device( didx ), elidx)) == COUNTER;
	function get_part( elidx, didx = didx ) = get_element( get_device( didx ), elidx); 					// part can be counter or spacer
	function get_part_subpart( elidx, idx, didx = didx ) = get_element( get_part( elidx, didx ), idx + 1 ); 		// subpart can be wheel or bases

	function is_wheel( elidx, idx, didx = didx )  = get_key( get_part_subpart( elidx, idx, didx ) ) == WHEEL;
	function has_wheel( elidx, didx = didx ) = num_wheels_in_counter( elidx, didx = didx ) > 0;
	function num_wheels_in_counter( elidx, didx = didx ) = count_keys( get_part( elidx, didx ), WHEEL );
	function get_wheelidx( elidx, idx ) = count_keys( get_part( elidx ), WHEEL, stop = idx );
	function get_wheel(elidx, wheelidx, didx = didx, idx = 0, ) =
		is_wheel( elidx, idx ) && get_wheelidx( elidx, idx) == wheelidx ?
			get_part_subpart( elidx, idx, didx ) :
			get_wheel(elidx, wheelidx, didx = didx, idx = idx + 1 );

	function num_wheels_in_device( didx = didx, elidx = 0, sum = 0 ) =
	//	echo( "numwhels", "didx",didx,"elidx", elidx  )
		elidx < num_elements( get_device( didx ) ) ?
		num_wheels_in_device( didx, elidx + 1, sum + num_wheels_in_counter( elidx, didx ) ) :
		sum;

	function is_disabled( table ) = find_value( table, DISABLED, default = false);
	function is_device_disabled( didx ) = is_disabled( get_device( didx));

	function is_wheel_disabled( elidx, wheelidx, didx ) = is_disabled( get_wheel( elidx, wheelidx, didx = didx));

	function get_wheel_glyphs( elidx, wheelidx ) =  find_value( get_wheel( elidx, wheelidx ), GLYPHS, default = get_device_default_glyphs() );
	function get_wheel_font( elidx, wheelidx ) = find_value( get_wheel( elidx, wheelidx ), FONT, default = get_device_wheel_font() );

	function get_wheel_glyph_innie( elidx, wheelidx ) = find_value( get_wheel( elidx, wheelidx ), IS_WHEEL_INNIE, default = get_device_default_is_wheel_innie() );
	function get_wheel_glyph_count( elidx, wheelidx ) = len( get_wheel_glyphs( elidx, wheelidx ));
	function get_wheel_glyph_distance_from_center( elidx, wheelidx ) = (WHEEL_RADIUS * cos( 180 / (get_wheel_glyph_count( elidx, wheelidx )) ) - GLYPH_THICKNESS);

	function wheel_size_to_click_distance( g) = 	g == 4 ? 0.45 : 
													g == 5 ? 0.47 : 
													g == 6 ? 0.49 : 
													g == 7 ? 0.51 : 
													g == 8 ? 0.53 : 
													g == 9 ? 0.55 : 
													g == 10 ? 0.57 : // ideal value
													g == 11 ? 0.63 : 
													g >= 12 ? 0.7 : 0.57;																																																																																					

	function get_click_distance_from_center( elidx, wheelidx ) = WHEEL_RADIUS * wheel_size_to_click_distance( get_wheel_glyph_count( elidx, wheelidx ));


	CLICK_STRENGTH_MIN = 0.4;
	CLICK_STRENGTH_MAX = 0.6;
	click_strength_range = CLICK_STRENGTH_MAX - CLICK_STRENGTH_MIN;
	click_strength_steps = 4;
	click_strength_delta = click_strength_range / click_strength_steps;
	click_strength_avg = (CLICK_STRENGTH_MAX + CLICK_STRENGTH_MIN)/2;

	function click_strength_to_scale( strength ) = strength * click_strength_delta + click_strength_avg ;
	function get_counter_click_strength( elidx ) = click_strength_to_scale( find_value( get_part( elidx), CLICK_STRENGTH, default = get_device_default_click_strength() ));

	function get_part_width( elidx, didx = didx ) = is_counter( elidx, didx ) ? get_counter_width( elidx, didx ) : 0;
	function get_counter_extra_width( elidx, didx = didx ) = find_value( get_part( elidx ), EXTRA_WIDTH, default = get_device_default_extra_width( didx ) );
	function get_counter_width( elidx, didx = didx ) = num_wheels_in_counter( elidx, didx ) * ( wheel_unit_width - BASE_ARM_THICKNESS ) + ( has_wheel(elidx, didx = didx ) ? BASE_ARM_THICKNESS : 0 ) + ( is_last_counter( elidx, didx = didx ) ? 0 : get_counter_extra_width( elidx = elidx, didx = didx ) );

	function is_last_counter( elidx, didx = didx ) = num_counters( didx, start = elidx + 1 ) == 0;


	function get_part_position( didx = didx, stop, idx = 0, sum = 0 ) =
		idx < stop ?
			get_part_position( didx, stop, idx + 1, sum + get_part_width( idx, didx )) :
			sum;

	function get_device_width( didx = didx, elidx = 0, sum = 0 ) =
		elidx <= len( get_device( didx )) ?
			get_device_width( didx, elidx + 1, sum + get_part_width( elidx = elidx, didx = didx )) :
			sum;

	function get_device_position( stop, didx = 0, sum = 0 ) =
		didx < stop ?
			get_device_position( stop, didx + 1, sum + get_device_width( didx = didx ) + EXTRA_DISTANCE_BETWEEN_DEVICES  ) :
			sum;

	function get_counter_base_font( elidx, didx = didx ) = find_value( get_part( elidx, didx ), FONT, default = get_device_base_font() );
	function get_counter_base_label( elidx, didx = didx ) = find_value( get_part( elidx, didx ), LABEL, default = "" );
	function get_counter_base_label_innie( elidx, didx = didx ) = find_value( get_part( elidx, didx ), IS_BASE_INNIE, default = get_device_default_base_label_innie() );
	function is_counter_disabled( elidx, didx = didx ) = is_disabled( get_part( elidx, didx));
	function get_counter_make_wheels( elidx, didx = didx ) = find_value( get_part( elidx, didx ), MAKE_WHEELS, default = true);


	preview_translate = preview() ? [0,0,0] : [ 20,0,0];

	wheel_unit_width = WHEEL_THICKNESS + 2 * (BASE_ARM_THICKNESS + 2*TOLERANCE);
	base_wheel_width = wheel_unit_width - BASE_ARM_THICKNESS;

	function add( vector, stop, idx = 0, sum = 0 ) = 
		idx < stop ? 
			add( vector, stop, idx + 1, sum + vector[idx]) : 
			sum;


	module OrientWheelForPrint( elidx, wheelidx, idx )
	{
			this_wheel_pos = -1 * wheelidx * base_wheel_width;

			wheel_dist = WHEEL_RADIUS * 2.2;

		if ( preview() )
		{
			rotate([21,0,0])
			translate( [this_wheel_pos,  0 ])
			children();
		}
		else
		{
			translate( [ wheelidx, WHEEL_RADIUS * 1 + (wheelidx + elidx ) * wheel_dist ,
			WHEEL_THICKNESS/2 ])
			rotate([0,-90,0])

			children();		
		}
	}

	module MakeBaseLabel( elidx )
	{
		// label
		translate( [ - get_counter_width( elidx )/2, 9 * WHEEL_RADIUS/8, BASE_MIN_Z + WHEEL_RADIUS * .23 ])
		rotate([-12, 0, 0])
		linear_extrude(height = BASE_LABEL_DEPTH, scale = 1 ) 
		rotate( [ 0,0,180])
		text( 
			text = get_counter_base_label( elidx ), 
			valign = "center", 
			halign = "center", 
			size = WHEEL_RADIUS/4.5 * 2,
			font = get_counter_base_font(elidx));
	}

	module MakeBaseForCounter( elidx )
	{
		difference()
		{
			for( wheelidx = [0: num_wheels_in_counter( elidx = elidx ) - 1] )
			{
				translate( [ -wheelidx * base_wheel_width ,0 , 0])
				MakeBaseForSingleWheel( elidx, wheelidx );
			}
			

			// label
			if ( get_counter_base_label_innie( elidx ) )
				translate( [0,0, - BASE_LABEL_DEPTH ])
				MakeBaseLabel( elidx );
		}
		
		
		if ( !get_counter_base_label_innie( elidx ) )
			translate( [0,0, -0.1])
				MakeBaseLabel( elidx );
	}

	module MakeExtraWidth( elidx )
	{
		counter_extra_width = get_counter_extra_width(elidx);

		translate( [ - get_counter_width( elidx) + counter_extra_width,0,0])
		rotate([0,-90,0])
		linear_extrude(height = counter_extra_width)
		{
			BaseLowerPolygon();
		}
	}

	module MakeBaseForSingleWheel( elidx, wheelidx )
	{
		// main
		DbgRender( dbg_basemain )
		rotate([0,-90,0])
		{
			difference()
			{
				// main positive shape
				linear_extrude(height = wheel_unit_width) 
				{
					BaseLowerPolygon();

					BaseUpperPolygon();
				}

				// wheel cavity
				translate( [ WHEEL_RADIUS * 0.3, -WHEEL_RADIUS, BASE_ARM_THICKNESS])
				linear_extrude(height = WHEEL_THICKNESS + 4*TOLERANCE )
				{
					BaseCavityPolygon();
				}
			}
		}

		// balls
		//DbgAxis();
		DbgRender( dbg_baseballs )
		translate([-BASE_ARM_THICKNESS - WHEEL_THICKNESS/2 - 2*TOLERANCE,0,0])
		{
			MakeAxle( elidx);
			MakeClicker( elidx, wheelidx);

			mirror( [1,0,0])
			{
				MakeAxle( elidx);
				MakeClicker( elidx, wheelidx );
			}
		}
	}

	module MakeClicker( elidx, wheelidx )
	{
		click_dist = get_click_distance_from_center( elidx, wheelidx );
			angle = -33;

		translate( [  ( WHEEL_THICKNESS/2 + 2*TOLERANCE   ) ,0,0])
		hull()
		{
			angle = -33;
			rotate( [angle,0,0])
			translate( [-TOLERANCE * 1.5,0,click_dist])
			Ball( diameter = WHEEL_CLICK_DETENT_DIAMETER, scale = get_counter_click_strength( elidx ) );

			rotate( [angle,0,0])
			translate( [0,0,click_dist])
			rotate([0,-90,0])
			cylinder( d = WHEEL_CLICK_DETENT_DIAMETER*1.2, h = 0.01, center = true );
		}		
	}

	module MakeAxle( elidx)
	{
		// axle
		translate( [  ( WHEEL_THICKNESS/2 + 2*TOLERANCE   ) ,0,0])
		translate( [ 0.01,0,0])
		difference()
		{
			rotate( [ 0,-90,0])
			linear_extrude(height = 0.6 + TOLERANCE, center = false, scale = 1) 
			circle( d = WHEEL_AXLE_DIVOT_DIAMETER);     

			translate([1.8,0,-4])
			rotate([0,45,30])
			cube([10,10,2], center = true);
		}
	}


	module MakeWheel ( elidx, wheelidx )
	{
		// echo(get_wheel( elidx, wheelidx ), get_wheel_glyphs( elidx, wheelidx ));

		wheel_num_sides = get_wheel_glyph_count( elidx, wheelidx );
		wheel_angle = 360 / wheel_num_sides;
		even_num_sides = wheel_num_sides % 2;
		click_dist =  get_click_distance_from_center(elidx, wheelidx );

		if ( get_counter_make_wheels( elidx ))
		difference()
		{
			// wheel
			rotate([0,90,0])
			linear_extrude(height = WHEEL_THICKNESS, center = true) 
			circle( r = WHEEL_RADIUS, $fn = wheel_num_sides);

			if ( get_wheel_glyph_innie( elidx, wheelidx) )
				MakeWheelGlyphs( elidx, wheelidx, innie = true );

			// center axle hole
			rotate( [ 0,90,0])
			linear_extrude(height = WHEEL_THICKNESS, center = true) 
			circle( d = WHEEL_AXLE_DIVOT_DIAMETER + TOLERANCE);                
			
			// click divots
		
			MakeClickerDivots();

			mirror([1,0,0])
			MakeClickerDivots();
		}

		if ( !get_wheel_glyph_innie( elidx, wheelidx) )
			MakeWheelGlyphs( elidx, wheelidx, innie = false );

	module MakeClickerDivots()
	{
		divot_depth = WHEEL_THICKNESS * .3;

		//translate( [WHEEL_THICKNESS/2 - divot_depth + 0.01,0,0])
		for ( side=[0 : wheel_num_sides - 1 ])
		{
			angle = side * wheel_angle + (even_num_sides ? 0 : wheel_angle/2);
			rotate([angle, 0, 0])
			translate( [0,0, click_dist])
			rotate( [ 0,90,0])
			// cylinder(h=divot_depth, r1 = 0, r2= WHEEL_CLICK_DIVOT_DIAMETER/2+0.4,center = false);
			cylinder(h=WHEEL_THICKNESS, r1 = WHEEL_CLICK_DIVOT_DIAMETER/2, r2= WHEEL_CLICK_DIVOT_DIAMETER/2,center = false);            
		}  		
	}


	}

	module MakeWheelGlyphs( elidx, wheelidx, innie )
	{
		wheel_num_sides = get_wheel_glyph_count( elidx, wheelidx );

		wheel_angle = 360 / wheel_num_sides;
		even_num_sides = wheel_num_sides % 2;
		letter_dist = get_wheel_glyph_distance_from_center(elidx, wheelidx);
		z = letter_dist + 0.01 + ( innie ? 0 : GLYPH_THICKNESS );

		color("red")
		for ( side=[0 : wheel_num_sides - 1 ])
		{
			angle = side * wheel_angle + (even_num_sides ? 0 : wheel_angle/2);
			rotate([angle, 0, 0])
			translate( [0,-0, z])
			linear_extrude(height = GLYPH_THICKNESS, scale = 1 ) 
			resize( [ WHEEL_THICKNESS/4.5 * 3, 0, 0 ], auto = true)
			rotate( [ 0,0,180])
			text( 
				text = get_wheel_glyphs( elidx, wheelidx )[side], 
				valign = "center", 
				halign = "center", 
				size = 1,
				font = get_wheel_font( elidx, wheelidx ) );
		}   
	}


	module MakeTab( male )
	{
		
		diameter = 5;
		height = 3;
		offset = 0.5;


		translate([ 0, -WHEEL_RADIUS * .4,0])
		if ( male )
			translate( [ offset, 0, BASE_MIN_Z ])
			mirror( [ 1,0,0])
			// translate( [ offset, -4.5, 0 ])
			// rotate([0,0,90])
			// multmatrix(m =  [
            // [ 1, 0, 0.8, 0],
            // [ 0, 1, 0, 0],
            // [ 0, 0, 1, 0]
            //         ])
			// rotate([0,0,-90])
			resize( [ diameter/2,diameter,height], auto = true)
			cylinder( h = height , $fn=3, d = diameter  );
			
		else
			translate( [ - get_device_width() , 0, 0 ])
			translate( [offset -TOLERANCE,0,0])
			translate( [ 0, 0, BASE_MIN_Z ])
			mirror( [ 1,0,0])
			// translate( [ 0, -4.5, 0 ])
			// rotate([0,0,90])
			// multmatrix(m =  [
            // [ 1, 0, 0.8, 0],
            // [ 0, 1, 0, 0],
            // [ 0, 0, 1, 0]
            //         ])
			// rotate([0,0,-90])			
			resize( [ diameter/2, diameter, height + TOLERANCE], auto = true)
			cylinder( h = height , $fn=3, d = diameter  );
			
	}

	module MakeBaseUndersideLabel()
	{
		translate( [- get_device_width() /2 ,0, 0 ]) // center it in the base
		translate( [ -wheel_unit_width/2, 0, BASE_MIN_Z]) // axis offset to match first base
		linear_extrude(height = 0.3, scale = 1 ) 
		resize( [ get_device_width(), 0, 0 ], auto = true)
		rotate( [ 180,0,0])
		text( 
			text = get_device_underside_label(), 
			valign = "center", 
			halign = "center", 
			size = 1);	
	}


	module OrientBaseForPrint()
	{
		translate( [ wheel_unit_width/2,0, 0])
		if ( preview() )
		{
			children();
		}
		else
		{
			// raise it to floor
			translate( [0,0, -BASE_MIN_Z])
			children();
		}
	}

}

module DbgAxis()
{
	if (preview() )
	{
		color("blue") cube( [ 0.1,0.1,50]);
		color("green") cube( [ 0.1,50,0.1]);
		color("red") cube( [ 50,0.1,0.1]);		
	}
}


module BaseLowerPolygon()
{
    polygon( points = [
    [BASE_MIN_Z, -WHEEL_RADIUS * 1.3],
    [BASE_MIN_Z, WHEEL_RADIUS * 1.5],
    [ BASE_MIN_Z +WHEEL_RADIUS * .15, WHEEL_RADIUS * 1.5],
    [ -WHEEL_RADIUS/1.6, -WHEEL_RADIUS/2.5]
	]);
}

module BaseUpperPolygon()
{
    polygon( points = [
        [BASE_MIN_Z, -WHEEL_RADIUS * 1.3],
        [BASE_MIN_Z, -WHEEL_RADIUS * 0.3],
        [ WHEEL_RADIUS * 0.71, WHEEL_RADIUS * 0.61],
        [ WHEEL_RADIUS * 0.84, WHEEL_RADIUS * 0.41]		
    ]);
}

module BaseCavityPolygon()
{
    polygon( points = [
        [BASE_MIN_Z -WHEEL_RADIUS * .2, -WHEEL_RADIUS * 2],
        [BASE_MIN_Z -WHEEL_RADIUS * .2, WHEEL_RADIUS * 1.7],
        [ WHEEL_RADIUS * 2, WHEEL_RADIUS * 2]
    ]);   
}

module Ball( diameter, scale = 0 )
{
    scale( [ scale, 1, 1])
    sphere( d = diameter );
}