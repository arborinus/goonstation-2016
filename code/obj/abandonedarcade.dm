/area/abandonedarcade
	name = "Abandoned Arcade"
	icon_state = "yellow"

/*
 *	Ballpit, fun for all ages
 */

/obj/ballpit
	name = "ball pit"
	density = 0
	anchored = 1
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "ballpit_in"
	layer = EFFECTS_LAYER_UNDER_3
	mouse_opacity = 0

/turf/simulated/ballpit
	name = "ball pit"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "ballpitfloor"

	New()
		..()
		dir = pick(NORTH,SOUTH)

	attack_hand(var/mob/user as mob)
		playsound(user.loc, 'sound/effects/bow_aim.ogg', 50, 1, -1)
		src.visible_message("<span style=\"color:blue\">[user] digs around in the ball pit.</span>")
		sleep(2)
		if(prob(10))
			boutput(user, "<span style=\"color:red\"><B>You find a ball pit viper and it bites you!</B></span>")
			playsound(user.loc, "sound/effects/cat_hiss.ogg", 100, 0)
			user.reagents.add_reagent("venom",2)
			return
		else
			if(prob(30))
				boutput(user, "<span style=\"color:red\">You find something!</span>")
				var/obj/item/prize
				var/prizeselect = rand(1,3)
				switch(prizeselect)
					if(1)
						prize = new /obj/item/reagent_containers/food/snacks/burger/moldy(user.loc)
					if(2)
						prize = new /obj/item/skull(user.loc)
					if(3)
						prize = new /obj/item/reagent_containers/syringe(user.loc)
			else
				boutput(user, "<span style=\"color:blue\">You don't find anything.</span>")
				return

/obj/ballpitwater
	name = "ball pit"
	density = 0
	anchored = 1
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "ballpitwater"
	layer = EFFECTS_LAYER_UNDER_3
	mouse_opacity = 0

	HasEntered(AM as mob|obj)
		if(ismob(AM))
			var/mob/M = AM
			playsound(src.loc, 'sound/effects/bow_aim.ogg', 50, 1, -1) //It's close enough, okay?
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.shoes)
					boutput(H, "<span style=\"color:red\"><B>Your shoes cause you to trip in the ball pit!</B></span>")
					H.weakened = max(1.5, H.weakened)


/*
 *	Gorilla suit
 */

/obj/item/clothing/suit/gimmick/gorilla
	name = "gorilla suit"
	desc = "I guess the zipper counts as a 'silver back'?"
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	icon_state = "gorilla"
	item_state = "gorilla"

/obj/item/clothing/head/gorilla
	name = "gorilla mask"
	icon_state = "gorilla"
	item_state = "gorilla"

/*
 *	Duplicate of the arcade cabinet, but requires tokens and is more of a ripoff
 */

/obj/machinery/vending/tokenmachine
	name = "token machine"
	desc = "Put in your allowance for some game tokens"
	pay = 1
	vend_delay = 10
	icon_state = "generic"
	icon_panel = "generic-panel"

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/coin", 50, cost=100)

/obj/machinery/computer/assholearcade
	name = "arcade machine"
	icon = 'icons/obj/computer.dmi'
	icon_state = "arcade"
	var/enemy_name = "Space Villian"
	var/temp = "Winners Spend more Tokens" //Temporary message, for attack messages, etc
	var/player_hp = 15 //Player health/attack points
	var/player_mp = 5
	var/enemy_hp = 60 //Enemy health/attack points
	var/enemy_mp = 30
	var/gameover = 0
	var/token = 0 //Player needs to put in a token (coin) to play
	var/blocked = 0 //Player cannot attack/heal while set
	desc = "An arcade machine with a coin slot."

