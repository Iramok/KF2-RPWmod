//2017.4.16 ����J�n
//4.17 �֎~�p�[�N�̔���A�E�F�[�u���̔���͂ł���(�E�ցE)
//4.18 �֎~���킪����̂ŃJ�j������������ �� �L���X�g�[�b�I�֎~������J�j�������ł����I
//4.19 config�F�c�Ƃ肠�����`�ɂ͂Ȃ��������B
//4.20 ����Ɋւ��Ă͑��E�łȂ�������Ƃ����`�ɕύX�BDOSH�ɂ�镪��,���b�Z�[�W��ǉ��B
//4.22 �Ȃ��璍�����E�����Ă���E�E�E
//4.25 ��������Ɏl�ꔪ��A�悤�₭�`�ɂȂ邩�c�H
//4.27 ���O�̌����Ȃ񂶂���(�Q�['A`�F) ����mod�̂����Ȃ̂������������A�y�������͂��Ă�����
//4.28 ���ς�炸�I�̃��O�͂Ƃꂸ �Ƃ肠�����A�[�}�[�ƃO���̕�[�@�\�����Ă݂�
//5.16 ����J�n����͂�ꃖ���c�����������ƂčX�V�ł� traderdash���Ă݂�
//6.03 �g���[�_�[���̃p�[�N�ύX������͖����ł���gg

class RestrictPW extends KFMutator
	config(RestrictPW);

//<<---config�p�ϐ��̒�`--->>//

	/* Init Config */
		//config�t�@�C�����݂̊m�F
		var config bool bIWontInitThisConfig;
	/* Perk Settings */
		var config string MinPerkLevel_Berserker;
		var config string MinPerkLevel_Commando;
		var config string MinPerkLevel_Support;
		var config string MinPerkLevel_FieldMedic;
		var config string MinPerkLevel_Demolitionist;
		var config string MinPerkLevel_Firebug;
		var config string MinPerkLevel_Gunslinger;
		var config string MinPerkLevel_Sharpshooter;
		var config string MinPerkLevel_Survivalist;
		var config string MinPerkLevel_Swat;
	/* Weapon Settings */
		var config string StartingWeapons_Berserker;
		var config string StartingWeapons_Commando;
		var config string StartingWeapons_Support;
		var config string StartingWeapons_FieldMedic;
		var config string StartingWeapons_Demolitionist;
		var config string StartingWeapons_Firebug;
		var config string StartingWeapons_Gunslinger;
		var config string StartingWeapons_Sharpshooter;
		var config string StartingWeapons_Survivalist;
		var config string StartingWeapons_Swat;
		var config string DisableWeapons;
		var config string DisableWeapons_Boss;
	/* Player Settings */
		var config bool bStartingWeapon_AmmoFull;
		var config bool bPlayer_SpawnWithFullArmor;
		var config bool bPlayer_SpawnWithFullGrenade;
		var config bool bEnableTraderDash;
		var config bool bDisableTeamCollisionWithTraderDash;
	/* Wave Settings */
		var config byte MaxPlayer_TotalZedsCount;
		var config byte MaxPlayer_ZedHealth;
		var config string MaxMonsters;
		var config string SpawnTwoBossesName;
		var config bool bFixZedHealth_6P;
	/* */

//<<---global�ϐ��̒�`--->>//
	//WeaponConfig�N���X
		var WeaponConfig WeapCfg;
	//�E�F�[�u�^�C�v���ʂ�enum�^�̒�`
		enum eWaveType{
			WaveType_Normal,
			WaveType_Boss
		};
	//string -> byte �ϊ��p
		var array<byte> _MinPerkLevel_Berserker;
		var array<byte> _MinPerkLevel_Commando;
		var array<byte> _MinPerkLevel_Support;
		var array<byte> _MinPerkLevel_FieldMedic;
		var array<byte> _MinPerkLevel_Demolitionist;
		var array<byte> _MinPerkLevel_Firebug;
		var array<byte> _MinPerkLevel_Gunslinger;
		var array<byte> _MinPerkLevel_Sharpshooter;
		var array<byte> _MinPerkLevel_Survivalist;
		var array<byte> _MinPerkLevel_Swat;
		var array<int> _MaxMonsters;
	//SendRestrictMessageString�p
		var KFPlayerController RMPC;
		var string RMStr;
	//IsWeaponRestricted�p
		var array<string> aDisableWeapons,aDisableWeapons_Boss;
	//CheckTraderState�p
		var bool bOpened;
	//SetCustomMaxMonsters�p
		var bool bUseMaxMonsters;
	//FillArmorOrGrenades �A�[�}�[�E�O���l�[�h�̗\���[�p
		var array<KFPawn_Human> PlayerToFillArmGre;
	//RestrictMessage�p
		struct RestrictMessageInfo {
			var KFPlayerController KFPC;
			var string Msg;
		};
		var array<RestrictMessageInfo> RMI;
	//CheckSpawnTwoBossSquad�p
		var bool bSpawnTwoBossSquad;
	//
	
