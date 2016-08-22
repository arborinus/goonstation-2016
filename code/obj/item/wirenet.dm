// Not sure where this goes so separate .dm ahoy.

/obj/item/wirenet
	name = "throwing net"
	desc = "A mesh of cable coils knotted together with weights around the edge."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "net"
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	item_state = "coil"
	w_class = 4.0

	throw_impact(atom/hit_atom)
		..()
		if (ismob(hit_atom) && prob(85))
			var/mob/M = hit_atom
			if (istype(M, /mob/living/carbon/))
				M.paralysis += 1
			src.visible_message("<span style=\"color:red\"><B>[M]</B> gets caught in [src]!</span>")
			var/obj/icecube/netcube = new /obj/icecube(src)
			M.set_loc(netcube)
			netcube.name = "wire net"
			netcube.desc = "Someone is trapped inside."
			netcube.steam_on_death = 0
			netcube.health = 5
			netcube.icon_state = "netted"
			netcube.anchored = 1
			netcube.underlays += M
			netcube.set_loc(src.loc)
			playsound(src.loc, "sound/misc/rustle2.ogg", 50, 1)
			qdel (src)