/obj/machinery/computer/assholearcade/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/screwdriver))
		playsound(src.loc, "sound/items/Screwdriver.ogg", 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				boutput(user, "<span style=\"color:blue\">The broken glass falls out.</span>")
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				if(src.material) A.setMaterial(src.material)
				new /obj/item/raw_material/shard/glass( src.loc )
				var/obj/item/circuitboard/arcade/M = new /obj/item/circuitboard/arcade( A )
				for (var/obj/C in src)
					C.set_loc(src.loc)
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				qdel(src)
			else
				boutput(user, "<span style=\"color:blue\">You disconnect the monitor.</span>")
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				if(src.material) A.setMaterial(src.material)
				var/obj/item/circuitboard/arcade/M = new /obj/item/circuitboard/arcade( A )
				for (var/obj/C in src)
					C.set_loc(src.loc)
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				qdel(src)
	if(istype(I, /obj/item/coin))
		boutput(user, "<span style=\"color:blue\">You put in the token.</span>")
		token = 1
		qdel( I )
	else
		src.attack_hand(user)
	return

/obj/machinery/computer/assholearcade/New()
	..()
	var/name_action
	var/name_part1
	var/name_part2

	name_action = pick("Defeat ", "Annihilate ", "Save ", "Strike ", "Stop ", "Destroy ", "Robust ", "Romance ")

	name_part1 = pick("the Automatic ", "Farmer ", "Lord ", "Professor ", "the Evil ", "the Dread King ", "the Space ", "Lord ")
	name_part2 = pick("Melonoid", "Murdertron", "Sorcerer", "Ruin", "Jeff", "Ectoplasm", "Crushulon")

	src.enemy_name = replacetext((name_part1 + name_part2), "the ", "")
	src.name = (name_action + name_part1 + name_part2)


/obj/machinery/computer/assholearcade/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/assholearcade/attack_hand(mob/user as mob)
	if ((src.token <= 0))
		boutput(user, "<span style=\"color:blue\">You need to put in a token to play.</span>")
		return
	if(..())
		return
	user.machine = src
	var/dat = "<a href='byond://?src=\ref[src];close=1'>Close</a>"
	dat += "<center><h4>[src.enemy_name]</h4></center>"

	dat += "<br><center><h3>[src.temp]</h3></center>"
	dat += "<br><center>Health: [src.player_hp] | Magic: [src.player_mp] | Enemy Health: [src.enemy_hp]</center>"

	if (src.gameover)
		dat += "<center><b><a href='byond://?src=\ref[src];newgame=1'>New Game</a>"
	else
		dat += "<center><b><a href='byond://?src=\ref[src];attack=1'>Attack</a> | "
		dat += "<a href='byond://?src=\ref[src];heal=1'>Heal</a> | "
		dat += "<a href='byond://?src=\ref[src];charge=1'>Recharge Power</a>"

	dat += "</b></center>"

	user << browse(dat, "window=arcade")
	onclose(user, "arcade")
	return

/obj/machinery/computer/assholearcade/Topic(href, href_list)
	if(..())
		return

	if (!src.blocked)
		if (href_list["attack"])
			src.blocked = 1
			var/attackamt = rand(2,6)
			src.temp = "You attack for [attackamt] damage!"
			src.updateUsrDialog()

			sleep(10)
			src.enemy_hp -= attackamt
			src.arcade_action()

		else if (href_list["heal"])
			src.blocked = 1
			var/pointamt = rand(1,3)
			var/healamt = rand(6,8)
			src.temp = "You use [pointamt] magic to heal for [healamt] damage!"
			src.updateUsrDialog()

			sleep(10)
			src.player_mp -= pointamt
			src.player_hp += healamt
			src.blocked = 1
			src.updateUsrDialog()
			src.arcade_action()

		else if (href_list["charge"])
			src.blocked = 1
			var/chargeamt = rand(4,7)
			src.temp = "You regain [chargeamt] points"
			src.player_mp += chargeamt

			src.updateUsrDialog()
			sleep(10)
			src.arcade_action()

	if (href_list["close"])
		usr.machine = null
		usr << browse(null, "window=arcade")

	else if (href_list["newgame"]) //Reset everything
		temp = "New Round"
		player_hp = 15
		player_mp = 5
		enemy_hp = 60
		enemy_mp = 30
		gameover = 0
		token = 0

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/machinery/computer/assholearcade/proc/arcade_action()
	var/mob/living/carbon/human/H = usr
	if (istype(H))
		if (H.sims)
			H.sims.affectMotive("fun", 4)
	if ((src.enemy_mp <= 0) || (src.enemy_hp <= 0))
		src.gameover = 1
		src.temp = "[src.enemy_name] has fallen! Rejoice!"
		var/obj/item/prize
		var/prizeselect = rand(1,6)
		switch(prizeselect)
			if(1)
				prize = new /obj/item/spacecash(src.loc)
				prize.name = "space ticket"
				prize.desc = "It's almost like actual currency!"
			if(2)
				playsound(src.loc, "sound/effects/sparks1.ogg", 100, 0)
				prize = new /obj/decal/cleanable/robot_debris(src.loc)
				prize.name = "bits of wire and metal"
				prize.desc = "Um, is this supposed to be the prize?"
			if(3)
				prize = new /obj/item/reagent_containers/food/snacks/fries(src.loc)
				prize.name = "stale fries"
				prize.desc = "How long were these in the machine?"
			if(4)
				prize = new /obj/item/card_box/booster(src.loc)
				prize.name = "\improper Spacomoon the Gralepening booster pack"
				prize.desc = "Totally not bootleg cards."
			if(5)
				prize = new /obj/item/rubber_hammer(src.loc)
			if(6)
				prize = new /obj/critter/nicespider(src.loc)
				prize.name = "spider"

	else if ((src.enemy_mp <= 5) && (prob(70)))
		var/stealamt = rand(2,3)
		src.temp = "[src.enemy_name] steals [stealamt] of your power!"
		src.player_mp -= stealamt
		src.updateUsrDialog()

		if (src.player_mp <= 0)
			src.gameover = 1
			sleep(10)
			src.temp = "You have been drained! GAME OVER"

	else if ((src.enemy_hp <= 10) && (src.enemy_mp > 4))
		src.temp = "[src.enemy_name] heals for 4 health!"
		src.enemy_hp += 4
		src.enemy_mp -= 4

	else
		var/attackamt = rand(3,6)
		src.temp = "[src.enemy_name] attacks for [attackamt] damage!"
		src.player_hp -= attackamt

	if ((src.player_mp <= 0) || (src.player_hp <= 0))
		src.gameover = 1
		src.temp = "You have been crushed! GAME OVER"

	src.blocked = 0
	return

/obj/machinery/computer/assholearcade/power_change()

	if(stat & BROKEN)
		icon_state = "arcadeb"
	else
		if( powered() )
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "arcade0"
				stat |= NOPOWER