//<<---�萔�̒�`--->>//

	//�����p�[�N�g�p���̃��C�t�����l�i�g���[�_�[�^�C���j
		const VALUEFORDEAD = 10;
	//ModifyTraderTimePlayerState�p
		const TraderGroundSpeed = 364364.0f;
	//
	
//<<---���b�Z�[�W�֐�--->>//

	function SetRestrictMessagePC(KFPlayerController KFPC) {
		RMPC = KFPC;
	}
	
	function SetRestrictMessageString(string s) {
		RMStr = s;
	}
	
	//�Z�b�g���ꂽ���b�Z�[�W����l�ɑ���
	function SendRestrictMessageString() {
		local string PlayerName;
		PlayerName = RMPC.PlayerReplicationInfo.PlayerName;
		ReserveRestrictMessage(RMPC,PlayerName$RMStr);
	}
	
	//���b�Z�[�W����l�ɑ���
	function SendRestrictMessageStringPC(KFPlayerController KFPC,string s) {
		SetRestrictMessagePC(KFPC);
		SetRestrictMessageString(s);
		SendRestrictMessageString();
	}
	
	//���b�Z�[�W��S���ɑ���
	function SendRestrictMessageStringAll(string s) {
		local KFPlayerController KFPC;
		foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
			ReserveRestrictMessage(KFPC,"RPWmod"$s);
		}
	}
	
	//���b�Z�[�W�̗\��
	function ReserveRestrictMessage(KFPlayerController KFPC,string s) {
		local RestrictMessageInfo addbuf;
		addbuf.KFPC = KFPC;
		addbuf.Msg = s;
		RMI.AddItem(addbuf);
		SetTimer(0.5, false, nameof(SendReserveRestrictMessageTimer));
		
	}
	
	//�^�C�}�[�ɂ�郁�b�Z�[�W�̔��s
	function SendReserveRestrictMessageTimer() {
		local int i;
		//���X�g���̃��b�Z�[�W���������M
			for (i=0;i<RMI.length;++i) {
				RMI[i].KFPC.TeamMessage(RMI[i].KFPC.PlayerReplicationInfo,RMI[i].Msg,'Event');
			}
		//�������I��������b�Z�[�W���폜
			RMI.Remove(0,RMI.length);
		//
	}
		
	

