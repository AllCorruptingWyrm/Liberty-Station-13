/obj/item/cruciform_upgrade
	name = "Base Cruciform Upgrade"
	desc = "Cruciform upgrade, is now part of our reality."
	icon = 'icons/obj/module.dmi'
	icon_state = "core_upgrade"
	var/mob/living/carbon/human/wearer
	var/obj/item/implant/core_implant/cruciform/cruciform
	var/active = FALSE

/obj/item/cruciform_upgrade/proc/install(var/mob/living/target, var/obj/item/implant/core_implant/cruciform/_cruciform)
	forceMove(_cruciform)
	_cruciform.upgrade = src
	wearer = target
	cruciform = _cruciform
	active = TRUE
	OnInstall(target, _cruciform)
	wearer.visible_message(SPAN_WARNING("[src] attaches itself to [wearer]'s cruciform."))
	return active

/obj/item/cruciform_upgrade/proc/uninstall()
	forceMove(get_turf(wearer))
	cruciform.upgrade = null
	wearer.visible_message(SPAN_WARNING("[src] removes itself from [wearer]'s cruciform."))
	OnUninstall()
	wearer = null
	cruciform = null
	active = FALSE
	return active

/obj/item/cruciform_upgrade/proc/OnInstall(var/disciple, var/_cruciform)

/obj/item/cruciform_upgrade/proc/OnUninstall()

/obj/item/cruciform_upgrade/natures_blessing
	name = "Natures blessing"
	desc = "This upgrade stabilizes the Faithful and nurtures the plants near the follower. Useful for the aspiring Agrolytes."
	icon_state = "natures_blessing"
	matter = list(MATERIAL_BIOMATTER = 100, MATERIAL_GOLD = 5, MATERIAL_PLASTEEL = 5)
	var/cooldown = 1 SECONDS // Just to make sure that upgrade don't go berserk.
	var/initial_time

/obj/item/cruciform_upgrade/natures_blessing/OnInstall(var/disciple, var/_cruciform)
	..()
	START_PROCESSING(SSobj, src)

/obj/item/cruciform_upgrade/natures_blessing/OnUninstall()
	..()
	STOP_PROCESSING(SSobj, src)

/obj/item/cruciform_upgrade/natures_blessing/Process()
	for(var/obj/machinery/portable_atmospherics/hydroponics/tray in oviewers(5, wearer))
		if(tray.seed && !tray.dead)
			var/max_health = tray.seed.get_trait(TRAIT_ENDURANCE)
			if(tray.health < max_health)
				tray.health += 0.1
			if(tray.weedlevel)
				tray.weedlevel -= 0.1
	if(world.time < initial_time + cooldown)
		return
	initial_time = world.time
	for(var/mob/living/L in oviewers(5, wearer))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.stat == DEAD || !(H.get_core_implant(/obj/item/implant/core_implant/cruciform)))
				continue
			if(H.getBruteLoss() > 50)
				H.adjustBruteLoss(-0.2)
			if(H.getFireLoss() > 50)
				H.adjustFireLoss(-0.2)

/obj/item/cruciform_upgrade/faiths_shield
	name = "Faiths shield"
	desc = "This upgrade will slightly increase a followers resistance to physical and burn damage from any source."
	icon_state = "faiths_shield"
	matter = list(MATERIAL_BIOMATTER = 50, MATERIAL_GOLD = 5, MATERIAL_PLASTEEL = 10)
	var/shield_mod = 0.1

/obj/item/cruciform_upgrade/faiths_shield/OnInstall(var/disciple, var/_cruciform)
	..()
	wearer.species.brute_mod -= shield_mod
	wearer.species.burn_mod -= shield_mod

/obj/item/cruciform_upgrade/faiths_shield/OnUninstall()
	..()
	wearer.species.brute_mod += shield_mod
	wearer.species.burn_mod += shield_mod

/obj/item/cruciform_upgrade/cleansing_presence
	name = "Cleansing presence"
	desc = "This upgrade cleans tiles that the follower walks upon. Will slowly cause space vines and maint-shrooms to wither and die in the follower’s presence. Useful for the cleanly."
	icon_state = "cleansing_presence"
	matter = list(MATERIAL_BIOMATTER = 50, MATERIAL_SILVER = 5, MATERIAL_PLASTEEL = 5)
	var/area_radius = 5

/obj/item/cruciform_upgrade/cleansing_presence/OnInstall(var/disciple, var/_cruciform)
	..()
	START_PROCESSING(SSobj, src)

/obj/item/cruciform_upgrade/cleansing_presence/OnUninstall()
	..()
	STOP_PROCESSING(SSobj, src)

/obj/item/cruciform_upgrade/cleansing_presence/Process()
	wearer.clean_blood()
	var/list/affected = range(area_radius, src)
	for(var/obj/effect/plant/shroom in affected)
		if(istype(shroom.seed, /datum/seed/mushroom/maintshroom))
			shroom.health -= (shroom.max_health * 0.1)
			shroom.check_health()

/obj/item/cruciform_upgrade/martyr_gift
	name = "Martyrs gift"
	desc = "This upgrade causes a follower to cause a healing burst upon dying. It will heal for a massive amount to all humanoid creatures, even those without cruciforms. However, in process of doing so, this upgrade destroys itself."
	icon_state = "martyr_gift"
	matter = list(MATERIAL_BIOMATTER = 50, MATERIAL_GOLD = 5, MATERIAL_PLASTEEL = 5, MATERIAL_PLASMA = 5)
	var/damage_healed = 50 //Heals everyone and every mob around it

/obj/item/cruciform_upgrade/wrath_of_god
	name = "Wrath of god"
	desc = "This upgrade make the follower deal more damage in melee, but also receive a slightly more damage from almost all sources."
	icon_state = "wrath_of_god"
	matter = list(MATERIAL_BIOMATTER = 50, MATERIAL_GOLD = 5, MATERIAL_PLASTEEL = 15)
	var/damage_mod = 0.1 //10% more damage in melee attacking
	var/receive_damage_mod = 0.2 //20% more damage form all sources other then clone

/obj/item/cruciform_upgrade/wrath_of_god/OnInstall(var/disciple, var/_cruciform)
	..()
	wearer.damage_multiplier += damage_mod
	wearer.species.brute_mod += receive_damage_mod
	wearer.species.burn_mod += receive_damage_mod
	wearer.species.oxy_mod += receive_damage_mod
	wearer.species.toxins_mod += receive_damage_mod
	wearer.species.radiation_mod += receive_damage_mod

/obj/item/cruciform_upgrade/wrath_of_god/OnUninstall()
	..()
	wearer.damage_multiplier -= damage_mod
	wearer.species.brute_mod -= receive_damage_mod
	wearer.species.burn_mod -= receive_damage_mod
	wearer.species.oxy_mod -= receive_damage_mod
	wearer.species.toxins_mod -= receive_damage_mod
	wearer.species.radiation_mod -= receive_damage_mod

/obj/item/cruciform_upgrade/speed_of_the_chosen
	name = "Angel Aclarity"
	desc = "This upgrade increases the movement speed of the follower."
	icon_state = "speed_of_the_chosen"
	matter = list(MATERIAL_BIOMATTER = 120, MATERIAL_GOLD = 5, MATERIAL_PLASTEEL = 5)
	var/speed_increase = 0.1 //10% faster, stacks with other sorces so its to be balanced with that
