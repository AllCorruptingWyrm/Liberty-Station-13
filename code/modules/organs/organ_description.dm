/datum/organ_description
	var/name = "limb"
	var/surgery_name
	var/organ_tag = "limb"
	var/additional_limb_parts = list() //Other parts to put on top of limbs.
	var/body_part
	var/parent_organ_base
	var/default_type = /obj/item/organ/external
	var/default_bone_type = /obj/item/organ/internal/bone

	var/max_damage = 0
	var/min_broken_damage = 30
	var/nerve_struck = 0 // can only activate on natural arms/legs
	var/vital = FALSE
	var/cannot_amputate = FALSE

	var/w_class = ITEM_SIZE_NORMAL
	var/max_volume = ITEM_SIZE_COLOSSAL		//Space used up by specific organ size and w_class of cavity implants

	var/amputation_point = "spine"
	var/joint = "neck"
	var/encased
	var/cavity_name = "cavity"

	var/icon_position = null
	var/functions = NONE
	var/list/drop_on_remove = null

/datum/organ_description/proc/create_organ(var/mob/living/carbon/human/H)
	return new default_type(H,src)

/datum/organ_description/chest
	name = "upper body"
	surgery_name = "torso"
	organ_tag = BP_CHEST
	body_part = UPPER_TORSO
	default_type = /obj/item/organ/external/chest
	default_bone_type = /obj/item/organ/internal/bone/chest

	max_damage = 100
	min_broken_damage = 60
	nerve_struck = -1
	vital = TRUE
	cannot_amputate = TRUE

	w_class = ITEM_SIZE_HUGE
	max_volume = ITEM_SIZE_TITANIC + 3

	joint = "neck"
	amputation_point = "spine"
	encased = "ribcage"
	cavity_name = "thoracic cavity"

/datum/organ_description/groin
	name = "lower body"
	surgery_name = "lower abdomen"
	organ_tag = BP_GROIN
	body_part = LOWER_TORSO
	parent_organ_base = BP_CHEST
	default_type = /obj/item/organ/external/groin
	default_bone_type = /obj/item/organ/internal/bone/groin

	max_damage = 100
	min_broken_damage = 60
	nerve_struck = -1

	w_class = ITEM_SIZE_BULKY
	max_volume = ITEM_SIZE_COLOSSAL + 2

	joint = "hip"
	amputation_point = "lumbar"
	cavity_name = "abdominal cavity"

/datum/organ_description/head
	name = "head"
	surgery_name = "head" // Prevents "Unknown's Unkonwn's head" from popping up if the head was amputated and then reattached
	organ_tag = BP_HEAD
	body_part = HEAD
	parent_organ_base = BP_CHEST
	default_type = /obj/item/organ/external/head
	default_bone_type = /obj/item/organ/internal/bone/head

	max_damage = 90
	min_broken_damage = 60
	vital = TRUE

	w_class = ITEM_SIZE_NORMAL
	max_volume = ITEM_SIZE_TITANIC + 1

	joint = "jaw"
	amputation_point = "neck"
	encased = "skull"
	cavity_name = "cranial cavity"

	drop_on_remove = list(slot_glasses, slot_head, slot_l_ear, slot_r_ear, slot_wear_mask)
	functions = BODYPART_REAGENT_INTAKE | BODYPART_GAS_INTAKE

/datum/organ_description/arm
	parent_organ_base = BP_CHEST

	w_class = ITEM_SIZE_BULKY

	max_damage = 50
	min_broken_damage = 50

	functions = BODYPART_GRASP

/datum/organ_description/arm/left
	name = "left arm"
	organ_tag = BP_L_ARM
	body_part = ARM_LEFT
	icon_position = LEFT
	default_bone_type = /obj/item/organ/internal/bone/l_arm

	joint = "left elbow"
	amputation_point = "left shoulder"

/datum/organ_description/arm/left/full
	additional_limb_parts = BP_L_ARM_EXTRA