//<<---�������֐�--->>//

	function InitConfigVar() {
		/* Init Config */
			bIWontInitThisConfig = true;
		/* Perk Settings */
			MinPerkLevel_Berserker = "0,0";
			MinPerkLevel_Commando = "0,0";
			MinPerkLevel_Support = "0,0";
			MinPerkLevel_FieldMedic = "0,0";
			MinPerkLevel_Demolitionist = "0,0";
			MinPerkLevel_Firebug = "0,0";
			MinPerkLevel_Gunslinger = "0,0";
			MinPerkLevel_Sharpshooter = "0,0";
			MinPerkLevel_Survivalist = "0,0";
			MinPerkLevel_Swat = "0,0";
		/* Weapon Settings */
			StartingWeapons_Berserker = "";
			StartingWeapons_Commando = "";
			StartingWeapons_Support = "";
			StartingWeapons_FieldMedic = "";
			StartingWeapons_Demolitionist = "";
			StartingWeapons_Firebug = "";
			StartingWeapons_Gunslinger = "";
			StartingWeapons_Sharpshooter = "";
			StartingWeapons_Survivalist = "";
			StartingWeapons_Swat = "";
			DisableWeapons = "";
			DisableWeapons_Boss = "";
		/* Player Settings */
			bStartingWeapon_AmmoFull = false;
			bPlayer_SpawnWithFullArmor = false;
			bPlayer_SpawnWithFullGrenade = false;
			bEnableTraderDash = false;
			bDisableTeamCollisionWithTraderDash = false;
		/* Wave Settings */
			MaxPlayer_TotalZedsCount = 0;
			MaxPlayer_ZedHealth = 0;
			MaxMonsters = "";
			SpawnTwoBossesName = "";
			bFixZedHealth_6P = false;
		/* */
	}
	
	function InitVarFromConfigVar() {
		SetArrayMPL(_MinPerkLevel_Berserker		,MinPerkLevel_Berserker		);
		SetArrayMPL(_MinPerkLevel_Commando		,MinPerkLevel_Commando		);
		SetArrayMPL(_MinPerkLevel_Support		,MinPerkLevel_Support		);
		SetArrayMPL(_MinPerkLevel_FieldMedic	,MinPerkLevel_FieldMedic	);
		SetArrayMPL(_MinPerkLevel_Demolitionist	,MinPerkLevel_Demolitionist	);
		SetArrayMPL(_MinPerkLevel_Firebug		,MinPerkLevel_Firebug		);
		SetArrayMPL(_MinPerkLevel_Gunslinger	,MinPerkLevel_Gunslinger	);
		SetArrayMPL(_MinPerkLevel_Sharpshooter	,MinPerkLevel_Sharpshooter	);
		SetArrayMPL(_MinPerkLevel_Survivalist	,MinPerkLevel_Survivalist)	;
		SetArrayMPL(_MinPerkLevel_Swat			,MinPerkLevel_Swat			);
		InitDisableWeaponClass(DisableWeapons,aDisableWeapons);
		InitDisableWeaponClass(DisableWeapons_Boss,aDisableWeapons_Boss);
		SetArrayMM(_MaxMonsters,MaxMonsters);
	}
	
	//InitVarFromConfigVar�̃T�u�֐�1
	function SetArrayMPL(out array<byte> _MPL,String MPL) {
		local array<String> splitbuf;
		ParseStringIntoArray(MPL,splitbuf,",",true);
		_MPL[WaveType_Normal] = byte(splitbuf[0]);
		_MPL[WaveType_Boss] = byte(splitbuf[1]);
	};
	
	//InitVarFromConfigVar�̃T�u�֐�2
	function SetArrayMM(out array<int> _MM,String MM) {
		local string buf;
		local array<String> splitbuf;
		ParseStringIntoArray(MM,splitbuf,",",true);
		foreach splitbuf(buf) {
			_MM.AddItem(int(buf));
		}
	}
	
	//IsWeaponRestricted�p�̏������֐�
	function InitDisableWeaponClass(string StrDW,out array<string> aStrDW) {
		local string buf;
		local array<String> splitbuf;
		local class<Weapon> cWbuf;
		ParseStringIntoArray(StrDW,splitbuf,",",true);
		foreach splitbuf(buf) {
			cWbuf = GetWeapClassFromString("KFGameContent.KFWeap_" $buf);
			if (cWbuf!=None) aStrDW.AddItem(cWbuf.default.ItemName);
		}
	}

//<<---�^�C�}�[�֐�--->>//

	
	event Tick( float DeltaTime ) {
		super.Tick(DeltaTime);
		if (WeapCfg!=None) {
			if (WeapCfg.bUseWeaponConfig) WeapCfg.Tick();
		}
	}

//<<---�R�[���o�b�N�֐�(PostBeginPlay)--->>//

	//�Q�[���J�n���Ɉ�x�����Ă΂����ۂ��`
	function PostBeginPlay() {
		Super.PostBeginPlay();
		//WeaponConfig
//			WeapCfg = Spawn(class'WeaponConfig');
			WeapCfg = New(Self) class'WeaponConfig';
			WeapCfg.PostBeginPlay();
//			SetTimer(5.0f,true,nameof(test));
		//.ini�̏����ݒ�
			if (!bIWontInitThisConfig) InitConfigVar();
			SaveConfig();
			InitVarFromConfigVar();
		//CheckTraderState�p
			bOpened = true;
		//SetCustomMaxMonsters�p
			bUseMaxMonsters = (MaxMonsters!="");
		//1.0�b���Ƃɓ���̊֐����Ă� bool�l�͌J��Ԃ��ĂԂ��ǂ���
			SetTimer(1.0, true, nameof(JudgePlayers));
			SetTimer(0.25, true, nameof(CheckTraderState));
			SetTimer(1.0, true, nameof(CheckSpawnTwoBossSquad));
		//
	}
	
//<<---�R�[���o�b�N�֐�(ModifyAIEnemy)--->>//
	
	/**
	
	//Controller.uc�� var Pawn Enemy
	function ModifyAIEnemy( AIController AI, Pawn Enemy ) {
		//�X�[�p�[�̏���
			super.ModifyAIEnemy(AI,Enemy);
		//
		local bool bDisableSwitchEnemysTarget;
		bDisableSwitchEnemysTarget = false;
		bDisableSwitchEnemysTarget = true;
		
		if (bDisableSwitchEnemysTarget) {
			super.ModifyAIEnemy( AI, (AI.Enemy==None) ? Enemy : AI.Enemy );
		}
	}
	
	**/
	
