// Use hydrogen cells as fuel to make power, like pacmans.
/obj/machinery/power/hydrogen_gen
	name = "Hydrogen Generator"
	desc = "A portable generator for emergency backup power, use hydrogen fuel cell."
	icon = 'icons/obj/power.dmi'
	icon_state = "portgen0"
	density = 1
	anchored = FALSE
	use_power = NO_POWER_USE

	var/active = FALSE // Is the generator running?
	var/power_gen = 50000 // How much power does it produce?
	var/open = 0
	var/recent_fault = 0
	var/power_output = 1 // Modifier to the power_gen var.
	var/hydrogen_usage = 0.1 // How much hydrogen is used per tick.

	var/list/fuel_cells[6] // List that hold all the fuel cells.
	var/next_cell = 1 // The next cell which we will use power from. // Apparently BYOND Lists start at 1

/obj/machinery/power/hydrogen_gen/Initialize()
	. = ..()
	if(anchored)
		connect_to_network()

/obj/machinery/power/hydrogen_gen/examine(mob/user)
	..()
	to_chat(user, SPAN_NOTICE("The generator is [active ? "on" : "off"].")) // Is the generator on?
	var/total_fuel = 0
	for(var/i = fuel_cells.len to 1 step -1) // Check each cell we have.
		to_chat(user, SPAN_NOTICE("The [i]/th slot is [fuel_cells[i] != null ? "filled with a [fuel_cells[i].name]" : "empty"].")) // Show if the slot is empty or has a canister in it.
		if(fuel_cells[i] != null)
			total_fuel += fuel_cells[i].plasma // Add the cell's remaining fuel to the total
	if(active)
		to_chat(user, SPAN_NOTICE("The [src.name] is currently generating [(power_gen * power_output)/1000] KW of power.")) // How much power is it producing?
	to_chat(user, SPAN_NOTICE("The [src.name] currently hold [total_fuel] units of hydrogen.")) // Show the total

// Switch the machine on or off.
/obj/machinery/power/hydrogen_gen/proc/SwitchOnOff(mob/user)
	active = !active // Switch the generator either on or off.
	user.visible_message(
							SPAN_NOTICE("[user] turn the [src.name] [active ? "on" : "off"]."),
							SPAN_NOTICE("You turn the [src.name] [active ? "on" : "off"].")
							)

/obj/machinery/power/hydrogen_gen/proc/HasFuel() // Check if we have fuel left in at least one fuel cell
	for(var/obj/item/weapon/hydrogen_fuel_cell/C in fuel_cells) // Check each cell we have.
		if(C.plasma >= hydrogen_usage) // Do we have hydrogen left?
			return TRUE
	return FALSE

/obj/machinery/power/hydrogen_gen/proc/UseFuel() // Consume the fuel, if we can.
	for(var/obj/item/weapon/hydrogen_fuel_cell/C in fuel_cells) // Check each cell we have.
		if(C == fuel_cells[next_cell]) // Is is the cell we're supposed to use the hydrogen from?
			if(C.plasma >= hydrogen_usage) // Do we have hydrogen left?
				C.use(hydrogen_usage) // Consume the hydrogen in the cell
			else // The fuel cell is empty
				SwitchCell() // Switch to the next cell
	return

// Switch to the next available cell.
/obj/machinery/power/hydrogen_gen/SwitchCell()
	while(fuel_cells[next_cell] == null) // Keep going as long as the slot is empty
		next_cell++ // Go to the next cell
		if(next_cell > fuel_cells.len) // Did we go over the list's length?
			next_cell = initial(next_cell) // Reset it back to its default value


/obj/machinery/power/hydrogen_gen/proc/InsertFuelCell(obj/item/weapon/hydrogen_fuel_cell/C, mob/user)
	for(var/i = fuel_cells.len to 1 step -1) // Check each cell we have.
		var/O = fuel_cells[i]
		if(O == null) // Check if that cell slot is free
			fuel_cells[i] = C // Remove the cell from the list.
			insert_item(C, user)
			user.visible_message(
									SPAN_NOTICE("[user] insert the hydrogen flask in the [i]\th slot of the [src.name]."),
									SPAN_NOTICE("You insert the hydrogen flask in the [i]\th slot of the [src.name].")
									)
			break // Leave the loop
	return

/obj/machinery/power/hydrogen_gen/proc/DropFuelCell(mob/user)
	var/response = input(user, "Which Fuel Cell do you wish to remove?") as null|anything in fuel_cells
	for(var/i = fuel_cells.len to 1 step -1) // Check each cell we have.
		var/obj/item/weapon/hydrogen_fuel_cell/C = fuel_cells[i]
		if(response == C) // Check if that cell is the one we chose.
			C.forceMove(src.loc) // Move the cell out of the generator.
			fuel_cells[i] = null // Remove the cell from the list.
			user.visible_message(
									SPAN_NOTICE("[user] remove the [i]\th hydrogen flask from the [src.name]."),
									SPAN_NOTICE("You remove the [i]\th hydrogen flask from the [src.name].")
									)
			break // Leave the loop
	return

/obj/machinery/power/hydrogen_gen/Process()
	if(active && HasFuel() && anchored && powernet)
		add_avail(power_gen * power_output)
		UseFuel()
		src.updateDialog()
	else
		active = 0

	update_icon()

/obj/machinery/power/hydrogen_gen/MouseDrop(over_object)
	DropFuelCell(usr)

/obj/machinery/power/hydrogen_gen/attackby(obj/item/weapon/W, mob/user)

	if(default_deconstruction(W, user))
		return

	if(default_part_replacement(W, user))
		return

	if(istype(W, /obj/item/weapon/hydrogen_fuel_cell))
		InsertFuelCell(W, user)
		return

	if(active)
		to_chat(user, SPAN_NOTICE("You can't work with [src] while its running!"))
	else
		var/list/usable_qualities = list(QUALITY_BOLT_TURNING)
		var/tool_type = W.get_tool_type(user, usable_qualities, src)
		switch(tool_type)
			if(QUALITY_BOLT_TURNING)
				if(istype(get_turf(src), /turf/space) && !anchored)
					to_chat(user, SPAN_NOTICE("You can't anchor something to empty space. Idiot."))
					return
				if(W.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You [anchored ? "un" : ""]anchor the brace with [W]."))
					anchored = !anchored
					if(anchored)
						connect_to_network()
					else
						disconnect_from_network()

			if(ABORT_CHECK)
				return

	..()

// Proc when you attack the generator with an empty hand.
/obj/machinery/power/hydrogen_gen/attack_hand(mob/user)
	..()
	if (!anchored)
		return
	SwitchOnOff(user) // Switch the generator on or off