/datum/organ_description/arm/right
	name = "right arm"
	organ_tag = BP_R_ARM
	body_part = ARM_RIGHT
	icon_position = RIGHT
	default_bone_type = /obj/item/organ/internal/bone/r_arm

	joint = "right elbow"
	amputation_point = "right shoulder"

/datum/organ_description/arm/right/full
	additional_limb_parts = BP_R_ARM_EXTRA

/datum/organ_description/leg
	parent_organ_base = BP_GROIN

	w_class = ITEM_SIZE_BULKY

	max_damage = 60
	min_broken_damage = 50

	functions = BODYPART_STAND

/datum/organ_description/leg/left
	name = "left leg"
	organ_tag = BP_L_LEG
	body_part = LEG_LEFT
	icon_position = LEFT
	default_bone_type = /obj/item/organ/internal/bone/l_leg

	joint = "left knee"
	amputation_point = "left hip"

/datum/organ_description/leg/left/full
	additional_limb_parts = BP_L_LEG_EXTRA

/datum/organ_description/leg/right
	name = "right leg"
	organ_tag = BP_R_LEG
	body_part = LEG_RIGHT
	icon_position = RIGHT
	default_bone_type = /obj/item/organ/internal/bone/r_leg

	joint = "right knee"
	amputation_point = "right hip"

/datum/organ_description/leg/right/full
	additional_limb_parts = BP_R_LEG_EXTRA

////SLIME////
/datum/organ_description/chest/slime
	name = "upper body"
	default_type = /obj/item/organ/external/slime
	default_bone_type = /obj/item/organ/internal/bone/slime

/datum/organ_description/groin/slime
	name = "groin"
	default_type = /obj/item/organ/external/slime
	default_bone_type = /obj/item/organ/internal/bone/slime

/datum/organ_description/head/slime
	default_type = /obj/item/organ/external/slime
	default_bone_type = /obj/item/organ/internal/bone/slime
	vital = FALSE
	functions = BODYPART_REAGENT_INTAKE

/datum/organ_description/arm/left/slime
	default_type = /obj/item/organ/external/slime
	default_bone_type = /obj/item/organ/internal/bone/slime

/datum/organ_description/arm/right/slime
	default_type = /obj/item/organ/external/slime
	default_bone_type = /obj/item/organ/internal/bone/slime

/datum/organ_description/leg/left/slime
	default_type = /obj/item/organ/external/slime
	default_bone_type = /obj/item/organ/internal/bone/slime

/datum/organ_description/leg/right/slime
	default_type = /obj/item/organ/external/slime
	default_bone_type = /obj/item/organ/internal/bone/slime

////SYNTHETIC////
//PIRS
/datum/organ_description/chest/capsa_synthetic
	default_type = /obj/item/organ/external/robotic/moebius

/datum/organ_description/groin/capsa_synthetic
	default_type = /obj/item/organ/external/robotic/moebius

/datum/organ_description/head/capsa_synthetic
	default_type = /obj/item/organ/external/robotic/moebius
	functions = null

/datum/organ_description/arm/left/capsa_synthetic
	default_type = /obj/item/organ/external/robotic/moebius

/datum/organ_description/arm/right/capsa_synthetic
	default_type = /obj/item/organ/external/robotic/moebius

/datum/organ_description/leg/left/capsa_synthetic
	default_type = /obj/item/organ/external/robotic/moebius

/datum/organ_description/leg/right/capsa_synthetic
	default_type = /obj/item/organ/external/robotic/moebius

//"Full" Body part descriptions. Allows icons to overlay on hands & feet correctly.
/datum/organ_description/arm/left/capsa_synthetic/full
	additional_limb_parts = BP_L_ARM_EXTRA
/datum/organ_description/arm/right/capsa_synthetic/full
	additional_limb_parts = BP_R_ARM_EXTRA
/datum/organ_description/leg/left/capsa_synthetic/full
	additional_limb_parts = BP_L_LEG_EXTRA
/datum/organ_description/leg/right/capsa_synthetic/full
	additional_limb_parts = BP_R_LEG_EXTRA