//<<---�R�[���o�b�N�֐�(ModifyAI)--->>//
	
	function ModifyAI(Pawn AIPawn) {
		//�X�[�p�[�̏���
			super.ModifyAI( AIPawn );
		//�ꉞ�����X�^�[������
			if (KFPawn_Monster(AIPawn)==None) return;
		//HP��ύX
			if (MaxPlayer_ZedHealth>0) {
				SetMonsterDefaultsMut(KFPawn_Monster(AIPawn),
					min( MyKFGI.GetLivingPlayerCount(), MaxPlayer_ZedHealth ));
			}
		//�Œ�HP�̕����D��x������
			if (bFixZedHealth_6P) {
				//�{�X�Ɋւ��Ă͖���
				if ( (KFPawn_ZedHans(AIPawn)!=None) || (KFPawn_ZedPatriarch(AIPawn)!=None) ) {
					return;
				}
				SetMonsterDefaultsMut(KFPawn_Monster(AIPawn),6);
			}
		//
	}
	
	//In KFGameInfo.uc function SetMonsterDefaults
	function SetMonsterDefaultsMut(KFPawn_Monster P,byte LivingPlayer) {
		local float HealthMod,HeadHealthMod;
		local int LivingPlayerCount;
		//���傫��
			LivingPlayerCount = LivingPlayer;
			HealthMod = 1.0;
			HeadHealthMod = 1.0;
		// Scale health and damage by game conductor values for versus zeds
			if( P.bVersusZed ) {
				MyKFGI.DifficultyInfo.GetVersusHealthModifier(P, LivingPlayerCount, HealthMod, HeadHealthMod);
				HealthMod *= MyKFGI.GameConductor.CurrentVersusZedHealthMod;
				HeadHealthMod *= MyKFGI.GameConductor.CurrentVersusZedHealthMod;
			}else{
				MyKFGI.DifficultyInfo.GetAIHealthModifier(P, MyKFGI.GameDifficulty, LivingPlayerCount, HealthMod, HeadHealthMod);
			}
		// Scale health by difficulty
			P.Health = P.default.Health * HealthMod;
			if( P.default.HealthMax == 0 ){
			   	P.HealthMax = P.default.Health * HealthMod;
			}else{
			   	P.HealthMax = P.default.HealthMax * HealthMod;
			}
			P.ApplySpecialZoneHealthMod(HeadHealthMod);
			P.GameResistancePct = MyKFGI.DifficultyInfo.GetDamageResistanceModifier(LivingPlayerCount);
		//
	}


