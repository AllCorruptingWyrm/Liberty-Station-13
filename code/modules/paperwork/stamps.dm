/obj/item/stamp
	name = "rubber stamp"
	desc = "A rubber stamp for stamping important documents."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "stamp-qm"
	item_state = "stamp"
	throwforce = 0
	w_class = ITEM_SIZE_TINY
	throw_speed = 7
	throw_range = 15
	matter = list(MATERIAL_PLASTIC = 1)
	attack_verb = list("stamped")
	var/stamp_flags = STAMP_APPROVAL | STAMP_GENERIC

	var/stamp_text		//If set, changes the text of the stamp at the bottom.
	var/xplus	= 2		//How far up in the X direction the stamp can be overlaid.
	var/xminus	= -2	//How far down in the X direction, the same.
	var/yplus	= 2		//Ditto for Y
	var/yminus	= -3	//Ditto for Y

/obj/item/stamp/captain
	name = "board secretary's rubber stamp"
	icon_state = "stamp-cap"
	xplus = 0
	yminus = -1

/obj/item/stamp/hos
	name = "warrant officer's rubber stamp"
	icon_state = "stamp-hos"

/obj/item/stamp/hos2
	name = "blackshield commander's rubber stamp"
	icon_state = "stamp-hos"

/obj/item/stamp/ce
	name = "Union Chief's rubber stamp"
	icon_state = "stamp-ce"

/obj/item/stamp/pr
	name = "oathpledge's rubber stamp"
	icon_state = "stamp-pr"

/obj/item/stamp/rd
	name = "Research Provost's rubber stamp"
	icon_state = "stamp-rd"

/obj/item/stamp/cso
	name = "Chief Surgeon Overseer's rubber stamp"
	icon_state = "stamp-cso"

/obj/item/stamp/denied
	name = "\improper DENIED rubber stamp"
	icon_state = "stamp-deny"
	stamp_flags = STAMP_DENIAL | STAMP_GENERIC

/obj/item/stamp/clown
	name = "clown's rubber stamp"
	icon_state = "stamp-clown"
	stamp_flags = STAMP_GENERIC

/obj/item/stamp/qm
	name = "chief executive officer's stamp"
	icon_state = "stamp-qm"

/obj/item/stamp/fr
	name = "shepherd's stamp"
	icon_state = "stamp-fr"

// Syndicate stamp to forge documents.
/obj/item/stamp/chameleon/attack_self(mob/user as mob)

	var/list/stamp_types = typesof(/obj/item/stamp) - src.type // Get all stamp types except our own
	var/list/stamps = list()

	// Generate them into a list
	for(var/stamp_type in stamp_types)
		var/obj/item/stamp/S = new stamp_type
		stamps[capitalize(S.name)] = S

	var/list/show_stamps = list("EXIT" = null) + sortList(stamps) // the list that will be shown to the user to pick from

	var/input_stamp = input(user, "Choose a stamp to disguise as.", "Choose a stamp.") in show_stamps

	if(user && (src in user.contents))

		var/obj/item/stamp/chosen_stamp = stamps[capitalize(input_stamp)]

		if(chosen_stamp)
			name = chosen_stamp.name
			icon_state = chosen_stamp.icon_state
			stamp_text = chosen_stamp.stamp_text
			xplus = chosen_stamp.xplus
			xminus = chosen_stamp.xminus
			yplus = chosen_stamp.yplus
			yminus = chosen_stamp.yminus
			stamp_flags = chosen_stamp.stamp_flags & ~(STAMP_ADMIN | STAMP_DOCUMENT) //No cloning admin stamps, if we ever make any.