//Union
/datum/organ_description/chest/terra_therma_synthetic
	default_type = /obj/item/organ/external/robotic/technomancer

/datum/organ_description/groin/terra_therma_synthetic
	default_type = /obj/item/organ/external/robotic/technomancer

/datum/organ_description/head/terra_therma_synthetic
	default_type = /obj/item/organ/external/robotic/technomancer
	functions = null

/datum/organ_description/arm/left/terra_therma_synthetic
	default_type = /obj/item/organ/external/robotic/technomancer

/datum/organ_description/arm/right/terra_therma_synthetic
	default_type = /obj/item/organ/external/robotic/technomancer

/datum/organ_description/leg/left/terra_therma_synthetic
	default_type = /obj/item/organ/external/robotic/technomancer

/datum/organ_description/leg/right/terra_therma_synthetic
	default_type = /obj/item/organ/external/robotic/technomancer


/datum/organ_description/arm/left/terra_therma_synthetic/full
	additional_limb_parts = BP_L_ARM_EXTRA
/datum/organ_description/arm/right/terra_therma_synthetic/full
	additional_limb_parts = BP_R_ARM_EXTRA
/datum/organ_description/leg/left/terra_therma_synthetic/full
	additional_limb_parts = BP_L_LEG_EXTRA
/datum/organ_description/leg/right/terra_therma_synthetic/full
	additional_limb_parts = BP_R_LEG_EXTRA


// Church
/datum/organ_description/chest/church_synthetic
	default_type = /obj/item/organ/external/robotic/church

/datum/organ_description/groin/church_synthetic
	default_type = /obj/item/organ/external/robotic/church

/datum/organ_description/head/church_synthetic
	default_type = /obj/item/organ/external/robotic/church
	functions = null

/datum/organ_description/arm/left/church_synthetic
	default_type = /obj/item/organ/external/robotic/church

/datum/organ_description/arm/right/church_synthetic
	default_type = /obj/item/organ/external/robotic/church

/datum/organ_description/leg/left/church_synthetic
	default_type = /obj/item/organ/external/robotic/church

/datum/organ_description/leg/right/church_synthetic
	default_type = /obj/item/organ/external/robotic/church

/datum/organ_description/arm/left/church_synthetic/full
	additional_limb_parts = BP_L_ARM_EXTRA
/datum/organ_description/arm/right/church_synthetic/full
	additional_limb_parts = BP_R_ARM_EXTRA
/datum/organ_description/leg/left/church_synthetic/full
	additional_limb_parts = BP_L_LEG_EXTRA
/datum/organ_description/leg/right/church_synthetic/full
	additional_limb_parts = BP_R_LEG_EXTRA

////SKELETON////
/datum/organ_description/chest/skeletal
	name = "ribcage"
	max_damage = 20
	min_broken_damage = 5
	max_volume = 1
	default_type = /obj/item/organ/external/skeletal/chest

/datum/organ_description/groin/skeletal
	name = "pelvis"
	max_damage = 20
	min_broken_damage = 5
	max_volume = 1
	default_type = /obj/item/organ/external/skeletal/groin

/datum/organ_description/head/skeletal
	max_damage = 20
	min_broken_damage = 5
	max_volume = 1
	default_type = /obj/item/organ/external/skeletal/head

/datum/organ_description/arm/left/skeletal
	max_damage = 20
	min_broken_damage = 5
	max_volume = 1
	default_type = /obj/item/organ/external/skeletal

/datum/organ_description/arm/right/skeletal
	max_damage = 20
	min_broken_damage = 5
	max_volume = 1
	default_type = /obj/item/organ/external/skeletal

/datum/organ_description/leg/left/skeletal
	max_damage = 20
	min_broken_damage = 5
	max_volume = 1
	default_type = /obj/item/organ/external/skeletal

/datum/organ_description/leg/right/skeletal
	max_damage = 20
	min_broken_damage = 5
	max_volume = 1
	default_type = /obj/item/organ/external/skeletal