//<<---�R�[���o�b�N�֐�(ModifyPlayer)--->>//

	//�v���C���[���������ꂽ�Ƃ��Ɉ�x�����Ă΂��
	function ModifyPlayer(Pawn Other) {
		local KFPawn Player;
		local KFPlayerController KFPC;
		local class<KFPerk> cKFP;
		local class<Weapon> cRetW;
		local Inventory Inv;
		local bool bFound;
		//�X�[�p�[�̏���
			super.ModifyPlayer(Other);
		//���
			Player = KFPawn_Human(Other);
			KFPC = KFPlayerController(Player.Controller);
			cKFP = KFPC.GetPerk().GetPerkClass();
		//SpawnHumanPawn�Ɋւ��Ă͖���
			if (IsBotPlayer(KFPC)) return;
		//���������̕ύX��̏����擾 �ύX�����ꍇ�̂ݏ���
			cRetW = GetStartingWeapClassFromPerk(cKFP);
			if (cRetW!=None) {
				//�v���C���[���珉���������͂��D �T�o�C�o���X�g���l�����đS�p�[�N����Ŕ���
					bFound = False;
					for(Inv=Player.InvManager.InventoryChain;Inv!=None;Inv=Inv.Inventory) {
						switch(Inv.ItemName) {
							case class'KFGameContent.KFWeap_Blunt_Crovel'.default.ItemName:
							case class'KFGameContent.KFWeap_AssaultRifle_AR15'.default.ItemName:
							case class'KFGameContent.KFWeap_Shotgun_MB500'.default.ItemName:
							case class'KFGameContent.KFWeap_Pistol_Medic'.default.ItemName:
							case class'KFGameContent.KFWeap_GrenadeLauncher_HX25'.default.ItemName:
							case class'KFGameContent.KFWeap_Flame_CaulkBurn'.default.ItemName:
							case class'KFGameContent.KFWeap_Revolver_DualRem1858'.default.ItemName:
							case class'KFGameContent.KFWeap_Rifle_Winchester1894'.default.ItemName:
							case class'KFGameContent.KFWeap_SMG_MP7'.default.ItemName:
								Player.InvManager.RemoveFromInventory(Inv);
								bFound = True;
								break;
						}
						if (bFound) break;
					}
				//����̂Ɓ[�ɂ�[
					Player.Weapon = Weapon(Player.CreateInventory(cRetW,Player.Weapon!=None));
				//����̑���
					Player.InvManager.ServerSetCurrentWeapon(Player.Weapon);
				//�e��̕�[ 
					if (bStartingWeapon_AmmoFull) FillWeaponAmmo(KFWeapon(Player.Weapon));
				//�A�[�}�[�E�O���l�[�h�̕�[�\�� �Ώ��Ö@�I�Ȃ̂Ńo�O��\�������邪�c �����Ȃ����ꍇ��KFPerk����Init��j�~���邵���Ȃ��Ȃ�
					PlayerToFillArmGre.AddItem(KFPawn_Human(Other));
					SetTimer(0.25, false, nameof(FillArmorOrGrenades)); //�Ăяo����1��Ȃ̂�false
				//
			}
		//�����I��
	}
	
	//����₭�ق���[
	function FillWeaponAmmo(KFWeapon W) {
		if ( W.AddAmmo(114514) != 0 ) FillWeaponAmmo(W);
		if ( W.AddSecondaryAmmo(114514) != 0 ) FillWeaponAmmo(W);
	}
	
	//�O���ƃA�[�}�[�́i�\��j�ق���[
	function FillArmorOrGrenades() {
		local KFPawn_Human Player;
		local int i;
		//��[�Ώێ҂̃��X�g������
			for (i=0;i<PlayerToFillArmGre.length;++i) {
				Player = PlayerToFillArmGre[i];
				if (Player==None) continue;
				//�A�[�}�[�̕�[
					if (bPlayer_SpawnWithFullArmor) Player.GiveMaxArmor();
				//�O���l�[�h�̕�[
					if (bPlayer_SpawnWithFullGrenade) FillGrenades(KFInventoryManager(Player.InvManager));
				//
			}
		//�������I������v���C���[���폜
			PlayerToFillArmGre.Remove(0,PlayerToFillArmGre.length);
		//
	}
	
	//�O����[�p
	function FillGrenades(KFInventoryManager KFIM) {
		if (KFIM.AddGrenades(1)) FillGrenades(KFIM);
	}
	
	//Are you SpawnHumanPawn?
	function bool IsBotPlayer(KFPlayerController KFPC){
		return (KFPC.PlayerReplicationInfo.PlayerName=="Braindead Human");
	}

//<<---�J�n����̏�����--->>//
	
	//���݂̃p�[�N����N���X�̎擾�B
	function class<Weapon> GetStartingWeapClassFromPerk(class<KFPerk> Perk) {
		local string SendStr;
		local array<String> SplitBuf;
		SendStr = "";
		switch(Perk) {
			case class'KFPerk_Berserker':
				SendStr = StartingWeapons_Berserker;
				break;
			case class'KFPerk_Commando':
				SendStr = StartingWeapons_Commando;
				break;
			case class'KFPerk_Support':
				SendStr = StartingWeapons_Support;
				break;
			case class'KFPerk_FieldMedic':
				SendStr = StartingWeapons_FieldMedic;
				break;
			case class'KFPerk_Demolitionist':
				SendStr = StartingWeapons_Demolitionist;
				break;
			case class'KFPerk_Firebug':
				SendStr = StartingWeapons_Firebug;
				break;
			case class'KFPerk_Gunslinger':
				SendStr = StartingWeapons_Gunslinger;
				break;
			case class'KFPerk_Sharpshooter':
				SendStr = StartingWeapons_Sharpshooter;
				break;
			case class'KFPerk_Survivalist':
				SendStr = StartingWeapons_Survivalist;
				break;
			case class'KFPerk_Swat':
				SendStr = StartingWeapons_Swat;
				break;
		}
		if (SendStr=="") return None;
		ParseStringIntoArray(SendStr,SplitBuf,",",true);
		SendStr = "KFGameContent.KFWeap_" $ SplitBuf[Rand(SplitBuf.length)];
		return GetWeapClassFromString(SendStr);
	}
	
	//�����񂩂�N���X�̎擾�B
	function class<Weapon> GetWeapClassFromString(string str) {
		return class<Weapon>(DynamicLoadObject(str, class'Class'));
	}
	
//<<---���C���֐�(CheckSpawnTwoBossSquad)--->>//
	
	//2�̖ڂ̃{�X������ 1.0�b���ƂɌĂяo��
	function CheckSpawnTwoBossSquad() {
		local byte Curwave;
		//������
			Curwave = MyKFGI.MyKFGRI.WaveNum;
		//�E�F�[�u���J�n����Ă��Ȃ��ꍇ�͂ǂ��ł�����
			if (!(Curwave>=1)) return;
		//�����I�Ƀ{�X�E�F�[�u�ɂ���e�X�g�R�[�h
//			if (Curwave<MyKFGI.MyKFGRI.WaveMax) KFGameInfo_Survival(MyKFGI).WaveEnded(WEC_WaveWon);
		//�{�X2�̂̏�������
			if (Curwave==MyKFGI.MyKFGRI.WaveMax) {
				if (bSpawnTwoBossSquad) {
					MyKFGI.SpawnManager.TimeUntilNextSpawn = 10;
					SetTimer(5.0, false, nameof(SpawnTwoBosses));
					bSpawnTwoBossSquad = false;
				}
			}else{
				bSpawnTwoBossSquad = true;
			}
		//
	}
	
	function SpawnTwoBosses() {
		local array<class<KFPawn_Monster> > SpawnList;
		local array<String> SplitBuf;
		local string Buf;
		if (SpawnTwoBossesName=="") {
			MyKFGI.SpawnManager.TimeUntilNextSpawn = 0;
			return;
		}
		ParseStringIntoArray(SpawnTwoBossesName,SplitBuf,",",true);
		foreach SplitBuf(Buf) {
			if (Buf=="Rand") {
				if (Rand(2)==0) {
					Buf = "Hans";
				}else{
					Buf = "Pat";
				}
			}
			if (Buf=="Hans") SpawnList.AddItem(class'KFPawn_ZedHans');
			if (Buf=="Pat") SpawnList.AddItem(class'KFPawn_ZedPatriarch');
//			SendRestrictMessageStringAll(Buf);
		}
		MyKFGI.NumAISpawnsQueued += MyKFGI.SpawnManager.SpawnSquad( SpawnList );
		MyKFGI.SpawnManager.TimeUntilNextSpawn = MyKFGI.SpawnManager.CalcNextGroupSpawnTime();
	}
	
//<<---���C���֐�(CheckTraderState)--->>//
	
	function CheckTraderState() {
		local byte PlayerCount;
		//�E�F�[�u���J�n����Ă��Ȃ��ꍇ�͂ǂ��ł�����
			if (!(MyKFGI.MyKFGRI.WaveNum>=1)) return;
		//���X�����܂�܂����`��
			if ( (MyKFGI.MyKFGRI.bTraderIsOpen==false) && (bOpened==true) ) {
				//TotalAICount,Maxmonsters ���Judge�֐������Ŏ��l���̕��ׂ��p�[�e�B�ɂ����Ȃ��悤�ɂ���
					JudgePlayers();
					PlayerCount = MyKFGI.GetLivingPlayerCount();
					if (PlayerCount>0) {
						//�l���ߑ��̏ꍇ��TotalZed�����炷 bosswave�ȊO�ł̂ݎ��s
							if ( (MaxPlayer_TotalZedsCount>0) 
								&& (PlayerCount>MaxPlayer_TotalZedsCount)
								&& (MyKFGI.MyKFGRI.WaveNum<MyKFGI.MyKFGRI.WaveMax) ) {
									SetCustomTotalAICount(PlayerCount);
							}
						//������������ύX
							if (bUseMaxMonsters) SetCustomMaxMonsters(PlayerCount);
						//
					}
				//���鑬�x�����ɖ߂�
					ModifyTraderTimePlayerState(false);
				//
			}
		//���X�������Ă܂��`��
			if ( MyKFGI.MyKFGRI.bTraderIsOpen==true ) {
				ModifyTraderTimePlayerState(true);
			}
		//��Ԃ̕ۑ�
			bOpened = MyKFGI.MyKFGRI.bTraderIsOpen;
		//
	}
	//�E�F�[�u�ŕ���MOB���̒��� �Q�l�� 'KFAISpawnManager.uc' func: SetupNextWave
	function SetCustomTotalAICount(byte PlayerCount) {
		local int OldAIcount,AIcount;
		OldAIcount = MyKFGI.SpawnManager.WaveTotalAI;
		AIcount = 	MyKFGI.SpawnManager.WaveSettings.Waves[ MyKFGI.MyKFGRI.WaveNum-1 ].MaxAI *
					MyKFGI.DifficultyInfo.GetPlayerNumMaxAIModifier( MaxPlayer_TotalZedsCount ) *
					MyKFGI.DifficultyInfo.GetDifficultyMaxAIModifier();
		MyKFGI.SpawnManager.WaveTotalAI = AIcount;
		MyKFGI.MyKFGRI.AIRemaining = AIcount;
		MyKFGI.MyKFGRI.WaveTotalAICount = AIcount;
		SendRestrictMessageStringAll("::SetTotalZedsCount "$OldAIcount$"->"$AIcount);
	}
	
	//�����������̒���
	function SetCustomMaxMonsters(byte PlayerCount) {
		local int MaxZeds;
		MaxZeds = min ( 255, _MaxMonsters[min( PlayerCount-1, _MaxMonsters.length-1 )] );
		MyKFGI.SpawnManager.MaxMonstersSolo[int(MyKFGI.GameDifficulty)] = byte(MaxZeds);
		MyKFGI.SpawnManager.MaxMonsters = byte(MaxZeds);
		SendRestrictMessageStringAll("::SetMaxMonsters "$byte(MaxZeds));
	}
	
	//�g���[�_�[�J�X�y�ѕX���̃v���C���[�̏�Ԃ̕ύX
	function ModifyTraderTimePlayerState(bool bOpenTrader) {
		local KFPlayerController KFPC;
		local KFPawn Player;
/*		//�g���[�_�[���̃p�[�N�ύX�Ɋւ���ݒ�
			if (bAllowChangingPerkAnytimeInTraderTime && bOpenTrader ) {
					foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
						if (KFPC!=None) KFPC.SetHaveUpdatePerk(false);
//KFPC.TeamMessage(KFPC.PlayerReplicationInfo,"No,match::?"$KFGameReplicationInfo(KFPC.WorldInfo.GRI).bMatchHasBegun,'Event');
					}
				}
			}*/
		//�g���[�_�[�_�b�V���Ɋւ���ݒ�
			if (bEnableTraderDash) {
				foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
					Player = KFPawn(KFPC.Pawn);
					if (Player!=None) {
						SetCustomSpeedAndCollision(Player,bOpenTrader);
					}
				}
			}
		//
	}
	
	//�ړ����x�ƃR���W�����̕ύX
	function SetCustomSpeedAndCollision(KFPawn Player,bool bOpenTrader) {
		//�X�s�[�h�̕ύX (�i�C�t�������Ă鎞)
			if ( bOpenTrader && IsPlayerKnifeOut(Player) ) {
				Player.GroundSpeed = TraderGroundSpeed;
			}else{
				Player.UpdateGroundSpeed();
			}
		//�R���W�����̗L��
			if (bDisableTeamCollisionWithTraderDash) {
				Player.bIgnoreTeamCollision = bOpenTrader ? true : MyKFGI.bDisableTeamCollision;
			}
		//
	}

	//�i�C�t�������Ă��邩
	function bool IsPlayerKnifeOut(KFPawn Player) {
		return (KFWeap_Edged_Knife(Player.Weapon)!=None);
	}

//<<---���C���֐�(JudgePlayers)--->>//
	
	//�v���C���[�ɍق����I
	function JudgePlayers() {
		local KFPlayerController KFPC;
		local eWaveType eWT;
		//�E�F�[�u���J�n����Ă��Ȃ��ꍇ�͂ǂ��ł�����
			if (!(MyKFGI.MyKFGRI.WaveNum>=1)) return;
		//���݃E�F�[�u���ʏ킩�{�X�� WaveNum�����݂̃E�F�[�u�AWaveMax�͍ő�E�F�[�u
			eWT =  ( MyKFGI.MyKFGRI.WaveNum < MyKFGI.MyKFGRI.WaveMax - ( MyKFGI.MyKFGRI.bTraderIsOpen ? 1 : 0 ) ) ? WaveType_Normal : WaveType_Boss;
		//�SPC�ɑ΂��Ĕ��� SpawnHumanPawn�Ɋւ��Ă͖���
			foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
				if (!IsBotPlayer(KFPC)) {
					JudgeSpecificPlayer(KFPC,eWT);
				}
			}
		//
	}
	
	//JudgePlayers�̃T�u�֐�
	function JudgeSpecificPlayer(KFPlayerController KFPC,eWaveType eWT) {
		local Pawn Player;
		local Weapon CurWeapon;
		//���݂��Ȃ��v���C���[���
			if (KFPC.Pawn==None) return;
		//������
			Player = KFPC.Pawn;
			CurWeapon = Player.Weapon;
		//���b�Z�[�W�̑��M������̃v���C���[�ɐݒ�
			SetRestrictMessagePC(KFPC);
		//�֎~������g�p���Ă���ꍇ�͋����I�ɏ��ł����� Old: KFPC.ServerThrowOtherWeapon(CurWeapon);
			if (IsWeaponRestricted(CurWeapon,eWT)) {
				SendRestrictMessageString();
				CurWeapon.Destroyed();
			}
		//�p�[�N�̃��x�������ɂЂ��������Ă��� �g���[�_�[���J���Ă���Ȃ�HP�����炷 �����łȂ���ΎE��
			if (IsPerkLevelRestricted(KFPC.GetPerk().GetPerkClass(), KFPC.GetPerk().GetLevel(),eWT )) {
				if (MyKFGI.MyKFGRI.bTraderIsOpen) {
					Player.Health = max(Player.Health-VALUEFORDEAD,1);
				}else if (Player.Health>=0) {
					SendRestrictMessageString();
					player.FellOutOfWorld(none);
				}
			}
		//
	}

//<<---��������֐�--->>//
		
	//�p�[�N���x���������𖞂����Ă��邩�ǂ���
	function bool IsPerkLevelRestricted(class<KFPerk> Perk,byte PerkLevel,eWaveType eWT) {
		switch(Perk) {
			case class'KFPerk_Berserker':
				return IsBadPerkLevel(_MinPerkLevel_Berserker[eWT],PerkLevel,Perk);
			case class'KFPerk_Commando':
				return IsBadPerkLevel(_MinPerkLevel_Commando[eWT],PerkLevel,Perk);
			case class'KFPerk_Support':
				return IsBadPerkLevel(_MinPerkLevel_Support[eWT],PerkLevel,Perk);
			case class'KFPerk_FieldMedic':
				return IsBadPerkLevel(_MinPerkLevel_FieldMedic[eWT],PerkLevel,Perk);
			case class'KFPerk_Demolitionist':
				return IsBadPerkLevel(_MinPerkLevel_Demolitionist[eWT],PerkLevel,Perk);
			case class'KFPerk_Firebug':
				return IsBadPerkLevel(_MinPerkLevel_Firebug[eWT],PerkLevel,Perk);
			case class'KFPerk_Gunslinger':
				return IsBadPerkLevel(_MinPerkLevel_Gunslinger[eWT],PerkLevel,Perk);
			case class'KFPerk_Sharpshooter':
				return IsBadPerkLevel(_MinPerkLevel_Sharpshooter[eWT],PerkLevel,Perk);
			case class'KFPerk_Survivalist':
				return IsBadPerkLevel(_MinPerkLevel_Survivalist[eWT],PerkLevel,Perk);
			case class'KFPerk_Swat':
				return IsBadPerkLevel(_MinPerkLevel_Swat[eWT],PerkLevel,Perk);
		}
		return false;
	}
	
	//IsPerkLevelRestricted�̃T�u�֐�
	function bool IsBadPerkLevel(byte MinPerkLevel,byte PerkLevel,class<KFPerk> Perk) {
		local string perkname;
		if (!(MinPerkLevel<=PerkLevel)) {
			perkname = Perk.default.PerkName;
			if (MinPerkLevel<=25) {
				SetRestrictMessageString("::FellOutOfWorld::"$perkname$"::NeedLevel"$MinPerkLevel$"(You:"$PerkLevel$")");
			}else{
				SetRestrictMessageString("::FellOutOfWorld::"$perkname$"::RestrictedPerk");
			}
			return true;
		}else{
			return false;
		}
	}

	//�g�p�֎~���킩�ǂ���
	function bool IsWeaponRestricted(Weapon Weap,eWaveType eWT) {
		local array<string> aDWName;
		local string WName,DWName;
		//�O����
			if (KFWeapon(Weap)==None) return false;
			WName = Weap.ItemName;
			if (eWT==WaveType_Normal)	aDWName = aDisableWeapons;
			if (eWT==WaveType_Boss)		aDWName = aDisableWeapons_Boss;
		//�e���했�̔���B
			foreach aDWName(DWName) {
				if (WName==DWName) {
					SetRestrictMessageString("::DestroyWeapon::"$WName$"::RestrictedWeapon");
					return true;
				}
			}
		//
		return false;
	}
	
/////////////////////////////////////////<<---EOF--->>/////////////////////////////////////////
